//
//  CatalogueTournamentsViewController.h
//  Puntr
//
//  Created by Eugene Tulushev on 04.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchModel;

@interface CatalogueTournamentsViewController : UIViewController

@property (nonatomic, strong, readonly) SearchModel *search;

+ (CatalogueTournamentsViewController *)tournamentsWithSearch:(SearchModel *)search;

@end
