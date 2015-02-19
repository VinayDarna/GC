//
//  TasksViewController.m
//  Core Data App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "TasksViewController.h"
#import "AppDelegate.h"


@implementation TasksViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarType = SCNavigationBarTypeAddRightEditLeft;
	
	// Get managedObjectContext from application delegate
	NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
	
    // Create an entity definition for CategoryEntity
    SCEntityDefinition *categoryDef = [SCEntityDefinition definitionWithEntityName:@"CategoryEntity" managedObjectContext:managedObjectContext propertyNamesString:@"title"];
    categoryDef.orderAttributeName = @"order";
    
	// Create an entity definition for PersonEntity
	SCEntityDefinition *personDef = [SCEntityDefinition definitionWithEntityName:@"PersonEntity" managedObjectContext:managedObjectContext propertyNamesString:@"firstName;lastName"];
	
	// Create an entity definition for TaskStepEntity
	SCEntityDefinition *taskStepDef = [SCEntityDefinition definitionWithEntityName:@"TaskStepEntity" managedObjectContext:managedObjectContext propertyNamesString:@"name;desc"];
    taskStepDef.requireEditingModeToEditPropertyValues = TRUE; // lock all property values until put in editing mode
	taskStepDef.orderAttributeName = @"order";
	// Do some property definition customization
	SCPropertyDefinition *tsdescPropertyDef = [taskStepDef propertyDefinitionWithName:@"desc"];
	tsdescPropertyDef.title = @"Description";
	tsdescPropertyDef.type = SCPropertyTypeTextView;
	
	
	// Create an entity definition for TaskEntity with groups defined in the property names string
	SCEntityDefinition *taskDef = [SCEntityDefinition definitionWithEntityName:@"TaskEntity" managedObjectContext:managedObjectContext propertyNamesString:@"Task Details:(name,desc,dueDate,active,priority,category,assignedTo);Task Steps:(taskSteps)"];
    taskDef.requireEditingModeToEditPropertyValues = TRUE; // lock all property values until put in editing mode
	taskDef.orderAttributeName = @"order";
    // Do some property definition customization
	SCPropertyDefinition *descPropertyDef = [taskDef propertyDefinitionWithName:@"desc"];
	descPropertyDef.title = @"Description";
	descPropertyDef.type = SCPropertyTypeTextView;
	SCPropertyDefinition *priorityPropertyDef = [taskDef propertyDefinitionWithName:@"priority"];
	priorityPropertyDef.type = SCPropertyTypeSegmented;
	priorityPropertyDef.attributes = [SCSegmentedAttributes 
									  attributesWithSegmentTitlesArray:[NSArray arrayWithObjects:@"Low", @"Medium", @"High", nil]];
	SCPropertyDefinition *categoryPropertyDef = [taskDef propertyDefinitionWithName:@"category"];
	categoryPropertyDef.type = SCPropertyTypeObjectSelection;
	SCObjectSelectionAttributes *selectionAttribs = [SCObjectSelectionAttributes attributesWithObjectsEntityDefinition:categoryDef usingPredicate:nil allowMultipleSelection:NO allowNoSelection:NO];
    selectionAttribs.allowAddingItems = YES;
    selectionAttribs.allowDeletingItems = YES;
    selectionAttribs.allowMovingItems = YES;
    selectionAttribs.allowEditingItems = YES;
    selectionAttribs.placeholderuiElement = [SCTableViewCell cellWithText:@"(no categories defined)" textAlignment:NSTextAlignmentCenter];
    selectionAttribs.addNewObjectuiElement = [SCTableViewCell cellWithText:@"Add new category"];
    categoryPropertyDef.attributes = selectionAttribs;
	SCPropertyDefinition *assignedToPropertyDef = [taskDef propertyDefinitionWithName:@"assignedTo"];
	assignedToPropertyDef.type = SCPropertyTypeObjectSelection;
	assignedToPropertyDef.attributes = [SCObjectSelectionAttributes attributesWithObjectsEntityDefinition:personDef usingPredicate:nil allowMultipleSelection:NO allowNoSelection:NO];
	SCPropertyDefinition *taskStepsPropertyDef = [taskDef propertyDefinitionWithName:@"taskSteps"];
	taskStepsPropertyDef.attributes = 
    [SCArrayOfObjectsAttributes attributesWithObjectDefinition:taskStepDef
                                              allowAddingItems:YES
                                            allowDeletingItems:YES
                                              allowMovingItems:YES
                                    expandContentInCurrentView:YES 
                                          placeholderuiElement:[SCTableViewCell cellWithText:@"(no steps defined)" textAlignment:NSTextAlignmentCenter]
                                         addNewObjectuiElement:[SCTableViewCell cellWithText:@"Add step"] 
                                addNewObjectuiElementExistsInNormalMode:NO addNewObjectuiElementExistsInEditingMode:YES];
	
	// Create and add the objects section
	SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil entityDefinition:taskDef];
    objectsSection.placeholderCell = [SCTableViewCell cellWithText:@"No tasks added yet" textAlignment:NSTextAlignmentCenter];
	objectsSection.addButtonItem = self.addButton;
	[self.tableViewModel addSection:objectsSection];
}



@end
