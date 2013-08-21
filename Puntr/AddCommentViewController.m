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

- (id)initWithEventTag:(EventModel *)event
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
    
    UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    [buttonCancel setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonCancel setTitle:@"Отмена" forState:UIControlStateNormal];
    [buttonCancel.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    buttonCancel.titleLabel.shadowColor = [UIColor blackColor];
    buttonCancel.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonCancel.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonCancel addTarget:self action:@selector(cancelButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonCancel];
    
    UIButton *buttonSend = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 30)];
    [buttonSend setBackgroundImage:[[UIImage imageNamed:@"ButtonBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 7.0f)] forState:UIControlStateNormal];
    [buttonSend setTitle:@"Отправить" forState:UIControlStateNormal];
    [buttonSend.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]];
    buttonSend.titleLabel.shadowColor = [UIColor blackColor];
    buttonSend.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.5f);
    [buttonSend.titleLabel setTextColor:[UIColor whiteColor]];
    [buttonSend addTarget:self action:@selector(sendButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonSend];
    
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
