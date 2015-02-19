/*
 *  SCSectionActions.m
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


#import "SCSectionActions.h"

#import "SCGlobals.h"


@implementation SCSectionActions

@synthesize didAddToModel = _didAddToModel;
@synthesize detailModelCreated = _detailModelCreated;
@synthesize detailModelConfigured = _detailModelConfigured;
@synthesize detailModelWillPresent = _detailModelWillPresent;
@synthesize detailModelDidPresent = _detailModelDidPresent;
@synthesize detailModelWillDismiss = _detailModelWillDismiss;
@synthesize detailModelDidDismiss = _detailModelDidDismiss;
@synthesize didFetchItemsFromStore = _didFetchItemsFromStore;
@synthesize fetchItemsFromStoreFailed = _failedFetchingItemsFromStore;
@synthesize didCreateItem = _didCreateItem;
@synthesize willInsertItem = _willInsertItem;
@synthesize didInsertItem = _didInsertItem;
@synthesize willUpdateItem = _willUpdateItem;
@synthesize didUpdateItem = _didUpdateItem;
@synthesize willDeleteItem = _willDeleteItem;
@synthesize didDeleteItem = _didDeleteItem;
@synthesize didAddSpecialCells = _addedSpecialCells;
@synthesize detailViewControllerForRowAtIndexPath = _detailViewControllerForRowAtIndexPath;
@synthesize detailTableViewModelForRowAtIndexPath = _detailTableViewModelForRowAtIndexPath;
@synthesize cellForRowAtIndexPath = _cellForRowAtIndexPath;
@synthesize reuseIdentifierForRowAtIndexPath = _reuseIdentifierForRowAtIndexPath;
@synthesize customHeightForRowAtIndexPath = _customHeightForRowAtIndexPath;

- (id)init
{
    if( (self=[super init]) )
    {
        _didAddToModel = nil;
        
        _detailModelCreated = nil;
        _detailModelConfigured = nil;
        _detailModelWillPresent = nil;
        _detailModelDidPresent = nil;
        _detailModelWillDismiss = nil;
        _detailModelDidDismiss = nil;
        
        _didFetchItemsFromStore = nil;
        _failedFetchingItemsFromStore = nil;
        _addedSpecialCells = nil;
        
        _didCreateItem = nil;
        _willInsertItem = nil;
        _didInsertItem = nil;
        _willUpdateItem = nil;
        _didUpdateItem = nil;
        _willDeleteItem = nil;
        _didDeleteItem = nil;
        
        _detailViewControllerForRowAtIndexPath = nil;
        _detailTableViewModelForRowAtIndexPath = nil;
        
        _cellForRowAtIndexPath = nil;
        _reuseIdentifierForRowAtIndexPath = nil;
        _customHeightForRowAtIndexPath = nil;
    }
    
    return self;
}


- (void)setActionsTo:(SCSectionActions *)actions overrideExisting:(BOOL)override
{
    if((override || !self.didAddToModel) && actions.didAddToModel)
        self.didAddToModel = actions.didAddToModel;
    
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
    
    if((override || !self.didFetchItemsFromStore) && actions.didFetchItemsFromStore)
        self.didFetchItemsFromStore = actions.didFetchItemsFromStore;
    if((override || !self.fetchItemsFromStoreFailed) && actions.fetchItemsFromStoreFailed)
        self.fetchItemsFromStoreFailed = actions.fetchItemsFromStoreFailed;
    if((override || !self.didAddSpecialCells) && actions.didAddSpecialCells)
        self.didAddSpecialCells = actions.didAddSpecialCells;
    
    if((override || !self.detailViewControllerForRowAtIndexPath) && actions.detailViewControllerForRowAtIndexPath)
        self.detailViewControllerForRowAtIndexPath = actions.detailViewControllerForRowAtIndexPath;
    if((override || !self.detailTableViewModelForRowAtIndexPath) && actions.detailTableViewModelForRowAtIndexPath)
        self.detailTableViewModelForRowAtIndexPath = actions.detailTableViewModelForRowAtIndexPath;
    
    if((override || !self.cellForRowAtIndexPath) && actions.cellForRowAtIndexPath)
        self.cellForRowAtIndexPath = actions.cellForRowAtIndexPath;
    if((override || !self.reuseIdentifierForRowAtIndexPath) && actions.reuseIdentifierForRowAtIndexPath)
        self.reuseIdentifierForRowAtIndexPath = actions.reuseIdentifierForRowAtIndexPath;
    if((override || !self.customHeightForRowAtIndexPath) && actions.customHeightForRowAtIndexPath)
        self.customHeightForRowAtIndexPath = actions.customHeightForRowAtIndexPath;
    
    if((override || !self.didCreateItem) && actions.didCreateItem)
        self.didCreateItem = actions.didCreateItem;
    if((override || !self.willInsertItem) && actions.willInsertItem)
        self.willInsertItem = actions.willInsertItem;
    if((override || !self.didInsertItem) && actions.didInsertItem)
        self.didInsertItem = actions.didInsertItem;
    if((override || !self.willUpdateItem) && actions.willUpdateItem)
        self.willUpdateItem = actions.willUpdateItem;
    if((override || !self.didUpdateItem) && actions.didUpdateItem)
        self.didUpdateItem = actions.didUpdateItem;
    if((override || !self.willDeleteItem) && actions.willDeleteItem)
        self.willDeleteItem = actions.willDeleteItem;
    if((override || !self.didDeleteItem) && actions.didDeleteItem)
        self.didDeleteItem = actions.didDeleteItem;
}


@end
