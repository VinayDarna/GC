//
//  PickerCell.m
//  Custom Cells App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "PickerCell.h"


@interface PickerCell ()

- (NSString *)titleForRow:(NSInteger)row;
- (NSInteger)rowForTitle:(NSString *)title;

@end



@implementation PickerCell

// overrides superclass
- (void)performInitialization
{
    [super performInitialization];
    
    // place any initialization code here
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    
    _pickerField = [[UITextField alloc] initWithFrame:CGRectZero];
	_pickerField.delegate = self;
	_pickerField.inputView = _pickerView;
	[self.contentView addSubview:_pickerField];
}

//overrides superclass
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//overrides superclass
- (BOOL)becomeFirstResponder
{
    return [_pickerField becomeFirstResponder];
}

//overrides superclass
- (BOOL)resignFirstResponder
{
	return [_pickerField resignFirstResponder];
}

// overrides superclass
- (void)loadBindingsIntoCustomControls
{
    [super loadBindingsIntoCustomControls];
    
    NSString *title = [self.boundObject valueForKey:@"title"];
    [_pickerView selectRow:[self rowForTitle:title] inComponent:0 animated:NO];
    self.label.text = title;
}

// overrides superclass
- (void)commitChanges
{
    if(!needsCommit)
		return;
	
	[super commitChanges];
    
    NSString *title = [self titleForRow:[_pickerView selectedRowInComponent:0]];
    [self.boundObject setValue:title forKey:@"title"];
    
    needsCommit = FALSE;
}

//override superclass
- (void)cellValueChanged
{	
	self.label.text = [self titleForRow:[_pickerView selectedRowInComponent:0]];
	
	[super cellValueChanged];
}

//override superclass
- (void)willDisplay
{
    [super willDisplay];
    
    self.textLabel.text = @"Title";
}

//override superclass
- (void)didSelectCell
{
    self.ownerTableViewModel.activeCell = self;
    
    [_pickerField becomeFirstResponder];
}

- (NSString *)titleForRow:(NSInteger)row
{
    NSString *title = nil;
    switch (row) 
    {
        case 0: title = @"";        break;
        case 1: title = @"Mr.";     break;
        case 2: title = @"Mrs.";    break;
        case 3: title = @"Ms.";     break;
        case 4: title = @"Other";   break;
    }
    return title;
}

- (NSInteger)rowForTitle:(NSString *)title
{
    NSInteger row = 0;
    
    for(NSInteger i=0; i<5; i++)
    {
        if([title isEqualToString:[self titleForRow:i]])
        {
            row = i;
            break;
        }
    }
    
    return row;
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}


#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self titleForRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self cellValueChanged];
}

@end
