//
//  TNIMessagePresenter.m
//  Puntr
//
//  Created by Eugene Tulushev on 04.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "TNIMessagePresenter.h"
#import <TSMessages/TSMessage.h>
#import "TNIError.h"
#import "TNIErrorParameter.h"

@implementation TNIMessagePresenter

+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController {
    NSString *errorTitle = @"Ошибка";
    NSString *errorMessage = @"";
    if ([error.userInfo objectForKey:@"RKObjectMapperErrorObjectsKey"]) {
        TNIError *errorResponse = (TNIError *)[error.userInfo[@"RKObjectMapperErrorObjectsKey"] firstObject];
        if (errorResponse.errors && errorResponse.errors.count > 0) {
            errorTitle = errorResponse.message;
            for (TNIErrorParameter *errorParameter in errorResponse.errors) {
                errorMessage = [errorMessage stringByAppendingFormat:@"\n%@ : %@", errorParameter.field, errorParameter.type];
            }
        } else {
            errorMessage = errorResponse.message;
        }
    } else {
        errorMessage = [error localizedDescription];
    }
    [TSMessage showNotificationInViewController:viewController withTitle:errorTitle withMessage:errorMessage withType:TSMessageNotificationTypeError];
}

@end
