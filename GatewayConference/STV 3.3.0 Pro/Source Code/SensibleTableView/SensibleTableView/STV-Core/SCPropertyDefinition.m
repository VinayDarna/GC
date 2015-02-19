/*
 *  SCPropertyDefinition.m
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

#import "SCPropertyDefinition.h"

@implementation SCPropertyDefinition

@synthesize ownerDataStuctureDefinition;
@synthesize dataType;
@synthesize dataReadOnly;
@synthesize name;
@synthesize title;
@synthesize type;
@synthesize attributes;
@synthesize editingModeType;
@synthesize editingModeAttributes;
@synthesize required;
@synthesize autoValidate;
@synthesize existsInNormalMode;
@synthesize existsInEditingMode;
@synthesize existsInCreationMode;
@synthesize existsInDetailMode;
@synthesize uiElementClass;
@synthesize uiElementNibName;
@synthesize objectBindings;
@synthesize cellActions = _cellActions;


+ (id)definitionWithName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithName:propertyName];
}

+ (id)definitionWithName:(NSString *)propertyName 
				   title:(NSString *)propertyTitle
					type:(SCPropertyType)propertyType
{
	return [[[self class] alloc] initWithName:propertyName title:propertyTitle type:propertyType];
}

- (id)initWithName:(NSString *)propertyName
{
	return [self initWithName:propertyName title:nil type:SCPropertyTypeAutoDetect];
}

- (id)initWithName:(NSString *)propertyName 
			 title:(NSString *)propertyTitle
			  type:(SCPropertyType)propertyType
{
	if( (self=[super init]) )
	{
		ownerDataStuctureDefinition = nil;
		
		dataType = SCDataTypeUnknown;
		dataReadOnly = FALSE;
		
		name = [propertyName copy];
		self.title = propertyTitle;
		self.type = propertyType;
		self.attributes = nil;
		self.editingModeType = SCPropertyTypeUndefined;
		self.editingModeAttributes = nil;
		self.required = FALSE;
		self.autoValidate = TRUE;
        self.existsInNormalMode = TRUE;
        self.existsInEditingMode = TRUE;
        self.existsInCreationMode = TRUE;
        self.existsInDetailMode = TRUE;
        
        uiElementClass = nil;
        uiElementNibName = nil;
        objectBindings = nil;
        
        _cellActions = [[SCCellActions alloc] init];
	}
	return self;
}


- (NSString *)objectBindingsString
{
    return [SCUtilities bindingsStringForBindingsDictionary:self.objectBindings];
}

- (void)setObjectBindingsString:(NSString *)objectBindingsString
{
    self.objectBindings = [SCUtilities bindingsDictionaryForBindingsString:objectBindingsString];
}

- (BOOL)dataTypeScalar
{
    if(self.dataType==SCDataTypeBOOL || self.dataType==SCDataTypeDouble || self.dataType==SCDataTypeFloat || self.dataType==SCDataTypeInt)
        return TRUE;
    //else
    return FALSE;
}

@end






@implementation SCCustomPropertyDefinition



+ (id)definitionWithName:(NSString *)propertyName 
          uiElementClass:(Class)elementClass
          objectBindings:(NSDictionary *)bindings
{
	return [[[self class] alloc] initWithName:propertyName uiElementClass:elementClass objectBindings:bindings];
}

+ (id)definitionWithName:(NSString *)propertyName 
          uiElementClass:(Class)elementClass
    objectBindingsString:(NSString *)bindingsString
{
	return [[[self class] alloc] initWithName:propertyName uiElementClass:elementClass objectBindingsString:bindingsString];
}

+ (id)definitionWithName:(NSString *)propertyName 
        uiElementNibName:(NSString *)elementNibName
          objectBindings:(NSDictionary *)bindings
{
	return [[[self class] alloc] initWithName:propertyName uiElementNibName:elementNibName objectBindings:bindings];
}

+ (id)definitionWithName:(NSString *)propertyName 
        uiElementNibName:(NSString *)elementNibName
    objectBindingsString:(NSString *)bindingsString
{
	return [[[self class] alloc] initWithName:propertyName uiElementNibName:elementNibName objectBindingsString:bindingsString];
}

//overrides superclass
- (id)initWithName:(NSString *)propertyName
{
    if( (self = [super initWithName:propertyName]) )
    {
        type = SCPropertyTypeCustom;
    }
    
    return self;
}

- (id)initWithName:(NSString *)propertyName uiElementClass:(Class)elementClass objectBindings:(NSDictionary *)bindings
{
	if( (self = [self initWithName:propertyName]) )
	{
		self.uiElementClass = elementClass;
		self.objectBindings = bindings;
	}
	
	return self;
}

- (id)initWithName:(NSString *)propertyName uiElementClass:(Class)elementClass objectBindingsString:(NSString *)bindingsString
{
    NSDictionary *bindings = [SCUtilities bindingsDictionaryForBindingsString:bindingsString];
    
    return [self initWithName:propertyName uiElementClass:elementClass objectBindings:bindings];
}

- (id)initWithName:(NSString *)propertyName uiElementNibName:(NSString *)elementNibName objectBindings:(NSDictionary *)bindings
{
	if( (self = [self initWithName:propertyName]) )
	{
		self.uiElementNibName = elementNibName;
		self.objectBindings = bindings;
	}
	
	return self;
}

- (id)initWithName:(NSString *)propertyName uiElementNibName:(NSString *)elementNibName objectBindingsString:(NSString *)bindingsString
{
    NSDictionary *bindings = [SCUtilities bindingsDictionaryForBindingsString:bindingsString];
    
    return [self initWithName:propertyName uiElementNibName:elementNibName objectBindings:bindings];
}

@end







@implementation SCPropertyGroup

@synthesize headerTitle;
@synthesize footerTitle;


+ (id)groupWithHeaderTitle:(NSString *)groupHeaderTitle footerTitle:(NSString *)groupFooterTitle
         propertyNames:(NSArray *)propertyNames
{
    return [[[self class] alloc] initWithHeaderTitle:groupHeaderTitle footerTitle:groupFooterTitle propertyNames:propertyNames];
}

- (id)init
{
	if( (self=[super init]) )
	{
		headerTitle = nil;
        footerTitle = nil;
        propertyDefinitionNames = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithHeaderTitle:(NSString *)groupHeaderTitle footerTitle:(NSString *)groupFooterTitle
        propertyNames:(NSArray *)propertyNames
{
    if( (self=[self init]) )
	{
		self.headerTitle = groupHeaderTitle;
        self.footerTitle = groupFooterTitle;
        [propertyDefinitionNames addObjectsFromArray:propertyNames];
	}
	return self;
}

- (NSInteger)propertyNameCount
{
    return [propertyDefinitionNames count];
}

- (void)addPropertyName:(NSString *)propertyName
{
    [propertyDefinitionNames addObject:propertyName];
}

- (void)insertPropertyName:(NSString *)propertyName atIndex:(NSInteger)index
{
    [propertyDefinitionNames insertObject:propertyName atIndex:index];
}

- (NSString *)propertyNameAtIndex:(NSInteger)index
{
    return [propertyDefinitionNames objectAtIndex:index];
}

- (void)removePropertyNameAtIndex:(NSInteger)index
{
    [propertyDefinitionNames removeObjectAtIndex:index];
}

- (void)removeAllPropertyNames
{
    [propertyDefinitionNames removeAllObjects];
}

- (BOOL)containsPropertyName:(NSString *)propertyName
{
    return [propertyDefinitionNames containsObject:propertyName];
}


@end




@implementation SCPropertyGroupArray

+ (id)groupArray
{
	return [[[self class] alloc] init];
}

- (id)init
{
	if( (self=[super init]) )
	{
		propertyGroups = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSInteger)groupCount
{
    return [propertyGroups count];
}

- (void)addGroup:(SCPropertyGroup *)group
{
    [propertyGroups addObject:group];
}

- (void)insertGroup:(SCPropertyGroup *)group atIndex:(NSInteger)index
{
    [propertyGroups insertObject:group atIndex:index];
}

- (SCPropertyGroup *)groupAtIndex:(NSInteger)index
{
    return [propertyGroups objectAtIndex:index];
}

- (SCPropertyGroup *)groupByHeaderTitle:(NSString *)headerTitle
{
    for(SCPropertyGroup *group in propertyGroups)
    {
        if([group.headerTitle isEqualToString:headerTitle])
            return group;
    }
    return nil;
}

- (void)removeGroupAtIndex:(NSInteger)index
{
    [propertyGroups removeObjectAtIndex:index];
}

- (void)removeAllGroups
{
    [propertyGroups removeAllObjects];
}

@end


