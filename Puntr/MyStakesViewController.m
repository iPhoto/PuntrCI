//
//  MyStakesViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CollectionManager.h"
#import "MyStakesViewController.h"
#import "UIViewController+Puntr.h"

@interface MyStakesViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;
@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;

@end

@implementation MyStakesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Мои ставки";
    [self addBalanceButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeMyStakes modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
    [self.view addSubview:collectionView];
    
    self.labelSorryText = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CGRectGetWidth(self.frame) - 40, CGRectGetHeight(self.frame) - 60)];
    [self.labelSorryText setTextAlignment:NSTextAlignmentCenter];
    [self.labelSorryText setText:@"Чтобы у вас появились нововсти, подпишитесь на событие, команду, турнир или сделайте ставку в каталоге"];
    [self.labelSorryText setNumberOfLines:0];
    [self.labelSorryText setLineBreakMode:NSLineBreakByWordWrapping];
    [self.labelSorryText setTextColor:[UIColor whiteColor]];
    [self.labelSorryText setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.labelSorryText];
    
    self.imageViewSorryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowDown"]];
    [self.imageViewSorryArrow setFrame:CGRectMake(100, CGRectGetHeight(self.frame) - CGRectGetHeight(self.imageViewSorryArrow.frame), CGRectGetWidth(self.imageViewSorryArrow.frame), CGRectGetHeight(self.imageViewSorryArrow.frame))];
    [self.view addSubview:self.imageViewSorryArrow];
    self.labelSorryText.hidden = YES;
    self.imageViewSorryArrow.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBalance];
    [self.collectionManager reloadData];
}

- (void)haveItems:(BOOL)haveItems
{
    if(haveItems)
    {
        self.labelSorryText.hidden = YES;
        self.imageViewSorryArrow.hidden = YES;
    }
    else
    {
        self.labelSorryText.hidden = NO;
        self.imageViewSorryArrow.hidden = NO;
    }
}

@end
