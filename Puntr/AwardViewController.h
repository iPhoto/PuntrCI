//
//  AwardViewController.h
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardModel.h"

@interface AwardViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>

- (id)initWithAward:(AwardModel *)award fromPushNotification:(BOOL)fromPush;

@end
