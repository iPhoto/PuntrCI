//
//  NoDataManager.m
//  Puntr
//
//  Created by Alexander Lebedev on 9/19/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NoDataManager.h"
#import "CollectionManagerTypes.h"

static NSString *const kCopyrightNews = @"Чтобы у вас появились новости, подпишитесь на событие, команду, турнир или сделайте ставку в каталоге";
static NSString *const kCopyrightStakes = @"Вы можете сделать ставку выбрав событие из каталога";
static NSString *const kCopyrightBets = @"Вы можете создать пари выбрав событие из каталога";
static NSString *const kCopyrightProfile = @"Здесь будет отображаться ваша активность: ставки, статусы ставок, подписки";
static NSString *const kCopyrightOtherUser = @"Здесь будет отображаться активность пользователя: ставки, статусы ставок, подписки";

@interface NoDataManager ()

@property ()NoDataType noDataType;

@property (nonatomic, strong) UILabel *labelSorryText;
@property (nonatomic, strong) UIImageView *imageViewSorryArrow;

@end

@implementation NoDataManager

- (id)initWithNoDataOfType:(NoDataType)noDataType
{
    self = [super init];
    if (self) {
        _noDataType = noDataType;
    }
    return self;
}

- (void)haveItems:(BOOL)haveItems withCollectionType:(CollectionType)collectionType
{
    if(collectionType == CollectionTypeBets)
    {
        self.noDataType = NoDataTypeBets;
    }
    else if(collectionType == CollectionTypeMyStakes)
    {
        self.noDataType = NoDataTypeStakes;
    }
    if(haveItems)
    {
        [self.labelSorryText removeFromSuperview];
        [self.imageViewSorryArrow removeFromSuperview];
        self.labelSorryText = nil;
        self.imageViewSorryArrow = nil;
    }
    else
    {
        self.labelSorryText = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame) - 175)];
        [self.labelSorryText setTextAlignment:NSTextAlignmentCenter];
        [self.labelSorryText setNumberOfLines:0];
        [self.labelSorryText setLineBreakMode:NSLineBreakByWordWrapping];
        [self.labelSorryText setTextColor:[UIColor whiteColor]];
        [self.labelSorryText setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.labelSorryText];
        
        if(self.noDataType == NoDataTypeProfile)
        {
            self.labelSorryText.text = kCopyrightProfile;
        }
        else if(self.noDataType == NoDataTypeOtherUser)
        {
            self.labelSorryText.text = kCopyrightOtherUser;
        }
        else
        {
            [self.labelSorryText setFrame:CGRectMake(20, 40, CGRectGetWidth(self.view.frame) - 40, CGRectGetHeight(self.view.frame) - 80)];
            
            self.imageViewSorryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowDown"]];
            [self.imageViewSorryArrow setFrame:CGRectMake(100, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.imageViewSorryArrow.frame), CGRectGetWidth(self.imageViewSorryArrow.frame), CGRectGetHeight(self.imageViewSorryArrow.frame))];
            [self.view addSubview:self.imageViewSorryArrow];
            switch (self.noDataType)
            {
                case NoDataTypeNews:
                    self.labelSorryText.text = kCopyrightNews;
                    break;
                    
                case NoDataTypeBets:
                    self.labelSorryText.text = kCopyrightBets;
                    break;
                    
                case NoDataTypeStakes:
                    self.labelSorryText.text = kCopyrightStakes;
                    break;
                    
                default:
                    break;
            }
        }
    }
}
@end
