//
//  PickerCell.h
//  Custom Cells App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//


@interface PickerCell : SCLabelCell <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextField *_pickerField;
    UIPickerView *_pickerView;
}

@end
