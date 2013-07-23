//
//  ComponentPicker.m
//  Puntr
//
//  Created by Eugene Tulushev on 23.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "ComponentPicker.h"
#import "ComponentModel.h"

@interface ComponentPicker ()

@property (nonatomic, strong) NSArray *components;

@property (nonatomic, copy) ComponentBlock onActionSheetDone;
@property (nonatomic, copy) ComponentBlock onActionSheetCancel;

@end

@implementation ComponentPicker

+ (id)showPickerWithComponents:(NSArray *)components doneBlock:(ComponentBlock)doneBlock cancelBlock:(ComponentBlock)cancelBlock origin:(id)origin {
    ComponentPicker *picker = [[ComponentPicker alloc] initWithComponents:components doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithComponents:(NSArray *)components doneBlock:(ComponentBlock)doneBlock cancelBlock:(ComponentBlock)cancelBlock origin:(id)origin {
    self = [super initWithTarget:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        _components = components;
        _onActionSheetDone = doneBlock;
        _onActionSheetCancel = cancelBlock;
    }
    return self;
}

- (UIView *)configuredPickerView {
    if (!self.components) {
        return nil;
    }
    CGRect pickerFrame = CGRectMake(0.0f, 50.0f, self.viewSize.width, 216.0f);
    UIPickerView *componentsPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    componentsPicker.delegate = self;
    componentsPicker.dataSource = self;
    componentsPicker.showsSelectionIndicator = YES;
    self.pickerView = componentsPicker;
    return componentsPicker;
}

#pragma mark - Actions

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, self.components);
        return;
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self, self.components);
        return;
    }
}

#pragma mark - Style

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    CGRect frame = CGRectMake(0.0f, 0.0f, self.viewSize.width, 45.0f);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for (NSDictionary *buttonDetails in self.customButtons) {
        NSString *buttonTitle = [buttonDetails objectForKey:@"buttonTitle"];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(customButtonPressed:)];
        button.tag = index;
        [barItems addObject:button];
        index++;
    }
    if (NO == self.hideCancel) {
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(actionPickerCancel:)];
        [barItems addObject:cancelBtn];
    }
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Далее" style:UIBarButtonItemStyleDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    //    [toolBarItemlabel setTextAlignment:UITextAlignmentCenter];
    [toolBarItemlabel setTextAlignment:NSTextAlignmentCenter];
    [toolBarItemlabel setTextColor:[UIColor whiteColor]];
    [toolBarItemlabel setFont:[UIFont fontWithName:@"EtelkaMedium-Bold" size:20.0f]];
    [toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
    toolBarItemlabel.text = aTitle;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
    return buttonLabel;
}

#pragma mark - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ComponentModel *activeComponent = (ComponentModel *)self.components[component];
    CriterionModel *criterion = (CriterionModel *)activeComponent.criteria[row];
    activeComponent.selectedCriterion = criterion.tag;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ComponentModel *activeComponent = (ComponentModel *)self.components[component];
    CriterionModel *criterion = (CriterionModel *)activeComponent.criteria[row];
    if (row == [activeComponent.criteria indexOfObject:activeComponent.criteria.lastObject]) {
        [self scrollToSelectedInComponent:component];
    }
    return criterion.title;
}

- (void)scrollToSelectedInComponent:(NSInteger)component {
    ComponentModel *activeComponent = self.components[component];
    NSInteger row = 0;
    if (activeComponent.selectedCriterion) {
        NSUInteger index = 0;
        for (CriterionModel *criterion in activeComponent.criteria) {
            if ([activeComponent.selectedCriterion isEqualToNumber:criterion.tag]) {
                row = index;
                break;
            }
            index++;
        }
    }
    [(UIPickerView *)self.pickerView selectRow:row inComponent:component animated:YES];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat padding = 11.0f;
    CGFloat screenWidth = 320.0f;
    CGFloat pickerWidth = screenWidth - padding * 2.0f;
    return pickerWidth / self.components.count;
}

#pragma mark - PickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.components.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[(ComponentModel *)self.components[component] criteria] count];
}

@end
