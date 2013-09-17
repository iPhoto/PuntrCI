//
//  ChooseOpponentViewController.m
//  Puntr
//
//  Created by Artem on 9/6/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ChooseOpponentViewController.h"
#import "ObjectManager.h"
#import "PagingModel.h"
#import "SubscriberModel.h"


#define TNFont [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]

static const CGFloat TNHeaderFooterSidePadding = 14.0f;
static const CGFloat TNHeaderFooterTopPadding = 8.0f;

static const CGFloat TNMarginGeneral = 8.0f;
static const CGFloat TNHeightText = 12.0f;

static const CGFloat avatarWidth = 40;

@interface COTableViewCell : UITableViewCell

@property (nonatomic) BOOL isChecked;

- (void)setupWithUser:(UserModel *)user;

@end

@implementation COTableViewCell {
    UIImageView *_checkedImageView;
    UIImageView *_uncheckedImageView;
    UILabel *_rate;
    UILabel *_name;
    UIImageView *_avatar;
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
        
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, avatarWidth, avatarWidth)];
        [self addSubview:_avatar];
    }
    return self;
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
    _name.text = user.username?:@"Hmmm userName";
    _avatar.image = user.avatarData;
    
    CGFloat TNSpacingStar = 2.0f;
    CGSize TNSizeStar = CGSizeMake(14.0f, 13.0f);
    
    CGFloat startStars = CGRectGetMaxX(_name.frame) + 6;
    for (NSInteger starIndex = 0; starIndex < 5; starIndex++)
    {
        UIImageView *imageViewStar = [[UIImageView alloc] init];
        imageViewStar.frame = CGRectMake(
                                         startStars + ((TNSizeStar.width + TNSpacingStar) * starIndex),
                                         (self.frame.size.height - TNSizeStar.height) / 2,
                                         TNSizeStar.width,
                                         TNSizeStar.height
                                         );
        UIImage *imageStar = nil;
        if (starIndex < user.rating.integerValue)
        {
            imageStar = [UIImage imageNamed:@"StarSelected"];
        }
        else
        {
            imageStar = [UIImage imageNamed:@"StarUnselected"];
        }
        imageViewStar.image = imageStar;
        [self addSubview:imageViewStar];
    }
    
    _rate.text = [user.rating stringValue];
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
    
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Выберите оппонента";
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    //IconShuffle.png
    UIButton *buttonShuffle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [buttonShuffle setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonShuffle setImage:[UIImage imageNamed:@"IconShuffle"] forState:UIControlStateNormal];
    [buttonShuffle addTarget:self action:@selector(shuffleButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shuffleItem = [[UIBarButtonItem alloc] initWithCustomView:buttonShuffle];
    self.navigationItem.leftBarButtonItem = shuffleItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(closeButtonTouched)];
    
    //
    
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
    [buttonPari setTitle:@"Пари" forState:UIControlStateNormal];
    buttonPari.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0f];
    buttonPari.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    buttonPari.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonPari setBackgroundImage:[[UIImage imageNamed:@"ButtonDark"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f)]
                              forState:UIControlStateNormal];
    [buttonPari addTarget:self action:@selector(pariButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonPari];
    
    
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
//         self.subscribers = [NSArray arrayWithObjects:subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], subscribers[0], nil];
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
    
}

@end
