//
//  ParticipantViewController.h
//  Puntr
//
//  Created by Alexander Lebedev on 7/26/13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParticipantModel;

@interface ParticipantViewController : UIViewController

+ (ParticipantViewController *)controllerWithParticipant:(ParticipantModel *)participant;

@end
