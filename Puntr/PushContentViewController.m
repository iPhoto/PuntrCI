//
//  PushContentViewController.m
//  Puntr
//
//  Created by Momus on 10.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PushContentViewController.h"

#import "CollectionManager.h"

#import "UIViewController+Puntr.h"


@interface PushContentViewController ()

@property (nonatomic, strong) CollectionManager *collectionManager;

@end

@implementation PushContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   	CGRect frame = self.frame;
    
    self.title = NSLocalizedString(@"Awards", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.302 alpha:1.000];
    
    self.collectionManager = [CollectionManager managerWithType:CollectionTypeAwards modifierObjects:nil];
    UICollectionView *collectionView = self.collectionManager.collectionView;
    collectionView.frame = frame;
    self.collectionManager.collectionManagerDelegate = self;
    [self.view addSubview:collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
