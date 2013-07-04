//
//  TNIMessagePresenter.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNIMessagePresenter : NSObject

+ (void)showError:(NSError *)error forViewController:(UIViewController *)viewController;

@end
