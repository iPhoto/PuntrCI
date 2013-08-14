//
//  LinePicker.h
//  Puntr
//
//  Created by Eugene Tulushev on 23.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "AbstractActionSheetPicker.h"

@class LinePicker, LineModel;

typedef void (^LineDoneBlock)(LinePicker *picker, LineModel *line);
typedef void (^LineCancelBlock)(LinePicker *picker);

@interface LinePicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

+ (id)showPickerWithLines:(NSArray *)lines
             selectedLine:(LineModel *)selectedLine
                doneBlock:(LineDoneBlock)doneBlock
              cancelBlock:(LineCancelBlock)cancelBlock
                   origin:(id)origin;

@end
