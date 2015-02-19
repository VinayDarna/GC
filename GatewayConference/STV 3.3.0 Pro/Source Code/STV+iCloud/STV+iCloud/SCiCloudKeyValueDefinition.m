/*
 *  SCiCloudKeyValueDefinition.m
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


#import "SCiCloudKeyValueDefinition.h"

#import "SCiCloudKeyValueStore.h"
#import "SCiCloudForceLinkerToIncludeCategories.h"


@implementation SCiCloudKeyValueDefinition


+ (id)definitionWithiCloudKeyNamesString:(NSString *)keyNamesString
{
    return [[[self class] alloc] initWithiCloudKeyNamesString:keyNamesString];
}

+ (id)definitionWithiCloudKeyNames:(NSArray *)keyNames
{
    return [[[self class] alloc] initWithiCloudKeyNames:keyNames];
}

+ (id)definitionWithiCloudKeyNames:(NSArray *)keyNames keyTitles:(NSArray *)keyTitles
{
    return [[[self class] alloc] initWithiCloudKeyNames:keyNames keyTitles:keyTitles];
}


- (id)initWithiCloudKeyNamesString:(NSString *)keyNamesString
{
    return [self initWithDictionaryKeyNamesString:keyNamesString];
}

- (id)initWithiCloudKeyNames:(NSArray *)keyNames
{
    return [self initWithDictionaryKeyNames:keyNames];
}

- (id)initWithiCloudKeyNames:(NSArray *)keyNames keyTitles:(NSArray *)keyTitles
{
    return [self initWithDictionaryKeyNames:keyNames keyTitles:keyTitles];
}


// overrides superclass
- (SCDataStore *)generateCompatibleDataStore
{
    return [SCiCloudKeyValueStore storeWithDefaultDataDefinition:self];
}


#pragma mark -
#pragma mark Linker related

- (void)forceLinker
{
    [SCiCloudForceLinkerToIncludeCategories forceLinker];
}

@end
