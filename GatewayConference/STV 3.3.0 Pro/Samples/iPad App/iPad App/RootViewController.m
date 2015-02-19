//
//  RootViewController.m
//  iPad App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarType = SCNavigationBarTypeAddRightEditLeft;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
    NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
	// Create an entity definition for TaskStepEntity
	SCEntityDefinition *taskStepDef = [SCEntityDefinition definitionWithEntityName:@"TaskStepEntity" managedObjectContext:managedObjectContext propertyNamesString:@"name;desc"];
	// Do some property definition customization
	SCPropertyDefinition *tsdescPropertyDef = [taskStepDef propertyDefinitionWithName:@"desc"];
	tsdescPropertyDef.title = @"Description";
	tsdescPropertyDef.type = SCPropertyTypeTextView;
	
	
	// Create an entity definition for TaskEntity
	SCEntityDefinition *taskDef = [SCEntityDefinition definitionWithEntityName:@"TaskEntity" managedObjectContext:managedObjectContext propertyNamesString: @"name;desc;dueDate;active;priority;category;taskSteps"];
	// Do some property definition customization
	SCPropertyDefinition *descPropertyDef = [taskDef propertyDefinitionWithName:@"desc"];
	descPropertyDef.title = @"Description";
	descPropertyDef.type = SCPropertyTypeTextView;
	SCPropertyDefinition *priorityPropertyDef = [taskDef propertyDefinitionWithName:@"priority"];
	priorityPropertyDef.type = SCPropertyTypeSegmented;
	priorityPropertyDef.attributes = [SCSegmentedAttributes 
									  attributesWithSegmentTitlesArray:[NSArray arrayWithObjects:@"Low", @"Medium", @"High", nil]];
	SCPropertyDefinition *categoryPropertyDef = [taskDef propertyDefinitionWithName:@"category"];
	categoryPropertyDef.type = SCPropertyTypeSelection;
	categoryPropertyDef.attributes = [SCSelectionAttributes attributesWithItems:[NSArray arrayWithObjects:@"Home", @"Work", @"Other", nil]
														 allowMultipleSelection:NO
															   allowNoSelection:NO];
	SCPropertyDefinition *taskStepsPropertyDef = [taskDef propertyDefinitionWithName:@"taskSteps"];
	taskStepsPropertyDef.attributes = [SCArrayOfObjectsAttributes attributesWithObjectDefinition:taskStepDef
																					 allowAddingItems:TRUE
																				   allowDeletingItems:TRUE
																					 allowMovingItems:FALSE];
	
	// Create and add the objects section
	SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil entityDefinition:taskDef];
    objectsSection.addButtonItem = self.addButton;
	objectsSection.itemsAccessoryType = UITableViewCellAccessoryNone;
    objectsSection.detailViewControllerOptions.navigationBarType = SCNavigationBarTypeNone;
    objectsSection.detailViewControllerOptions.modalPresentationStyle = UIModalPresentationPageSheet;
	[self.tableViewModel addSection:objectsSection];
}


@end
