/*
 *  SCDataDefinition.m
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


#import "SCDataDefinition.h"
#import "SCGlobals.h"
#import "SCTableViewCell.h"




@implementation SCDataDefinition


@synthesize requireEditingModeToEditPropertyValues;
@synthesize keyPropertyName;
@synthesize titlePropertyName;
@synthesize titlePropertyNameDelimiter;
@synthesize descriptionPropertyName;
@synthesize defaultPropertyGroup;
@synthesize propertyGroups;
@synthesize cellActions = _cellActions;




- (id) init
{
	if( (self = [super init]) )
	{
		propertyDefinitions = [[NSMutableArray alloc] init];
        requireEditingModeToEditPropertyValues = FALSE;
        keyPropertyName = nil;
		titlePropertyName = nil;
		titlePropertyNameDelimiter = @" ";
		descriptionPropertyName = nil;
		
        defaultPropertyGroup = [[SCPropertyGroup alloc] init];
        propertyGroups = [[SCPropertyGroupArray alloc] init];
        
        _cellActions = [[SCCellActions alloc] init];
	}
	return self;
}


- (void)setKeyPropertyName:(NSString *)propertyName
{
	if([self isValidPropertyName:propertyName])
	{
		keyPropertyName = [propertyName copy];
	}
    else
    {
        SCDebugLog(@"Warning: Invalid keyPropertyName: '%@'.", propertyName);
    }
}

- (NSString *)dataStructureName
{
    // Subclasses must override.
    
	return nil;
}

- (NSUInteger)propertyDefinitionCount
{
	return propertyDefinitions.count;
}

- (BOOL)addPropertyDefinitionWithName:(NSString *)propertyName 
								title:(NSString *)propertyTitle
								 type:(SCPropertyType)propertyType
{
    if(![propertyName length])
        return FALSE;
    
	SCPropertyDefinition *propertyDefinition;
    if( [propertyName characterAtIndex:0] == '~' )
    {
        // A custom property definition
        propertyDefinition = [SCCustomPropertyDefinition definitionWithName:propertyName uiElementClass:[SCTableViewCell class] objectBindingsString:nil];
        propertyDefinition.title = propertyTitle;
    }
    else
    {
        propertyDefinition =
        [[SCPropertyDefinition alloc] initWithName:propertyName
                                             title:propertyTitle
                                              type:propertyType];
    }
    
	BOOL success = [self addPropertyDefinition:propertyDefinition];
	
	return success;
}

- (BOOL)addPropertyDefinition:(SCPropertyDefinition *)propertyDefinition
{
	NSUInteger index = self.propertyDefinitionCount;
	
	return [self insertPropertyDefinition:propertyDefinition atIndex:index];
}

- (BOOL)insertPropertyDefinition:(SCPropertyDefinition *)propertyDefinition
						 atIndex:(NSInteger)index
{
    [propertyDefinitions insertObject:propertyDefinition atIndex:index];
    propertyDefinition.ownerDataStuctureDefinition = self;
    return TRUE;
}

- (void)removePropertyDefinitionAtIndex:(NSUInteger)index
{
	[propertyDefinitions removeObjectAtIndex:index];
}

- (void)removePropertyDefinitionWithName:(NSString *)propertyName
{
	NSUInteger index = [self indexOfPropertyDefinitionWithName:propertyName];
	if(index != NSNotFound)
		[propertyDefinitions removeObjectAtIndex:index];
}

- (SCPropertyDefinition *)propertyDefinitionAtIndex:(NSUInteger)index
{
	return [propertyDefinitions objectAtIndex:index];
}

- (SCPropertyDefinition *)propertyDefinitionWithName:(NSString *)propertyName
{
	NSUInteger index = [self indexOfPropertyDefinitionWithName:propertyName];
	if(index != NSNotFound)
		return [propertyDefinitions objectAtIndex:index];
	//else
	return nil;
}

- (NSUInteger)indexOfPropertyDefinitionWithName:(NSString *)propertyName
{
	for(NSUInteger i=0; i<propertyDefinitions.count; i++)
	{
		SCPropertyDefinition *propertyDefinition = [propertyDefinitions objectAtIndex:i];
		if([propertyDefinition.name isEqualToString:propertyName])
			return i;
	}
	return NSNotFound;
}


- (void)setupDefaultConfiguration
{
    // Setup keyPropertyName
    for(SCPropertyDefinition *propertyDef in propertyDefinitions)
        if([self isValidPropertyName:propertyDef.name])
        {
            self.keyPropertyName = propertyDef.name;
            break;
        }
    
    // Setup titlePropertyName
    self.titlePropertyName = self.keyPropertyName;
}

- (SCDataType)propertyDataTypeForPropertyWithName:(NSString *)propertyName
{
	// Subclasses should override.
    
	return SCDataTypeUnknown;
}

- (BOOL)isValidPropertyName:(NSString *)propertyName
{
    // Subclasses must override.
    
	return TRUE;
}

- (NSString *)titleValueForObject:(NSObject *)object
{
	return [SCUtilities stringValueForPropertyName:self.titlePropertyName inObject:object
				   separateValuesUsingDelimiter:self.titlePropertyNameDelimiter];
}

- (NSObject *)objectWithTitle:(NSString *)title inObjectsArray:(NSArray *)objectsArray
{
    for(NSObject *object in objectsArray)
    {
        if([[self titleValueForObject:object] isEqualToString:title])
            return object;
    }
    
    return nil;
}

- (NSString *)descriptionValueForObject:(NSObject *)object
{
    return [SCUtilities stringValueForPropertyName:self.descriptionPropertyName inObject:object
				   separateValuesUsingDelimiter:@" "];
}

- (void)generatePropertiesFromPropertyNamesArray:(NSArray *)propertyNamesArray propertyTitlesArray:(NSArray *)propertyTitlesArray
{
    // Should be overriden by subclasses
}

- (void)generatePropertiesFromPropertyNamesString:(NSString *)propertyNamesString
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    NSCharacterSet *spaceTrimSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSArray *propertiesComponents = [propertyNamesString componentsSeparatedByString:@";"];
    for(NSString *untrimmedPropertyComponent in propertiesComponents)
    {
        NSString *propertyComponent = [untrimmedPropertyComponent stringByTrimmingCharactersInSet:spaceTrimSet];
        if(![propertyComponent length])
            continue;
            
        // Check if the propertyComponent has a group
        NSArray *groupComponents = [propertyComponent componentsSeparatedByString:@":"];
        if(groupComponents.count > 1)  // has a group
        {
            NSString *groupName = [(NSString *)[groupComponents objectAtIndex:0] stringByTrimmingCharactersInSet:spaceTrimSet];
            if(![groupName length])
                groupName = nil;
            NSString *groupFooter = nil;
            if(groupComponents.count > 2)
            {
                groupFooter = [(NSString *)[groupComponents objectAtIndex:2] stringByTrimmingCharactersInSet:spaceTrimSet];
                if(![groupFooter length])
                    groupFooter = nil;
            }
            
            NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString:@" ()"];
            NSString *groupPropertiesString = [groupComponents objectAtIndex:1];
            groupPropertiesString = [groupPropertiesString stringByTrimmingCharactersInSet:trimSet];
            NSArray *groupProperties = [groupPropertiesString componentsSeparatedByString:@","];
            NSMutableArray *trimmedGroupProperties = [NSMutableArray array];
            for(NSString *groupProperty in groupProperties)
            {
                [trimmedGroupProperties addObject:[groupProperty stringByTrimmingCharactersInSet:spaceTrimSet]];
            }
            
            // Create the group
            SCPropertyGroup *propertyGroup = [SCPropertyGroup groupWithHeaderTitle:groupName footerTitle:groupFooter propertyNames:trimmedGroupProperties];
            [self.propertyGroups addGroup:propertyGroup];
            
            [propertyNames addObjectsFromArray:trimmedGroupProperties];
        }
        else 
        {
            [propertyNames addObject:propertyComponent];
        }
    }
    
    [self generatePropertiesFromPropertyNamesArray:propertyNames propertyTitlesArray:nil];
}

- (void)generateDefaultPropertyGroupProperties
{
    [self.defaultPropertyGroup removeAllPropertyNames];
    for(SCPropertyDefinition *propertyDef in propertyDefinitions)
    {
        BOOL propertyHasGroup = FALSE;
        for(NSInteger i=0; i<propertyGroups.groupCount; i++)
        {
            SCPropertyGroup *propertyGroup = [propertyGroups groupAtIndex:i];
            if([propertyGroup containsPropertyName:propertyDef.name])
            {
                propertyHasGroup = TRUE;
                break;
            }
        }
        if(!propertyHasGroup)
            [self.defaultPropertyGroup addPropertyName:propertyDef.name];
    }
}

- (SCDataStore *)generateCompatibleDataStore
{
    // Subclasses must override
    return nil;
}

- (SCDataFetchOptions *)generateCompatibleDataFetchOptions
{
    SCDataFetchOptions *fetchOptions = [[SCDataFetchOptions alloc] init];
    fetchOptions.sortKey = self.keyPropertyName;
    
    return fetchOptions;
}

@end
