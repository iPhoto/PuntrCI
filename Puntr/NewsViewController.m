//
//  NewsViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "NewsViewController.h"
#import "UIViewController+Puntr.h"

static const CGFloat TNItemSpacing = 12.0f;

@interface NewsViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;
@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Новости";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );

    self.collectionManager = [CollectionManager managerWithType:CollectionTypeNews modifierObject:nil];
    self.collectionManager.collectionManagerDelegate = self;
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = viewControllerFrame;
    [self.view addSubview:collectionView];
    
    self.labelSorryText = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(viewControllerFrame) - 40, CGRectGetHeight(viewControllerFrame) - 80)];
    [self.labelSorryText setTextAlignment:NSTextAlignmentCenter];
    [self.labelSorryText setText:@"Чтобы у вас появились нововсти, подпишитесь на событие, команду, турнир или сделайте ставку в каталоге"];
    [self.labelSorryText setNumberOfLines:0];
    [self.labelSorryText setLineBreakMode:NSLineBreakByWordWrapping];
    [self.labelSorryText setTextColor:[UIColor whiteColor]];
    [self.labelSorryText setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.labelSorryText];
    
    self.imageViewSorryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowDown"]];
    [self.imageViewSorryArrow setFrame:CGRectMake(100, CGRectGetHeight(viewControllerFrame) - CGRectGetHeight(self.imageViewSorryArrow.frame), CGRectGetWidth(self.imageViewSorryArrow.frame), CGRectGetHeight(self.imageViewSorryArrow.frame))];
    [self.view addSubview:self.imageViewSorryArrow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

- (void)collectionUpdatedWhithNumberofCells:(int) count
{
    if(count == 0)
    {
        self.labelSorryText.hidden = NO;
        self.imageViewSorryArrow.hidden = NO;
    }
    else
    {
        self.labelSorryText.hidden = YES;
        self.imageViewSorryArrow.hidden = YES;
    }
}

@end
