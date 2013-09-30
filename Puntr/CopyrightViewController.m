//
//  CopyrightViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/10/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CopyrightViewController.h"
#import "CopyrightModel.h"
#import "NotificationManager.h"
#import "ObjectManager.h"

static const CGFloat TNItemSpacing = 12.0f;

@interface CopyrightViewController ()

@property ()CopyrightSelection copyrightSelection;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation CopyrightViewController

- (id)initWithCopyrightSelection:(CopyrightSelection) copyrightSelection
{
    self = [super init];
    if (self) {
        _copyrightSelection = copyrightSelection;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    switch (self.copyrightSelection)
    {
        case CopyrightSelectionOffer:
        {
            self.title = NSLocalizedString(@"Offer", nil);
        }
            break;
        case CopyrightSelectionTerms:
        {
            self.title = NSLocalizedString(@"Terms", nil);
        }
            break;
            
        default:
            break;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.navigationController.navigationBarHidden = NO;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(TNItemSpacing, TNItemSpacing, CGRectGetWidth(viewControllerFrame)  - (2 * TNItemSpacing), CGRectGetHeight(viewControllerFrame) - (2 * TNItemSpacing))];
    [self.textView setFont:[UIFont fontWithName:@"ArialMT" size:15.0f]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setEditable:NO];
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCopyright];
}

- (void)loadCopyright
{
    switch (self.copyrightSelection)
    {
        case CopyrightSelectionOffer:
        {
            [[ObjectManager sharedManager] offerWithSuccess:^(CopyrightModel *copyright) {
                [self.textView setText:copyright.offer];
            } failure:nil];
        }
            break;
        case CopyrightSelectionTerms:
        {
            [[ObjectManager sharedManager] termWithSuccess:^(CopyrightModel *copyright) {
                [self.textView setText:copyright.terms];
            } failure:nil];
        }
            break;
            
        default:
            break;
    }
}
@end
