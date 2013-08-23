//
//  UIViewController+Puntr.m
//  Puntr
//
//  Created by Alexander Lebedev on 7/29/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "UIViewController+Puntr.h"
#import "ObjectManager.h"
#import "NotificationManager.h"
#import "MoneyModel.h"

@implementation UIViewController (Puntr)

- (void)addBalanceButton
{
    UIButton *buttonBalance = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [buttonBalance setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    //[self.buttonSubscribe setTitle:@"Подписаться" forState:UIControlStateNormal];
    [buttonBalance.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    buttonBalance.titleLabel.shadowColor = [UIColor blackColor];
    buttonBalance.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonBalance.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonBalance.titleLabel setTextAlignment:NSTextAlignmentRight];
    //[buttonBalance.titleLabel setBackgroundColor:[UIColor redColor]];
    [buttonBalance setImage:[UIImage imageNamed:@"IconMoney"] forState:UIControlStateNormal];
    //CGRectGetWidth(buttonBalance.frame)
    [buttonBalance setImageEdgeInsets:UIEdgeInsetsMake(0.0, CGRectGetWidth(buttonBalance.frame) - 21.0, 0.0, 0.0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBalance];
}

- (void)updateBalance
{
    [[ObjectManager sharedManager] balanceWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
        {
            MoneyModel *money = (MoneyModel *)mappingResult.firstObject;
            [(UIButton *)self.navigationItem.rightBarButtonItem.customView setTitle:money.amount.stringValue
                                                                           forState:UIControlStateNormal];
            //CGRectGetWidth([(UIButton *)self.navigationItem.rightBarButtonItem.customView titleLabel].frame);
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
