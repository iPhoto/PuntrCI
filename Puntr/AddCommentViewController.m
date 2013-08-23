//
//  AddCommentViewController.m
//  Puntr
//
//  Created by Alexander Lebedev on 8/21/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AddCommentViewController.h"
#import "CommentModel.h"
#import "ObjectManager.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat TNItemSpacing = 12.0f;

@interface AddCommentViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) EventModel *event;

@end

@implementation AddCommentViewController

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
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTouched)];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    
    UIBarButtonItem *buttonSend = [[UIBarButtonItem alloc] initWithTitle:@"Отправить" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonTouched)];
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
