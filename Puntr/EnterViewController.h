//
//  EnterViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 13.06.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialManager.h"

@interface EnterViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, SocialManagerDelegate>

+ (EnterViewController *)enter;

@end
