//
//  FacebookFriendsListModel.h
//  Puntr
//
//  Created by Momus on 03.10.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookFriendsListModel : NSObject

@property (nonatomic, strong) NSDictionary *friendsList;
@property (nonatomic, strong) NSString *pagingNext;

@end
