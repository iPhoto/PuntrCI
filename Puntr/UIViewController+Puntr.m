//
//  UIViewController+Puntr.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/29/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "FilterViewController.h"
#import "MoneyModel.h"
#import "NotificationManager.h"
#import "ObjectManager.h"
#import "UIViewController+Puntr.h"

@implementation UIViewController (Puntr)

- (void)addBalanceButton
{
    UIButton *buttonBalance = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [buttonBalance setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonBalance.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    buttonBalance.titleLabel.shadowColor = [UIColor blackColor];
    buttonBalance.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonBalance.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonBalance.titleLabel setTextAlignment:NSTextAlignmentRight];
    [buttonBalance setImage:[UIImage imageNamed:@"IconMoney"] forState:UIControlStateNormal];
    [buttonBalance setImageEdgeInsets:UIEdgeInsetsMake(0.0, CGRectGetWidth(buttonBalance.frame) - 21.0, 0.0, 0.0)];
    [buttonBalance setUserInteractionEnabled:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBalance];
}

- (void)addFilterButton
{
    UIButton *buttonFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonFilter setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonFilter setImage:[UIImage imageNamed:@"IconFilter"] forState:UIControlStateNormal];
    [buttonFilter setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    [buttonFilter addTarget:self action:@selector(touchedButtonFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:buttonFilter];
    self.navigationItem.leftBarButtonItem = settingsItem;
}

- (void)addSettingsButton
{
    UIButton *buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonSettings setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonSettings setImage:[UIImage imageNamed:@"IconSettings"] forState:UIControlStateNormal];
    [buttonSettings setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    [buttonSettings addTarget:self action:@selector(settingsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:buttonSettings];
    
    self.navigationItem.leftBarButtonItem = settingsItem;
}


- (void)touchedButtonFilter
{
    FilterViewController *filterViewController = [FilterViewController new];
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:filterViewController] animated:YES completion:nil];
}

- (void)updateBalance
{
    [[ObjectManager sharedManager] balanceWithSuccess:^(MoneyModel *money)
        {
            int ballance = money.amount.intValue;
            NSString *stringBallance;
            if(ballance > 999999)
            {
                ballance = ballance/1000000;
                stringBallance = [NSString stringWithFormat:@"%im", ballance];
            }
            else if(ballance > 9999)
            {
                ballance = ballance/1000;
                stringBallance = [NSString stringWithFormat:@"%ik", ballance];
            }
            else
            {
                stringBallance = [NSString stringWithFormat:@"%i", ballance];
            }
            [(UIButton *)self.navigationItem.rightBarButtonItem.customView setTitle:stringBallance
                                                                           forState:UIControlStateNormal];
            CGSize maxLabelSize = [@"0000" sizeWithFont:[(UIButton *)self.navigationItem.rightBarButtonItem.customView titleLabel].font];
            [(UIButton *)self.navigationItem.rightBarButtonItem.customView setTitleEdgeInsets:UIEdgeInsetsMake(0.0, MAX(-8.0f, -8.0f + maxLabelSize.width - CGRectGetWidth([(UIButton *)self.navigationItem.rightBarButtonItem.customView titleLabel].frame)), 0.0, 23.0)];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
        {
            [NotificationManager showError:error];
        }
    ];
}

- (CGRect)frame
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    return  CGRectMake(
                          0.0f,
                          0.0f,
                          CGRectGetWidth(applicationFrame),
                          CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                      );
    
}

@end
