//
//  LinePicker.m
//  Puntr
//
//  Created by Eugene Tulushev on 23.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "LinePicker.h"
#import "LineModel.h"

@interface LinePicker ()

@property (nonatomic, strong) NSArray *lines;

@property (nonatomic, strong) LineModel *selectedLine;

@property (nonatomic, copy) LineDoneBlock onActionSheetDone;
@property (nonatomic, copy) LineCancelBlock onActionSheetCancel;

@end

@implementation LinePicker

+ (id)showPickerWithLines:(NSArray *)lines
             selectedLine:(LineModel *)selectedLine
                doneBlock:(LineDoneBlock)doneBlock
              cancelBlock:(LineCancelBlock)cancelBlock
                   origin:(id)origin
{
    LinePicker *picker = [[LinePicker alloc] initWithLines:lines
                                              selectedLine:selectedLine
                                                 doneBlock:doneBlock
                                               cancelBlock:cancelBlock
                                                    origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithLines:(NSArray *)lines
       selectedLine:(LineModel *)selectedLine
          doneBlock:(LineDoneBlock)doneBlock
        cancelBlock:(LineCancelBlock)cancelBlock
             origin:(id)origin
{
    self = [super initWithTarget:nil
                   successAction:nil
                    cancelAction:nil
                          origin:origin];
    if (self)
    {
        _lines = lines;
        _selectedLine = selectedLine;
        _onActionSheetDone = doneBlock;
        _onActionSheetCancel = cancelBlock;
    }
    return self;
}

- (UIView *)configuredPickerView
{
    if (!self.lines)
    {
        return nil;
    }
    CGRect pickerFrame = CGRectMake(0.0f, 45.0f, self.viewSize.width, 216.0f);
    UIPickerView *componentsPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    componentsPicker.delegate = self;
    componentsPicker.dataSource = self;
    componentsPicker.showsSelectionIndicator = YES;
    [componentsPicker selectRow:0 inComponent:0 animated:NO];
    self.pickerView = componentsPicker;
    return componentsPicker;
}

#pragma mark - Actions

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin
{
    if (self.onActionSheetDone)
    {
        _onActionSheetDone(self, self.selectedLine);
        return;
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin
{
    if (self.onActionSheetCancel)
    {
        _onActionSheetCancel(self);
        return;
    }
}

#pragma mark - Style

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title
{
    CGRect frame = CGRectMake(0.0f, 0.0f, self.viewSize.width, 45.0f);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (NSDictionary *buttonDetails in self.customButtons)
    {
        NSString *buttonTitle = [buttonDetails objectForKey:@"buttonTitle"];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(customButtonPressed:)];
        button.tag = index;
        [barItems addObject:button];
        index++;
    }
    if (NO == self.hideCancel)
    {
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Отмена"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(actionPickerCancel:)];
        [barItems addObject:cancelBtn];
    }
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    if (title)
    {
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Далее"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle
{
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont fontWithName:@"EtelkaMedium-Bold" size:20.0f]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    return buttonLabel;
}

#pragma mark - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedLine = (LineModel *)self.lines[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LineModel *line = (LineModel *)self.lines[row];
    if (row == [self.lines indexOfObject:self.lines.lastObject])
    {
        NSInteger selectedLineIndex = 0;
        if (self.selectedLine)
        {
            selectedLineIndex = [self.lines indexOfObject:self.selectedLine] == NSIntegerMax ? 0 : [self.lines indexOfObject:self.selectedLine];
        }
        else
        {
            self.selectedLine = (LineModel *)self.lines[0];
        }
        [self performSelector:@selector(scrollToLine:) withObject:@(selectedLineIndex) afterDelay:0.1f];
    }
    return line.title;
}

- (void)scrollToLine:(NSNumber *)line
{
    [(UIPickerView *)self.pickerView selectRow : line.integerValue inComponent : 0 animated : NO];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat padding = 11.0f;
    CGFloat screenWidth = 320.0f;
    return screenWidth - padding * 2.0f;
}

#pragma mark - PickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.lines.count;
}

@end
