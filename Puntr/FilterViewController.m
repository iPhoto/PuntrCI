//
//  FilterViewController.m
//  Puntr
//
//  Created by Artem on 8/24/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CategoryModel.h"
#import "DefaultsManager.h"
#import "FilterViewController.h"
#import "ObjectManager.h"

#define TNFont [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]

static const CGFloat TNHeaderFooterSidePadding = 14.0f;
static const CGFloat TNHeaderFooterTopPadding = 8.0f;

#pragma mark - TableViewCell

@interface TNTableViewCell : UITableViewCell

@property (nonatomic, weak) id someObject;
@property (nonatomic) BOOL isChecked;

- (void)loadWithCategory:(CategoryModel *)category;

@end

@implementation TNTableViewCell
{
    UIImageView *_checkedImageView;
    UIImageView *_uncheckedImageView;
}

- (id)init
{
    if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil])
    {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _checkedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
        _uncheckedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(20.0f, CGRectGetMidY(self.imageView.frame));
    self.textLabel.frame = CGRectSetX(self.textLabel.frame, 40.0f);
}

- (void)prepareForReuse
{
    [self.imageView cancelImageRequestOperation];
    self.imageView.image = nil;
}

- (void)loadWithCategory:(CategoryModel *)category
{
    self.someObject = category;
    
    if (category.image)
    {
        CGFloat TNSideCategoryImage = 20.0f;
        
        __weak TNTableViewCell *weakSelf = self;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[category.image URLByAppendingSize:CGSizeMake(TNSideCategoryImage, TNSideCategoryImage)]];
        
        UIImageView *tmpImageView = [UIImageView new];
        [tmpImageView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                     {
                                        if (weakSelf && weakSelf.someObject)
                                        {
                                            if (weakSelf.someObject == category)
                                            {
                                                weakSelf.imageView.image = image;
                                                [weakSelf setNeedsLayout];
                                            }
                                        }
                                     }
                                     failure:nil];
    }
    
    if (category.title)
    {
        self.textLabel.text = category.title;
    }
}

@end

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *isChecked;
@property (nonatomic, strong) NSMutableArray *uncheckedCategoryTags;

@property (nonatomic, weak) UITableView *filtersTableView;
@property (nonatomic, weak) UIButton *buttonCheck;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    self.title = NSLocalizedString(@"Filter", nil);
    
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTouched)];
    self.navigationItem.leftBarButtonItem = buttonCancel;

    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.bounds);
    
    CGRect tableFrame = self.view.bounds;
    tableFrame = CGRectSetHeight(tableFrame, viewHeight - (tabBarHeight + navigationBarHeight));
    
    UITableView *filtersTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.filtersTableView = filtersTableView;
    self.filtersTableView.dataSource = self;
    self.filtersTableView.delegate = self;
    self.filtersTableView.backgroundView = nil;
    self.filtersTableView.backgroundColor = [UIColor clearColor];
    self.filtersTableView.separatorColor = [UIColor colorWithWhite:175.0 / 255.0 alpha:1.0];
    self.filtersTableView.scrollEnabled = YES;
    [self.view addSubview:self.filtersTableView];
    
    self.uncheckedCategoryTags = [NSMutableArray arrayWithArray:[DefaultsManager sharedManager].excludedCategoryTags];
    
    [self addCheckButton];
    
    [self requestData];
}

- (void)cancelButtonTouched
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utility

