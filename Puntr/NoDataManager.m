//
//  NoDataManager.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NoDataManager.h"
#import "ObjectManager.h"

static NSString * const TNCopyrightNews = @"Чтобы у вас появились новости, подпишитесь на событие, команду, турнир или сделайте ставку в каталоге";
static NSString * const TNCopyrightStakes = @"Вы можете сделать ставку выбрав событие из каталога";
static NSString * const TNCopyrightBets = @"Вы можете создать пари выбрав событие из каталога";
static NSString * const TNCopyrightProfile = @"Здесь будет отображаться ваша активность: ставки, статусы ставок, подписки";
static NSString * const TNCopyrightOtherUser = @"Здесь будет отображаться активность пользователя: ставки, статусы ставок, подписки";

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
            self.labelSorryText.text = TNCopyrightProfile;
        }
        else if (self.collectionType == CollectionTypeActivities)
        {
            self.labelSorryText.text = TNCopyrightOtherUser;
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
                    self.labelSorryText.text = TNCopyrightNews;
                    break;
                    
                case CollectionTypeBets:
                    self.labelSorryText.text = TNCopyrightBets;
                    break;
                    
                case CollectionTypeMyStakes:
                    self.labelSorryText.text = TNCopyrightStakes;
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
