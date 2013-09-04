//
//  LeadManager.h
//  Puntr
//
//  Created by Eugene Tulushev on 03.09.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LeadCellDelegate.h"
#import <Foundation/Foundation.h>

@interface LeadManager : NSObject <LeadCellDelegate>

+ (LeadManager *)manager;

@end
