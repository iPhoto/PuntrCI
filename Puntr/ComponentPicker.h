//
//  ComponentPicker.h
//  Puntr
//
//  Created by Eugene Tulushev on 23.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import <ActionSheetPicker/AbstractActionSheetPicker.h>

@class ComponentPicker;

typedef void (^ComponentBlock)(ComponentPicker *picker, NSArray *components);

@interface ComponentPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

+ (id)showPickerWithComponents:(NSArray *)components doneBlock:(ComponentBlock)doneBlock cancelBlock:(ComponentBlock)cancelBlock origin:(id)origin;

@end
