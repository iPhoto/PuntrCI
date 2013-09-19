//
//  PuntrUtilities.m
//  Puntr
//
//  Created by Momus on 11.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "PuntrUtilities.h"
#import <CoreImage/CoreImage.h>

@implementation PuntrUtilities

+ (UINavigationController *)mainNavigationController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        UINavigationController *mainNavigationController = (UINavigationController *)[(UITabBarController *)topController selectedViewController];
        return mainNavigationController;
    }
    else if ([topController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)topController;
    }
    else
    {
        return nil;
    }
}

+ (UIViewController *)topController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([topController isKindOfClass:[UITabBarController class]])
    {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    if ([topController isKindOfClass:[UINavigationController class]])
    {
        topController = [(UINavigationController *)topController visibleViewController];
    }
    return topController;
}

+ (UIImage *)blurImage:(UIImage*)image
{
    // create our blurred image
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    return [UIImage imageWithCIImage:result];
}

@end
