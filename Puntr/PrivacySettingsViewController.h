//
//  PrivacySettingsViewController.h
//  Puntr
//
//  Created by Alexander Lebedev on 8/21/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DynamicSelction)
{
    DynamicSelctionPrivacy,
    DynamicSelctionPush,
    DynamicSelctionSocials
};

@interface PrivacySettingsViewController : UIViewController

- (id)initWithDynamicSelection:(DynamicSelction) dynamicSelection;

@end
