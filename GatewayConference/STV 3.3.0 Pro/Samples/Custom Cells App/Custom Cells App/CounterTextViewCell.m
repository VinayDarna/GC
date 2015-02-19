//
//  MyTextViewCell.m
//  Custom Cells App
//
//  Copyright (c) 2013 Sensible Cocoa. All rights reserved.
//

#import "CounterTextViewCell.h"

@implementation CounterTextViewCell


// overrides superclass
- (void)performInitialization
{
    [super performInitialization];
    
    // place any initialization code here
    
    _counterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _counterLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _counterLabel.textColor = [UIColor grayColor];
	[self.contentView addSubview:_counterLabel];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textViewFrame = self.textView.frame;
    self.counterLabel.frame = CGRectMake(textViewFrame.origin.x+textViewFrame.size.width-20, textViewFrame.origin.y+textViewFrame.size.height-25, 30, 20);
}

- (void)willDisplay
{
    [super willDisplay];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%i", [self.textView.text length]];
}

- (void)textViewDidChange:(UITextView *)_textView
{
    [super textViewDidChange:_textView];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%i", [self.textView.text length]];
}

@end
