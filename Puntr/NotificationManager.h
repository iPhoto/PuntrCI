//
//  NotificationManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

+ (void)showErrorMessage:(NSString *)message;
+ (void)showError:(NSError *)error;
+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController;

@end
