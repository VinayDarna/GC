/*
 *  SCiCloudKeyValueStore.m
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


#import "SCiCloudKeyValueStore.h"

#import "SCiCloudForceLinkerToIncludeCategories.h"


@implementation SCiCloudKeyValueStore

- (NSUbiquitousKeyValueStore *)defaultiCloudKeyValueObject
{
    if([[NSUbiquitousKeyValueStore class] respondsToSelector:@selector(defaultStore)])
        return [NSUbiquitousKeyValueStore defaultStore];
    //else
    return nil;
}

// overrides superclass
- (SCDataDefinition *)definitionForObject:(NSObject *)object
{
    return self.defaultDataDefinition;
}

// overrides superclass
- (NSArray *)fetchObjectsWithOptions:(SCDataFetchOptions *)fetchOptions
{
#ifdef SC_STVLITE
    return [NSArray arrayWithObject:[SCLicenseManager unlicensediCloudObject]];
#endif
    
    
    return [NSArray arrayWithObject:self.defaultiCloudKeyValueObject];
}

// overrides superclass
- (void)commitData
{
    [self.defaultiCloudKeyValueObject synchronize];
}


#pragma mark -
#pragma mark Linker related

- (void)forceLinker
{
    [SCiCloudForceLinkerToIncludeCategories forceLinker];
}


@end