- (void)addCheckButton
{
    UIButton *buttonCheck = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 84, 31)];
    self.buttonCheck = buttonCheck;
    [self.buttonCheck setBackgroundImage:[[UIImage imageNamed:@"button_green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f)] forState:UIControlStateNormal];
    [self.buttonCheck.titleLabel setFont:TNFont];
    self.buttonCheck.titleLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    self.buttonCheck.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [self.buttonCheck setTitle:[self checkUncheckButtonTitle] forState:UIControlStateNormal];
    [self.buttonCheck addTarget:self action:@selector(checkUnckeckButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonCheck];
}

- (void)checkUnckeckButtonPressed
{
    BOOL newState = !([self isAllSportsChecked]);
    for (NSInteger i = 0; i < self.isChecked.count; i++)
    {
        [self setCategoryWithIndex:i inStateChecked:newState];
    }
    [self.buttonCheck setTitle:[self checkUncheckButtonTitle] forState:UIControlStateNormal];
    [self.filtersTableView reloadRowsAtIndexPaths:[self.filtersTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    [self saveUncheckedStates];
}

- (BOOL)isAllSportsChecked
{
    BOOL retVal = YES;
    for (NSNumber *isChecked in self.isChecked)
    {
        if (![isChecked boolValue])
        {
            retVal = NO;
            break;
        }
    }
    return retVal;
}

- (NSString *)checkUncheckButtonTitle
{
    NSString *retVal = ([self isAllSportsChecked]) ? NSLocalizedString(@"Uncheck all", nil) : NSLocalizedString(@"Check all", nil);
    return retVal;
}

- (void)setCategoryWithIndex:(NSInteger)index inStateChecked:(BOOL)isChecked
{
    CategoryModel *category = self.categories[index];
    self.isChecked[index] = @(isChecked);
    if (isChecked)
    {
        [self.uncheckedCategoryTags removeObject:category.tag];
    }
    else
    {
        if (![self.uncheckedCategoryTags containsObject:category.tag])
        {
            [self.uncheckedCategoryTags addObject:category.tag];
        }
    }
}

- (void)requestData
{
    __weak FilterViewController *weakSelf = self;
    [[ObjectManager sharedManager] categoriesWithSuccess:^(NSArray *categories)
        {
            NSMutableArray *consolidatedCategories = [NSMutableArray arrayWithCapacity:categories.count + 1];
            [consolidatedCategories addObjectsFromArray:categories];
            weakSelf.categories = [consolidatedCategories copy];
            weakSelf.isChecked = [NSMutableArray new];
            for (CategoryModel *category in weakSelf.categories)
            {
                [weakSelf.isChecked addObject:@(([weakSelf isCheckedCategory:category]))];
            }
            [weakSelf.buttonCheck setTitle:[weakSelf checkUncheckButtonTitle] forState:UIControlStateNormal];
            [weakSelf.filtersTableView reloadData];
        }
        failure:nil
    ];
}

- (BOOL)isCheckedCategory:(CategoryModel *)category
{
    BOOL isCheckedCategory = YES;
    if ([self.uncheckedCategoryTags containsObject:category.tag])
    {
        isCheckedCategory = NO;
    }
    return isCheckedCategory;
}

- (void)saveUncheckedStates
{
    [DefaultsManager sharedManager].excludedCategoryTags = [self.uncheckedCategoryTags copy];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdFileName = @"middle_area.png";
    if (indexPath.row == 0)
    {
        reuseIdFileName = @"top_area.png";
    }
    if (indexPath.row == self.categories.count - 1)
    {
        reuseIdFileName = @"bottom_area.png";
    }
    
    TNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdFileName];
    if (cell == nil)
    {
        cell = [[TNTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdFileName];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reuseIdFileName]];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = TNFont;
        cell.textLabel.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
    }
    
    CategoryModel *category = self.categories[indexPath.row];
    [cell loadWithCategory:category];
    cell.isChecked = [self isCheckedCategory:category];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = UITableViewAutomaticDimension;
    
    CGFloat settingsWidth = CGRectGetWidth(self.filtersTableView.frame);
    
    CGSize headerSize = [NSLocalizedString(@"Choose sport types", nil) sizeWithFont:TNFont
                           constrainedToSize:CGSizeMake(settingsWidth - (TNHeaderFooterSidePadding * 2.0f), MAXFLOAT)
                               lineBreakMode:NSLineBreakByClipping];
    headerHeight = TNHeaderFooterTopPadding + headerSize.height + 5.0f;
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    CGFloat settingsWidth = CGRectGetWidth(self.filtersTableView.frame);
    
    CGFloat headerHeight = [self tableView:self.filtersTableView heightForHeaderInSection:0];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(
                                                             0.0f,
                                                             0.0f,
                                                             settingsWidth,
                                                             TNHeaderFooterTopPadding + headerHeight + 5.0f
                                                         )];
    
    UILabel *headerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                            TNHeaderFooterSidePadding,
                                                                            TNHeaderFooterTopPadding,
                                                                            settingsWidth - (TNHeaderFooterSidePadding * 2.0f),
                                                                            headerHeight - (TNHeaderFooterTopPadding * 2.0f)
                                                                        )];
    headerViewLabel.text = NSLocalizedString(@"Choose sport types", nil);
    headerViewLabel.font = TNFont;
    headerViewLabel.backgroundColor = [UIColor clearColor];
    headerViewLabel.textColor = [UIColor whiteColor];
    headerViewLabel.lineBreakMode = NSLineBreakByClipping;
    headerViewLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerViewLabel];
    
    return headerView;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TNTableViewCell *cell = (TNTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = !cell.isChecked;
    [self setCategoryWithIndex:indexPath.row inStateChecked:cell.isChecked];
    [self.buttonCheck setTitle:[self checkUncheckButtonTitle] forState:UIControlStateNormal];
    [self saveUncheckedStates];
}


@end
