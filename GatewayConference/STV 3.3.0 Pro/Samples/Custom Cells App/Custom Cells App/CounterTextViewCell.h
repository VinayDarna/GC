//
//  MyTextViewCell.h
//  Custom Cells App
//
//  Copyright (c) 2013 Sensible Cocoa. All rights reserved.
//

//  This is an implementation of a text view cell that subclasses SCTextViewCell
//  to add a counter that counts the number of characters typed.


@interface CounterTextViewCell : SCTextViewCell

@property (nonatomic, readonly) UILabel *counterLabel;

@end
