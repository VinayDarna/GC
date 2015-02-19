/*
 *  SCCellActions.m
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


#import "SCCellActions.h"
#import "SCGlobals.h"

@implementation SCCellActions

@synthesize willStyle = _willStyle;
@synthesize willConfigure = _willConfigure;
@synthesize didLayoutSubviews = _didLayoutSubviews;
@synthesize willDisplay = _willDisplay;
@synthesize lazyLoad = _lazyLoad;
@synthesize willSelect = _willSelect;
@synthesize didSelect = _didSelect;
@synthesize willDeselect = _willDeselect;
@synthesize didDeselect = _didDeselect;
@synthesize accessoryButtonTapped = _accessoryButtonTapped;
@synthesize returnButtonTapped = _returnButtonTapped;
@synthesize valueChanged = _valueChanged;
@synthesize valueIsValid = _valueIsValid;
@synthesize didLoadBoundValue = _didLoadBoundValue;
@synthesize willCommitBoundValue = _willCommitBoundValue;
@synthesize customButtonTapped = _customButtonTapped;
@synthesize detailViewController = _detailViewController;
@synthesize detailTableViewModel = _detailTableViewModel;

@synthesize detailModelCreated = _detailModelCreated;
@synthesize detailModelConfigured = _detailModelConfigured;
@synthesize detailModelWillPresent = _detailModelWillPresent;
@synthesize detailModelDidPresent = _detailModelDidPresent;
@synthesize detailModelWillDismiss = _detailModelWillDismiss;
@synthesize detailModelDidDismiss = _detailModelDidDismiss;


- (id)init
{
    if( (self=[super init]) )
    {
        _willStyle = nil;
        _willConfigure = nil;
        _didLayoutSubviews = nil;
        _willDisplay = nil;
        _lazyLoad = nil;
        _willSelect = nil;
        _didSelect = nil;
        _willDeselect = nil;
        _didDeselect = nil;
        _accessoryButtonTapped = nil;
        _returnButtonTapped = nil;
        _valueChanged = nil;
        _valueIsValid = nil;
        _didLoadBoundValue = nil;
        _willCommitBoundValue = nil;
        _customButtonTapped = nil;
        
        _detailViewController = nil;
        _detailTableViewModel = nil;
        _detailModelCreated = nil;
        _detailModelConfigured = nil;
        _detailModelWillPresent = nil;
        _detailModelDidPresent = nil;
        _detailModelWillDismiss = nil;
        _detailModelDidDismiss = nil;
    }
    
    return self;
}



- (void)setActionsTo:(SCCellActions *)actions overrideExisting:(BOOL)override
{
    if((override || !self.willStyle) && actions.willStyle)
        self.willStyle = actions.willStyle;
    if((override || !self.willConfigure) && actions.willConfigure)
        self.willConfigure = actions.willConfigure;
    if((override || !self.didLayoutSubviews) && actions.didLayoutSubviews)
        self.didLayoutSubviews = actions.didLayoutSubviews;
    if((override || !self.willDisplay) && actions.willDisplay)
        self.willDisplay = actions.willDisplay;
    if((override || !self.lazyLoad) && actions.lazyLoad)
        self.lazyLoad = actions.lazyLoad;
    if((override || !self.willSelect) && actions.willSelect)
        self.willSelect = actions.willSelect;
    if((override || !self.didSelect) && actions.didSelect)
        self.didSelect = actions.didSelect;
    if((override || !self.willDeselect) && actions.willDeselect)
        self.willDeselect = actions.willDeselect;
    if((override || !self.didDeselect) && actions.didDeselect)
        self.didDeselect = actions.didDeselect;
    if((override || !self.accessoryButtonTapped) && actions.accessoryButtonTapped)
        self.accessoryButtonTapped = actions.accessoryButtonTapped;
    if((override || !self.returnButtonTapped) && actions.returnButtonTapped)
        self.returnButtonTapped = actions.returnButtonTapped;
    if((override || !self.valueChanged) && actions.valueChanged)
        self.valueChanged = actions.valueChanged;
    if((override || !self.valueIsValid) && actions.valueIsValid)
        self.valueIsValid = actions.valueIsValid;
    if((override || !self.didLoadBoundValue) && actions.didLoadBoundValue)
        self.didLoadBoundValue = actions.didLoadBoundValue;
    if((override || !self.willCommitBoundValue) && actions.willCommitBoundValue)
        self.willCommitBoundValue = actions.willCommitBoundValue;
    
    if((override || !self.customButtonTapped) && actions.customButtonTapped)
        self.customButtonTapped = actions.customButtonTapped;
    
    if((override || !self.detailViewController) && actions.detailViewController)
        self.detailViewController = actions.detailViewController;
    if((override || !self.detailTableViewModel) && actions.detailTableViewModel)
        self.detailTableViewModel = actions.detailTableViewModel;
    
    if((override || !self.detailModelCreated) && actions.detailModelCreated)
        self.detailModelCreated = actions.detailModelCreated;
    if((override || !self.detailModelConfigured) && actions.detailModelConfigured)
        self.detailModelConfigured = actions.detailModelConfigured;
    if((override || !self.detailModelWillPresent) && actions.detailModelWillPresent)
        self.detailModelWillPresent = actions.detailModelWillPresent;
    if((override || !self.detailModelDidPresent) && actions.detailModelDidPresent)
        self.detailModelDidPresent = actions.detailModelDidPresent;
    if((override || !self.detailModelWillDismiss) && actions.detailModelWillDismiss)
        self.detailModelWillDismiss = actions.detailModelWillDismiss;
    if((override || !self.detailModelDidDismiss) && actions.detailModelDidDismiss)
        self.detailModelDidDismiss = actions.detailModelDidDismiss;
}

@end




