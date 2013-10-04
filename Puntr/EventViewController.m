//
//  EventViewController.m
//  Puntr
//
//  Created by Eugene Tulushev on 10.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CommentViewController.h"
#import "CollectionManager.h"
#import "EventModel.h"
#import "EventViewController.h"
#import "UIViewController+Puntr.h"

@interface EventViewController ()

@property (nonatomic, strong, readonly) EventModel *event;

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation EventViewController

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
    self.title = NSLocalizedString(@"Event", nil);
    
    UIBarButtonItem *buttonComment = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Comment", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(rightNavButtonTouched)];
    self.navigationItem.rightBarButtonItem = buttonComment;
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeEventComments modifierObjects:@[self.event]];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = self.frame;
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionManager reloadData];
}

- (void)rightNavButtonTouched
{
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[CommentViewController commentWithEvent:self.event]]
                                            animated:YES
                                          completion:nil];
}

@end
