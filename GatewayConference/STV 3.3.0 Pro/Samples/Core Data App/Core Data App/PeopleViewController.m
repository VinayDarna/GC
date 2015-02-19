//
//  PeopleViewController.m
//  Core Data App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "PeopleViewController.h"
#import "AppDelegate.h"


@implementation PeopleViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarType = SCNavigationBarTypeAddRightEditLeft;
	
	// Get managedObjectContext from application delegate
	NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
	
    
	// Create an entity definition for TaskEntity
	SCEntityDefinition *taskDef = [SCEntityDefinition definitionWithEntityName:@"TaskEntity" managedObjectContext:managedObjectContext propertyNamesString:@"name"];
    
    
	// Create an entity definition for PersonEntity with group definitions in the names string
	SCEntityDefinition *personDef = [SCEntityDefinition definitionWithEntityName:@"PersonEntity" managedObjectContext:managedObjectContext propertyNamesString:@":(firstName,lastName,company);Contact Details:(mobile,home,address);Tasks To-do:(tasks)"];
    personDef.titlePropertyName = @"firstName;lastName";
    //Customize property definitions
    SCPropertyDefinition *addressPropertyDef = [personDef propertyDefinitionWithName:@"address"];
    addressPropertyDef.type = SCPropertyTypeTextView;
	SCPropertyDefinition *tasksPropertyDef = [personDef propertyDefinitionWithName:@"tasks"];
    tasksPropertyDef.existsInCreationMode = FALSE;
    SCArrayOfObjectsAttributes *tasksAttributes = [SCArrayOfObjectsAttributes attributesWithObjectDefinition:taskDef
                                                                                                 allowAddingItems:NO
                                                                                               allowDeletingItems:NO
                                                                                                 allowMovingItems:NO
                                                                                       expandContentInCurrentView:YES
                                                                                             placeholderuiElement:[SCTableViewCell cellWithText:@"(no tasks)"] 
                                                                                            addNewObjectuiElement:nil 
                                                                          addNewObjectuiElementExistsInNormalMode:FALSE
                                                                         addNewObjectuiElementExistsInEditingMode:FALSE];
    tasksAttributes.allowEditingItems = NO;
	tasksPropertyDef.attributes = tasksAttributes;
	
	
	
	
	SCArrayOfObjectsModel *objectsModel = [[SCArrayOfObjectsModel alloc] initWithTableView:self.tableView entityDefinition:personDef];
	objectsModel.searchPropertyName = @"firstName;lastName";
	objectsModel.addButtonItem = self.addButton;
    objectsModel.editButtonItem = self.editButton;
	objectsModel.autoSortSections = TRUE;
    // Implementing this action will automatically generate sections based on the first character on the person's firstName
    objectsModel.modelActions.sectionHeaderTitleForItem = ^NSString*(SCArrayOfItemsModel *itemsModel, NSObject *item, NSUInteger itemIndex)
    {
        // Cast not technically neccessary, done just for clarity
        NSManagedObject *managedObject = (NSManagedObject *)item;
        
        NSString *objectName = [managedObject valueForKey:@"firstName"];
        
        // Return first charcter of objectName
        return [[objectName substringToIndex:1] uppercaseString];
    };
	objectsModel.sectionIndexTitles = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
	
    // Replace the default model with the new objectsModel
    self.tableViewModel = objectsModel;
}


@end

