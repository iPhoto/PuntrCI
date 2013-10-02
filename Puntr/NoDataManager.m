//
//  NoDataManager.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NoDataManager.h"
#import "ObjectManager.h"

@interface NoDataManager ()

@property (nonatomic) CollectionType collectionType;

@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;

@end

@implementation NoDataManager

+ (NoDataManager *)managerWithType:(CollectionType)collectionType
{
    return [[self alloc] initWithType:collectionType];
}

- (id)initWithType:(CollectionType)collectionType
{
    self = [super init];
    if (self)
    {
        _collectionType = collectionType;
    }
    return self;
}

- (void)haveItems:(BOOL)haveItems withCollectionType:(CollectionType)collectionType
{
    self.collectionType = collectionType;
    
    if (haveItems)
    {
        [self clear];
    }
    else
    {
        [self clear];
        
        self.labelSorryText = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame) - 175)];
        [self.labelSorryText setTextAlignment:NSTextAlignmentCenter];
        [self.labelSorryText setNumberOfLines:0];
        [self.labelSorryText setLineBreakMode:NSLineBreakByWordWrapping];
        [self.labelSorryText setTextColor:[UIColor whiteColor]];
        [self.labelSorryText setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.labelSorryText];
        
        if (self.collectionType == CollectionTypeActivitiesSelf)
        {
            self.labelSorryText.text = NSLocalizedString(@"Here will appear your activity: rates, status rates, subscriptions", nil);
        }
        else if (self.collectionType == CollectionTypeActivities)
        {
            self.labelSorryText.text = NSLocalizedString(@"Here will appear user's activity: rates, status rates, subscriptions", nil);
        }
        else
        {
            [self.labelSorryText setFrame:CGRectMake(20, 40, CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame) - 80)];
            
            self.imageViewSorryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowDown"]];
            [self.imageViewSorryArrow setFrame:CGRectMake(100, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.imageViewSorryArrow.frame), CGRectGetWidth(self.imageViewSorryArrow.frame), CGRectGetHeight(self.imageViewSorryArrow.frame))];
            [self.view addSubview:self.imageViewSorryArrow];
            
            switch (self.collectionType)
            {
                case CollectionTypeNews:
                    self.labelSorryText.text = NSLocalizedString(@"To have any news, you should to subscribe on event, team, tournament, or place a bet in catalogue", nil);
                    break;
                    
                case CollectionTypeBets:
                    self.labelSorryText.text = NSLocalizedString(@"You can create a bet by selecting the event from the catalogue", nil);
                    break;
                    
                case CollectionTypeMyStakes:
                    self.labelSorryText.text = NSLocalizedString(@"You can do a stake by selecting the event from the catalogue", nil);
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)clear
{
    [self.labelSorryText removeFromSuperview];
    [self.imageViewSorryArrow removeFromSuperview];
    self.labelSorryText = nil;
    self.imageViewSorryArrow = nil;
}

@end
