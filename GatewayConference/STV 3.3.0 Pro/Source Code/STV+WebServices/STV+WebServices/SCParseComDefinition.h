/*
 *  SCParseComDefinition.h
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


#import "SCWebServiceDefinition.h"


/****************************************************************************************/
/*	class SCParseComDefinition	*/
/****************************************************************************************/ 
/**	
 This class functions as a means to further extend the definition of http://parse.com classes.
 
 Sample use:
    // Extend the parse.com Task class definition
    SCParseComDefinition *taskDef = [SCParseComDefinition definitionWithClassName:@"Task" 
        columnNamesString:@"name;description;category;active" applicationId:@"5lg8lYLmgco0mFnimqXGdb4AK95YVOZabc4YJmHp" 
        restAPIKey:@"MUwEy6QSxay6dkpN0Noo1AKN81lToXiE5sVSAHOy"];
    SCPropertyDefinition *descPDef = [taskDef propertyDefinitionWithName:@"description"];
    descPDef.type = SCPropertyTypeTextView;
    SCPropertyDefinition *categoryPDef = [taskDef propertyDefinitionWithName:@"category"];
    categoryPDef.type = SCPropertyTypeSelection;
    categoryPDef.attributes = [SCSelectionAttributes attributesWithItems:[NSArray arrayWithObjects:@"Home", @"Work", @"Other", nil] 
        allowMultipleSelection:NO allowNoSelection:NO];
    SCPropertyDefinition *activePDef = [taskDef propertyDefinitionWithName:@"active"];
    activePDef.type = SCPropertyTypeSwitch;
 
    // Create a section of all the parse.com task classes
    SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil 
        webServiceDefinition:taskDef batchSize:0];
    objectsSection.dataFetchOptions.sort = TRUE;
    [self.tableViewModel addSection:objectsSection];
 
 @see SCPropertyDefinition.
 */
@interface SCParseComDefinition : SCWebServiceDefinition
{
    NSString *_className;
    NSString *_applicationId;
    NSString *_restAPIKey;
}


//////////////////////////////////////////////////////////////////////////////////////////
/// @name Creation and Initialization
//////////////////////////////////////////////////////////////////////////////////////////

/** Allocates and returns an initialized SCParseComDefinition. 
 @param className The parse.com class name.
 @param columnNames The column names of the class separated by semi-colons.
 @param applicationId The parse.com application id.
 @param restAPIKey The parse.com rest API key.
 */
+ (id)definitionWithClassName:(NSString *)className columnNamesString:(NSString *)columnNames applicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey;

/** Returns an initialized SCParseComDefinition. 
 @param className The parse.com class name.
 @param columnNames The column names of the class separated by semi-colons.
 @param applicationId The parse.com application id.
 @param restAPIKey The parse.com rest API key.
 */
- (id)initWithClassName:(NSString *)className columnNamesString:(NSString *)columnNames applicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey;


//////////////////////////////////////////////////////////////////////////////////////////
/// @name Configuration
//////////////////////////////////////////////////////////////////////////////////////////

/** The parse.com class name. */
@property (nonatomic, copy) NSString *className;

/** The parse.com application id. */
@property (nonatomic, copy) NSString *applicationId;

/** The parse.com rest API key. */
@property (nonatomic, copy) NSString *restAPIKey;

@end
