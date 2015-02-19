/*
 *  SCViewControllerActions.m
 *  Sensible TableView
 *  Version: 3.3.0
 *
 *
 *	THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY UNITED STATES 
 *	INTELLECTUAL PROPERTY LAW AND INTERNATIONAL TREATIES. UNAUTHORIZED REPRODUCTION OR 
 *	DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. YOU SHALL NOT DEVELOP NOR
 *	MAKE AVAILABLE ANY WORK THAT COMPETES WITH A SENSIBLE COCOA PRODUCT DERIVED FROM THIS 
 *	SOURCE CODE. THIS SOURCE CODE MAY NOT BE RESOLD OR REDISTRIBUTED ON A STAND ALONE BASIS.
 *
 *	USAGE OF THIS SOURCE CODE IS BOUND BY THE LICENSE AGREEMENT PROVIDED WITH THE 
 *	DOWNLOADED PRODUCT.
 *
 *  Copyright 2012-2013 Sensible Cocoa. All rights reserved.
 *
 *
 *	This notice may not be removed from this file.
 *
 */

#import "SCViewControllerActions.h"

@implementation SCViewControllerActions

@synthesize willAppear = _willAppear;
@synthesize didAppear = _didAppear;
@synthesize willDisappear = _willDisappear;
@synthesize didDisappear = _didDisappear;
@synthesize willPresent = _willPresent;
@synthesize didPresent = _didPresent;
@synthesize willDismiss = _willDismiss;
@synthesize didDismiss = _didDismiss;
@synthesize cancelButtonTapped = _cancelButtonTapped;
@synthesize doneButtonTapped = _doneButtonTapped;
@synthesize editButtonTapped = _editButtonTapped;


- (id)init
{
    if( (self=[super init]) )
    {
        _willAppear = nil;
        _didAppear = nil;
        _willDisappear = nil;
        _didDisappear = nil;
        _willPresent = nil;
        _didPresent = nil;
        _willDismiss = nil;
        _didDismiss = nil;
        
        _cancelButtonTapped = nil;
        _doneButtonTapped = nil;
        _editButtonTapped = nil;
    }
    
    return self;
}

@end
