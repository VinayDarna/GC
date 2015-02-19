/*
 *  SCModelActions.m
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


#import "SCModelActions.h"

#import "SCTableViewModel.h"


@implementation SCModelActions

@synthesize didAddSection = _didAddSection;
@synthesize sortSections = _sortSections;
@synthesize didRefresh = _didRefresh;
@synthesize didFetchItemsFromStore = _itemsFetchedFromStore;
@synthesize sectionHeaderTitleForItem = _sectionHeaderTitleForItem;
@synthesize ownerTableViewModel = _ownerTableViewModel;

- (id)init
{
    if( (self=[super init]) )
    {
        _didAddSection = nil;
        _sortSections = nil;
        _didRefresh = nil;
        
        _itemsFetchedFromStore = nil;
        _sectionHeaderTitleForItem = nil;
        
        _ownerTableViewModel = nil;
    }
    
    return self;
}


- (void)setActionsTo:(SCModelActions *)actions overrideExisting:(BOOL)override
{
    if((override || !self.didAddSection) && actions.didAddSection)
        self.didAddSection = actions.didAddSection;
    if((override || !self.sortSections) && actions.sortSections)
        self.sortSections = actions.sortSections;
    if((override || !self.didRefresh) && actions.didRefresh)
        self.didRefresh = actions.didRefresh;
    
    if((override || !self.didFetchItemsFromStore) && actions.didFetchItemsFromStore)
        self.didFetchItemsFromStore = actions.didFetchItemsFromStore;
    if((override || !self.sectionHeaderTitleForItem) && actions.sectionHeaderTitleForItem)
        self.sectionHeaderTitleForItem = actions.sectionHeaderTitleForItem;
}


@end
