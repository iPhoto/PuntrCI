//
//  NotificationManager.m
//  Puntr
//
//  Created by Eugene Tulushev on 04.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "NotificationManager.h"
#import <TSMessages/TSMessage.h>
#import "ErrorModel.h"

@implementation NotificationManager

#pragma mark - Error

+ (void)showError:(NSError *)error
{
    [self showError:error forViewController:[self topController]];
}

+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController
{
    NSString *errorTitle = @"Ошибка";
    NSString *errorMessage = @"";
    if ([error.userInfo objectForKey:@"RKObjectMapperErrorObjectsKey"])
    {
        ErrorModel *errorResponse = (ErrorModel *)[error.userInfo[@"RKObjectMapperErrorObjectsKey"] firstObject];
        if (errorResponse.parameters && errorResponse.parameters.count > 0)
        {
            errorTitle = errorResponse.message;
            for (ParameterModel *errorParameter in errorResponse.parameters)
            {
                errorMessage = [errorMessage stringByAppendingFormat:@"\n%@ : %@", errorParameter.key, errorParameter.description];
            }
        }
        else
        {
            errorMessage = errorResponse.message;
        }
    }
    else
    {
        errorMessage = [error localizedDescription];
    }
    [TSMessage showNotificationInViewController:viewController
                                      withTitle:errorTitle
                                    withMessage:errorMessage
                                       withType:TSMessageNotificationTypeError];
}

#pragma mark - Notification

+ (void)showNotificationMessage:(NSString *)message
{
    if (message)
    {
        [self showNotificationMessage:message forViewController:[self topController]];
    }
}

+ (void)showNotificationMessage:(NSString *)message forViewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController
                                      withTitle:@"Внимание"
                                    withMessage:message
                                       withType:TSMessageNotificationTypeWarning];
}

#pragma mark - Success

+ (void)showSuccessMessage:(NSString *)message
{
    [self showSuccessMessage:message forViewController:[self topController]];
}

+ (void)showSuccessMessage:(NSString *)message forViewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController
                                      withTitle:@"Поздравляем!"
                                    withMessage:message
                                       withType:TSMessageNotificationTypeSuccess];
}

#pragma mark - Top Controller

+ (UIViewController *)topController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    return topController;
}

@end
