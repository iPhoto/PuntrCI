//
//  ChooseOpponentViewController.m
//  Puntr
//
//  Created by Artem on 9/6/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ChooseOpponentViewController.h"
#import "ObjectManager.h"
#import "PagingModel.h"
#import "SubscriberModel.h"

#import "UIViewController+Puntr.h"
#import "MZFormSheetController.h"
#import "PushContentViewController.h"
#import "BetViewController.h"
#import "NotificationManager.h"


#define TNFont [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]
#define MAX_RATE 5
#define TAG_STAR_BEGIN 100

static const CGFloat TNHeaderFooterSidePadding = 14.0f;
static const CGFloat TNHeaderFooterTopPadding = 8.0f;

static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNHeightText = 12.0f;

static const CGFloat avatarWidth = 40;

@interface COTableViewCell : UITableViewCell

@property (nonatomic) BOOL isChecked;
@property (nonatomic, weak) id someObject;
@property (nonatomic, weak) UIImageView *avatar;

- (void)setupWithUser:(UserModel *)user;

@end

@implementation COTableViewCell {
    UIImageView *_checkedImageView;
    UIImageView *_uncheckedImageView;
    UILabel *_rate;
    UILabel *_name;
    UIImage *_starSelected;
    UIImage *_starUnselected;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
        _uncheckedImageView = nil;
        
        _rate = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 60, 20)];
        _rate.textAlignment = NSTextAlignmentCenter;
        _rate.font = [UIFont systemFontOfSize:13];
        [self addSubview:_rate];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(avatarWidth + 20, 3, 60, 40)];
        _name.numberOfLines = 2;
        _name.font = [UIFont systemFontOfSize:12];
        [self addSubview:_name];
        
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - avatarWidth) / 2, avatarWidth, avatarWidth)];
        _avatar = avatar;
        _avatar.layer.cornerRadius = 5;
        _avatar.clipsToBounds = YES;
        [self addSubview:_avatar];
        
        _starSelected = [UIImage imageNamed:@"StarSelected"];
        _starUnselected = [UIImage imageNamed:@"StarUnselected"];
        
        //[self initStars];
    }
    return self;
}

- (void)prepareForReuse
{
    [self.avatar cancelImageRequestOperation];
    self.avatar.image = nil;
}

- (void)initStars
{
    CGFloat TNSpacingStar = 2.0f;
    CGSize TNSizeStar = CGSizeMake(14.0f, 13.0f);
    
    CGFloat startStars = CGRectGetMaxX(_name.frame) + 6;
    for (NSInteger starIndex = 0; starIndex < MAX_RATE; starIndex++)
    {
        UIImageView *imageViewStar = [[UIImageView alloc] init];
        imageViewStar.frame = CGRectMake(
                                         startStars + ((TNSizeStar.width + TNSpacingStar) * starIndex),
                                         (self.frame.size.height - TNSizeStar.height) / 2,
                                         TNSizeStar.width,
                                         TNSizeStar.height
                                         );
        imageViewStar.tag = TAG_STAR_BEGIN + starIndex;
        [self addSubview:imageViewStar];
    }
}

- (void)setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    if (_isChecked)
    {
        self.accessoryView = _checkedImageView;
    }
    else
    {
        self.accessoryView = _uncheckedImageView;
    }
}

- (void)setupWithUser:(UserModel *)user
{
    self.someObject = user;
    
    _name.text = user.username?:NSLocalizedString(@"User", nil);
    //_avatar.image = user.avatarData;
    
    __weak COTableViewCell *weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:user.avatar];
    [self.avatar setImageWithURLRequest:request
                        placeholderImage:nil
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                 {
                                     if (weakSelf && weakSelf.someObject)
                                     {
                                         if (weakSelf.someObject == user)
                                         {
                                             weakSelf.avatar.image = image;
                                             //[weakSelf setNeedsLayout];
                                         }
                                     }
                                 }
                                 failure:nil];
    
    //[self setupStarsWithRate:user.rating.integerValue];
    _rate.text = [user.rating stringValue];
}

- (void)setupStarsWithRate:(NSInteger)rate
{
    for (NSInteger starIndex = 0; starIndex < MAX_RATE; starIndex++)
    {
        UIImageView *imageViewStar = (UIImageView *)[self viewWithTag:TAG_STAR_BEGIN + starIndex];
        if (starIndex < rate)
        {
            imageViewStar.image = _starSelected;
        }
        else
        {
            imageViewStar.image = _starUnselected;
        }
    }
}

@end





@interface ChooseOpponentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PagingModel *paging;
@property (nonatomic, strong) NSArray *subscribers;
@property (nonatomic) NSInteger checkedIndex;
@property (nonatomic, weak) UITableView *opponentsTableView;

@end



