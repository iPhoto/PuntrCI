//
//  NotificationManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

#pragma mark - Error

+ (void)showError:(NSError *)error;
+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController;

#pragma mark - Notification

+ (void)showNotificationMessage:(NSString *)message;

#pragma mark - Success

+ (void)showSuccessMessage:(NSString *)message;

@end