//
//  CommentViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/21/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "EventModel.h"
#import "ObjectManager.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat TNItemSpacing = 12.0f;

@interface CommentViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) EventModel *event;

@end

@implementation CommentViewController

+ (CommentViewController *)commentWithEvent:(EventModel *)event
{
    return [[self alloc] initWithEvent:event];
}

- (id)initWithEvent:(EventModel *)event
{
    self = [super init];
    if (self)
    {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.navigationController.navigationBarHidden = NO;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect viewControllerFrame = CGRectMake(0.0f,
                                            0.0f,
                                            CGRectGetWidth(applicationFrame),
                                            CGRectGetHeight(applicationFrame) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - CGRectGetHeight(self.tabBarController.tabBar.bounds)
                                            );
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTouched)];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    
    UIBarButtonItem *buttonSend = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonTouched)];
    [buttonSend setBackgroundImage:[[UIImage imageNamed:@"ButtonGreenSmall"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = buttonSend;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(TNItemSpacing, TNItemSpacing, CGRectGetWidth(viewControllerFrame)  - (2 * TNItemSpacing), CGRectGetHeight(viewControllerFrame) - (216 + (2 * TNItemSpacing)))];
    [self.textView setFont:[UIFont fontWithName:@"ArialMT" size:15.0f]];
    self.textView.layer.cornerRadius = 3.75f;
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonTouched
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendButtonTouched
{
    if(![self.textView.text isEqualToString:@""])
    {
        CommentModel *commentModel= [[CommentModel alloc] init];
        commentModel.message = self.textView.text;
        [[ObjectManager sharedManager] postComment:commentModel
                                          forEvent:self.event
                                           success:^(void)
                                            {
                                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                            }
                                           failure:nil
        ];

    }
}

@end
