//
//  TournamentViewController.m
//  Puntr
//
//  Created by Momus on 10.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TournamentViewController.h"
#import "TournamentModel.h"

@interface TournamentViewController ()

@property (nonatomic, retain) TournamentModel *tournament;

@property (nonatomic, retain) UIImageView *tournamentImage;
@property (nonatomic, retain) UIButton *subscribeButton;



@end

@implementation TournamentViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