@implementation ChooseOpponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _checkedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MZFormSheetController appearance] setCornerRadius:3.75f];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetController appearance] setShouldDismissOnBackgroundViewTap:YES];
    
    self.title = NSLocalizedString(@"Select opponent", nil);
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    /*
    // custom header
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Select opponent", nil);
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    */
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    //IconShuffle.png
    UIButton *buttonShuffle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [buttonShuffle setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonShuffle setImage:[UIImage imageNamed:@"IconShuffle"] forState:UIControlStateNormal];
    [buttonShuffle addTarget:self action:@selector(shuffleButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shuffleItem = [[UIBarButtonItem alloc] initWithCustomView:buttonShuffle];
    self.navigationItem.leftBarButtonItem = shuffleItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(closeButtonTouched)];
    
    CGRect tableFrame = self.view.bounds;
    tableFrame = CGRectSetHeight(tableFrame, viewHeight - (tabBarHeight + navigationBarHeight));
    tableFrame.size.height -= 60;
    
    UITableView *opponentsTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.opponentsTableView = opponentsTableView;
    self.opponentsTableView.dataSource = self;
    self.opponentsTableView.delegate = self;
    self.opponentsTableView.backgroundView = nil;
    self.opponentsTableView.backgroundColor = [UIColor clearColor];
    self.opponentsTableView.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.opponentsTableView.scrollEnabled = YES;
    [self.view addSubview:self.opponentsTableView];
    
    CGFloat coverMargin = 8.0f;
    CGFloat buttonHeight = 40.0f;
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.bounds.size.height - (tabBarHeight + navigationBarHeight);
    CGFloat buttonWidth = (screenWidth - coverMargin * 5.0f) / 2.0f;
    UIButton *buttonPari = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPari.frame = CGRectMake((screenWidth - buttonWidth) / 2, screenHeight - coverMargin - buttonHeight, buttonWidth, buttonHeight);
    [buttonPari setTitle:NSLocalizedString(@"Bet", nil) forState:UIControlStateNormal];
    buttonPari.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    buttonPari.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    buttonPari.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonPari setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                              forState:UIControlStateNormal];
    [buttonPari addTarget:self action:@selector(pariButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPari];
    
    UIEdgeInsets ei = UIEdgeInsetsMake(1, 1, 1, 1);
    
    UIImage *imageDelimiter = [[UIImage imageNamed:@"delimiter"] resizableImageWithCapInsets:ei];
    CGRect delimiterFrame = CGRectMake(0, CGRectGetMaxY(self.opponentsTableView.frame) + 2, self.view.bounds.size.width, 2);
    UIImageView *delimiter = [[UIImageView alloc] initWithFrame:delimiterFrame];
    delimiter.image = imageDelimiter;
    [self.view addSubview:delimiter];
    
    UIImage *gradientImage = [UIImage imageNamed:@"gradient"]; // resizableImageWithCapInsets:ei];
    CGFloat gradientHeight = 20;
    CGRect gradientFrame = CGRectMake(self.opponentsTableView.frame.origin.x, CGRectGetMaxY(self.opponentsTableView.frame) - (gradientHeight * 0.9), self.opponentsTableView.frame.size.width, gradientHeight);
    UIImageView *gradient = [[UIImageView alloc] initWithFrame:gradientFrame];
    gradient.image = gradientImage;
    [self.view addSubview:gradient];
    
    [self loadSubscriptions];
}

- (void)closeButtonTouched
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shuffleButtonTouched
{
    if ((self.checkedIndex < 0) || (self.subscribers.count > 1))
    {
        NSInteger randomVal;
        do {
            randomVal = arc4random_uniform(self.subscribers.count);
        } while (randomVal == self.checkedIndex);
        
        [self checkRowWithIndex:randomVal];
    }
}

- (void)loadSubscriptions
{
    self.paging = [PagingModel paging];
    [self.paging setDefaultLimit:@NSIntegerMax];
    [self.paging firstPage];
    
    UserModel *user =  [ObjectManager sharedManager].loginedUser;
    [[ObjectManager sharedManager] subscribersForUser:user
                                                 paging:self.paging
                                                success:^(NSArray *subscribers)
     {
         self.subscribers = [NSArray arrayWithArray:subscribers];
//         ((SubscriberModel *)subscribers[0]).user.username = @"qwertyuiop asdfghjkl";
//         self.subscribers = [NSArray arrayWithObjects:subscribers[0], subscribers[1], subscribers[0], subscribers[1], subscribers[0], subscribers[1], subscribers[0], subscribers[1], subscribers[0], subscribers[1], subscribers[0], subscribers[1], subscribers[0], subscribers[1], nil];
         [self.opponentsTableView reloadData];
     }
        failure:^
     {
     }
     ];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subscribers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdFileName = @"middle_area.png";
    if (indexPath.row == 0)
    {
        reuseIdFileName = @"top_area.png";
    }
    if (indexPath.row == self.subscribers.count - 1)
    {
        reuseIdFileName = @"bottom_area.png";
    }
    
    COTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdFileName];
    if (cell == nil)
    {
        cell = [[COTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdFileName];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reuseIdFileName]];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UserModel *user = ((SubscriberModel *)self.subscribers[indexPath.row]).user;
    [cell setupWithUser:user];
    cell.isChecked = (indexPath.row == self.checkedIndex);
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self checkRowWithIndex:indexPath.row];
}



#pragma mark - Utils
- (void)checkRowWithIndex:(NSInteger)index
{
    for (COTableViewCell *cell in self.opponentsTableView.visibleCells) {
        NSIndexPath *ip = [self.opponentsTableView indexPathForCell:cell];
        if (ip.row == self.checkedIndex) {
            cell.isChecked = NO;
        }
        if (ip.row == index) {
            cell.isChecked = YES;
        }
    }
    self.checkedIndex = index;
}

- (void)pariButtonPressed
{
    if (self.checkedIndex >= 0) {
        BetViewController *vc = [BetViewController new];
        BetModel *bet = [BetModel new];
//        bet.event =
        [vc setupWithBet:bet];
        [self presentFormSheetWithViewController:vc
                                        animated:YES
                               completionHandler:^(MZFormSheetController *formSheetController) {
                               }];
    }
    else {
        [NotificationManager showNotificationMessage:NSLocalizedString(@"Select opponent!", nil)]; // чего не показывается то?
    }
}

@end
