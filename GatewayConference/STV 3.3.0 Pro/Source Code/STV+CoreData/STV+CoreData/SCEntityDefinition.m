/*
 *  SCEntityDefinition.m
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

#import "SCEntityDefinition.h"

#import "SCCoreDataFetchOptions.h"
#import "SCCoreDataStore.h"
#import "SCCoreDataForceLinkerToIncludeCategories.h"


@implementation SCEntityDefinition

@synthesize entity = _entity;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize orderAttributeName = _orderAttributeName;

+ (id)definitionWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context autoGeneratePropertyDefinitions:(BOOL)autoGenerate
{
	return [[[self class] alloc] initWithEntityName:entityName managedObjectContext:context autoGeneratePropertyDefinitions:autoGenerate];
}

+ (id)definitionWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNamesString:(NSString *)propertyNamesString
{
    return [[[self class] alloc] initWithEntityName:entityName managedObjectContext:context propertyNamesString:propertyNamesString];
}

+ (id)definitionWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNames:(NSArray *)propertyNames
{
	return [[[self class] alloc] initWithEntityName:entityName managedObjectContext:context propertyNames:propertyNames];
}

+ (id)definitionWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNames:(NSArray *)propertyNames propertyTitles:(NSArray *)propertyTitles
{
	return [[[self class] alloc] initWithEntityName:entityName managedObjectContext:context propertyNames:propertyNames propertyTitles:propertyTitles];
}

+ (id)definitionWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyGroups:(SCPropertyGroupArray *)groups
{
    return [[[self class] alloc] initWithEntityName:entityName managedObjectContext:context propertyGroups:groups];
}

// overrides superclass
- (SCDataType)propertyDataTypeForPropertyWithName:(NSString *)propertyName
{
	SCDataType dataType = SCDataTypeUnknown;
	
    NSPropertyDescription *propertyDescription = [[self.entity propertiesByName] valueForKey:propertyName];
    
    if(propertyDescription)
    {
        if([propertyDescription isKindOfClass:[NSAttributeDescription class]])
        {
            NSAttributeDescription *attribute = (NSAttributeDescription *)propertyDescription;
            switch ([attribute attributeType]) 
            {
                case NSInteger16AttributeType:
                case NSInteger32AttributeType:
                case NSInteger64AttributeType:
                    dataType = SCDataTypeNSNumber;
                    break;
                    
                case NSDecimalAttributeType:
                case NSDoubleAttributeType:
                case NSFloatAttributeType:
                    dataType = SCDataTypeNSNumber;
                    break;
                    
                case NSStringAttributeType:
                    dataType = SCDataTypeNSString;
                    break;
                    
                case NSBooleanAttributeType:
                    dataType = SCDataTypeNSNumber;
                    break;
                    
                case NSDateAttributeType:
                    dataType = SCDataTypeNSDate;
                    break;
                    
                case NSTransformableAttributeType:
                    dataType = SCDataTypeTransformable;
                    break;
                    
                default:
                    dataType = SCDataTypeUnknown;
                    break;
            }
        }
        if([propertyDescription isKindOfClass:[NSRelationshipDescription class]])
        {
            NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;
            
            if([relationship isToMany])
            {
                dataType = SCDataTypeNSMutableSet;
            }
            else
            {
                dataType = SCDataTypeNSObject;
            }
        }
        else
            if([propertyDescription isKindOfClass:[NSFetchedPropertyDescription class]])
            {
                dataType = SCDataTypeNSMutableSet;
            }
    }
	
	return dataType;
}


- (id)initWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context autoGeneratePropertyDefinitions:(BOOL)autoGenerate
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
														 inManagedObjectContext:context];
	
	if(!autoGenerate)
	{
		self = [self init];
		_managedObjectContext = context;
		_entity = entityDescription;
		return self;
	}
	//else
	
	NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:entityDescription.properties.count];
	for(NSPropertyDescription *propertyDescription in entityDescription.properties)
	{
		[propertyNames addObject:[propertyDescription name]];
	}
	return [self initWithEntityName:entityName managedObjectContext:context propertyNames:propertyNames];
}

- (id)initWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNamesString:(NSString *)propertyNamesString
{
	if( (self = [self init]) )
	{
		_managedObjectContext = context;
		_entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
		
		[self generatePropertiesFromPropertyNamesString:propertyNamesString];
		
		[self setupDefaultConfiguration];
	}
	
	return self;
}

- (id)initWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNames:(NSArray *)propertyNames
{
	return [self initWithEntityName:entityName managedObjectContext:context propertyNames:propertyNames propertyTitles:nil];
}

- (id)initWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyNames:(NSArray *)propertyNames propertyTitles:(NSArray *)propertyTitles
{
	if( (self = [self init]) )
	{
		_managedObjectContext = context;
		_entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
		
		[self generatePropertiesFromPropertyNamesArray:propertyNames propertyTitlesArray:propertyTitles];
		
		[self setupDefaultConfiguration];
	}
	
	return self;
}

- (id)initWithEntityName:(NSString *)entityName managedObjectContext:(NSManagedObjectContext *)context propertyGroups:(SCPropertyGroupArray *)groups
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    for(NSInteger i=0; i<groups.groupCount; i++)
    {
        SCPropertyGroup *propertyGroup = [groups groupAtIndex:i];
        for(NSInteger j=0; j<propertyGroup.propertyNameCount; j++)
            [propertyNames addObject:[propertyGroup propertyNameAtIndex:j]];
    }
    
    if( (self=[self initWithEntityName:entityName managedObjectContext:context propertyNames:propertyNames]) )
    {
        for(NSInteger i=0; i<groups.groupCount; i++)
        {
            [self.propertyGroups addGroup:[groups groupAtIndex:i]];
        }
    }
      
    return self;
}


// overrides superclass
- (void)generatePropertiesFromPropertyNamesArray:(NSArray *)propertyNamesArray propertyTitlesArray:(NSArray *)propertyTitlesArray
{
    for(int i=0; i<propertyNamesArray.count; i++)
    {
        // Get entity and propertyName
        NSEntityDescription *_dynamicentity = self.entity;
        NSString *propertyName = nil;
        NSString *keyPath = [propertyNamesArray objectAtIndex:i];
        
        if([keyPath characterAtIndex:0] == '~')  // A custom property
        {
            [self addPropertyDefinitionWithName:keyPath title:[SCUtilities getUserFriendlyTitleFromName:keyPath] type:SCPropertyTypeCustom];
            
            continue;
        }
        
        NSArray *keyPathArray = [keyPath componentsSeparatedByString:@"."];
        for(int i=0; i<keyPathArray.count; i++)
        {
            propertyName = [keyPathArray objectAtIndex:i];
            NSPropertyDescription *propertyDescription = [[_dynamicentity propertiesByName] valueForKey:propertyName];
            if(!propertyDescription)
            {
                SCDebugLog(@"Warning: Attribute '%@' does not exist in entity '%@'.", propertyName, _dynamicentity.name);
                propertyName = nil;
                break;
            }
            
            if(i<keyPathArray.count-1) // if not last property in keyPath
            {
                if(![propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                    break;
                NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;
                if(![relationship isToMany])
                {
                    _dynamicentity = relationship.destinationEntity;
                }
                else
                {
                    SCDebugLog(@"Invalid: Class definition key path '%@' for entity '%@' has a to-many relationship (%@).", keyPath, _dynamicentity.name, propertyName);
                    propertyName = nil;
                    break;
                }
            }
        }
        
        
        NSString *propertyTitle;
        if(i < propertyTitlesArray.count)
            propertyTitle = [propertyTitlesArray objectAtIndex:i];
        else
            propertyTitle = [SCUtilities getUserFriendlyTitleFromName:propertyName];
        NSPropertyDescription *propertyDescription = [[_dynamicentity propertiesByName] valueForKey:propertyName];
        
        if(propertyDescription)
        {
            SCPropertyDefinition *propertyDef = [SCPropertyDefinition 
                                                 definitionWithName:keyPath
                                                 title:propertyTitle
                                                 type:SCPropertyTypeUndefined];
            propertyDef.required = ![propertyDescription isOptional];
            
            if([propertyDescription isKindOfClass:[NSAttributeDescription class]])
            {
                NSAttributeDescription *attribute = (NSAttributeDescription *)propertyDescription;
                switch ([attribute attributeType]) 
                {
                    case NSInteger16AttributeType:
                    case NSInteger32AttributeType:
                    case NSInteger64AttributeType:
                        propertyDef.dataType = SCDataTypeNSNumber;
                        propertyDef.type = SCPropertyTypeNumericTextField;
                        propertyDef.attributes = [SCNumericTextFieldAttributes 
                                                  attributesWithMinimumValue:nil 
                                                  maximumValue:nil 
                                                  allowFloatValue:FALSE];
                        break;
                        
                    case NSDecimalAttributeType:
                    case NSDoubleAttributeType:
                    case NSFloatAttributeType:
                        propertyDef.dataType = SCDataTypeNSNumber;
                        propertyDef.type = SCPropertyTypeNumericTextField;
                        break;
                        
                    case NSStringAttributeType:
                        propertyDef.dataType = SCDataTypeNSString;
                        propertyDef.type = SCPropertyTypeTextField;
                        break;
                        
                    case NSBooleanAttributeType:
                        propertyDef.dataType = SCDataTypeNSNumber;
                        propertyDef.type = SCPropertyTypeSwitch;
                        break;
                        
                    case NSDateAttributeType:
                        propertyDef.dataType = SCDataTypeNSDate;
                        propertyDef.type = SCPropertyTypeDate;
                        break;
                        
                        
                    default:
                        propertyDef.type = SCPropertyTypeNone;
                        break;
                }
            }
            else
                if([propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                {
                    NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;
                    
                    if([relationship isToMany])
                    {
                        propertyDef.dataType = SCDataTypeNSMutableSet;
                        propertyDef.type = SCPropertyTypeArrayOfObjects;
                    }
                    else
                    {
                        propertyDef.dataType = SCDataTypeNSObject;
                        propertyDef.type = SCPropertyTypeObject;
                    }
                }
                else
                    if([propertyDescription isKindOfClass:[NSFetchedPropertyDescription class]])
                    {
                        propertyDef.dataType = SCDataTypeNSMutableArray;
                        propertyDef.type = SCPropertyTypeArrayOfObjects;
                    }
            
            [self addPropertyDefinition:propertyDef];
        }
    }
}

// overrides superclass
- (NSString *)dataStructureName
{
	return [self.entity name];
}

- (void)setOrderAttributeName:(NSString *)orderAttributeName
{
	if([self isValidPropertyName:orderAttributeName])
	{
		_orderAttributeName = [orderAttributeName copy];
	}
    else
    {
        SCDebugLog(@"Warning: keyPropertyName '%@' is not valid for entity '%@'.", orderAttributeName, self.entity.name);
    }
}

// overrides superclass
- (BOOL)isValidPropertyName:(NSString *)propertyName
{
	BOOL valid = TRUE;
    
    NSArray *keyPathArray = [propertyName componentsSeparatedByString:@"."];
    NSString *_propertyName = nil;
    
    if(self.entity)
    {
        NSEntityDescription *_dynamicentity = self.entity;
        for(int i=0; i<keyPathArray.count; i++)
        {
            _propertyName = [keyPathArray objectAtIndex:i];
            NSPropertyDescription *propertyDescription = [[_dynamicentity propertiesByName] valueForKey:_propertyName];
            if(!propertyDescription)
            {
                valid = FALSE;
                break;
            }
            
            if(i<keyPathArray.count-1) // if not last property in keyPath
            {
                if(![propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                {
                    valid = FALSE;
                    break;
                }
                
                NSRelationshipDescription *relationship = (NSRelationshipDescription *)propertyDescription;
                if(![relationship isToMany])
                {
                    _dynamicentity = relationship.destinationEntity;
                }
                else
                {
                    valid = FALSE;
                    break;
                }
            }
        }
    }
    
    return valid;
}

// overrides superclass
- (SCDataStore *)generateCompatibleDataStore
{
    return [SCCoreDataStore storeWithManagedObjectContext:self.managedObjectContext defaultEntityDefinition:self];
}

// overrides superclass
- (SCDataFetchOptions *)generateCompatibleDataFetchOptions
{
    SCCoreDataFetchOptions *coreDataFetchOptions = [[SCCoreDataFetchOptions alloc] init];
    coreDataFetchOptions.sortKey = self.keyPropertyName;
    coreDataFetchOptions.orderAttributeName = self.orderAttributeName;
    
    return coreDataFetchOptions;
}



#pragma mark -
#pragma mark Linker related

- (void)forceLinker
{
    [SCCoreDataForceLinkerToIncludeCategories forceLinker];
}


@end
