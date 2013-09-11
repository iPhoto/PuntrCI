//
//  CopyrightViewController.h
//  Puntr
//
//  Created by Alexander Lebedev on 9/10/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CopyrightSelection)
{
    CopyrightSelectionOffer,
    CopyrightSelectionTerms
};

@interface CopyrightViewController : UIViewController

- (id)initWithCopyrightSelection:(CopyrightSelection) copyrightSelection;

@end
