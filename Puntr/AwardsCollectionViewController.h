//
//  AwardsCollectionViewController.h
//  Puntr
//
//  Created by Momus on 26.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionManagerDelegate.h"

@class UserModel;

@interface AwardsCollectionViewController : UIViewController <CollectionManagerDelegate>

- (id)initWithUser:(UserModel *)user;

@end
