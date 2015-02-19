/*
 *  SCDetailViewControllerOptions.m
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


#import "SCDetailViewControllerOptions.h"


@interface SCDetailViewControllerOptions ()
{
    SCPresentationMode _presentationMode;
    UIModalPresentationStyle _modalPresentationStyle;
    SCNavigationBarType _navigationBarType;
    NSString *_title;
    UITableViewStyle _tableViewStyle;
    BOOL _hidesBottomBarWhenPushed;
}

@end



@implementation SCDetailViewControllerOptions

@synthesize presentationMode = _presentationMode;
@synthesize modalPresentationStyle = _modalPresentationStyle;
@synthesize navigationBarType = _navigationBarType;
@synthesize allowEditingModeCancelButton = _allowEditingModeCancelButton;
@synthesize title = _title;
@synthesize tableViewStyle = _tableViewStyle;
@synthesize hidesBottomBarWhenPushed = _hidesBottomBarWhenPushed;


- (id)init
{
    if( (self=[super init]) )
    {
        _presentationMode = SCPresentationModeAuto;
        _modalPresentationStyle = UIModalPresentationPageSheet;
        _navigationBarType = SCNavigationBarTypeAuto;
        _allowEditingModeCancelButton = TRUE;
        _title = nil;
        _tableViewStyle = UITableViewStyleGrouped;
        _hidesBottomBarWhenPushed = TRUE;
    }
    return self;
}

@end


