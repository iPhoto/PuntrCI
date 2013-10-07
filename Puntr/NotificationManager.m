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

static const NSTimeInterval TNDurationShort = 1.5f;
static const NSTimeInterval TNDurationMedium = 3.0f;
static const NSTimeInterval TNDurationLong = 5.0f;

@implementation NotificationManager

#pragma mark - Error

+ (void)showError:(NSError *)error
{
    [self showError:error forViewController:[PuntrUtilities topController]];
}

+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController
{
    NSString *errorTitle = NSLocalizedString(@"Error", nil);
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
                                          title:errorTitle
                                       subtitle:errorMessage
                                           type:TSMessageNotificationTypeError
                                       duration:TNDurationLong
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

#pragma mark - Notification

+ (void)showNotificationMessage:(NSString *)message
{
    if (message)
    {
        [self showNotificationMessage:message forViewController:[PuntrUtilities topController]];
    }
}

+ (void)showNotificationMessage:(NSString *)message forViewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController
                                          title:NSLocalizedString(@"Attention", nil)
                                       subtitle:message
                                           type:TSMessageNotificationTypeMessage
                                       duration:TNDurationMedium
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

#pragma mark - Success

+ (void)showSuccessMessage:(NSString *)message
{
    [self showSuccessMessage:message forViewController:[PuntrUtilities topController]];
}

+ (void)showSuccessMessage:(NSString *)message forViewController:(UIViewController *)viewController
{
    [TSMessage showNotificationInViewController:viewController
                                          title:NSLocalizedString(@"Congratulations!", nil)
                                       subtitle:message
                                           type:TSMessageNotificationTypeSuccess
                                       duration:TNDurationShort
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

@end
