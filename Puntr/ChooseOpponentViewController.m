//
//  ChooseOpponentViewController.m
//  Puntr
//
//  Created by Artem on 9/6/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ChooseOpponentViewController.h"
#import "ObjectManager.h"


@interface ChooseOpponentViewController ()

@property (nonatomic, strong) PagingModel *paging;

@end



@implementation ChooseOpponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds)
                                            );
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
}

- (void)closeButtonTouched
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shuffleButtonTouched
{
    
}

- (void)loadSubscriptions
{
    /*
    UserModel *user = (UserModel *)self.modifierObject;
    [[ObjectManager sharedManager] subscriptionsForUser:user
                                                 paging:self.paging
                                                success:^(NSArray *subscriptions)
     {
         [self combineWithData:subscriptions];
     }
                                                failure:^
     {
         [self finishLoading];
     }
     ];*/
}


@end
