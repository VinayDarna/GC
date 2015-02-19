//
//  ObjectBindingViewController.m
//  Custom Cells App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "ObjectBindingViewController.h"
#import "AppDelegate.h"
#import "CounterTextViewCell.h"
#import "PickerCell.h"


@implementation ObjectBindingViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarType = SCNavigationBarTypeAddLeftEditRight;
	
	// Get managedObjectContext from application delegate
	NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
	
	// Create an entity definition for ContactEntity
	SCEntityDefinition *contactDef = [SCEntityDefinition definitionWithEntityName:@"ContactEntity" managedObjectContext:managedObjectContext propertyNamesString: @"karma;birthDate;notes"];
	contactDef.titlePropertyName = @"firstName;lastName";	// This line is not needed if custom ContactOverviewCell is used
	contactDef.keyPropertyName = @"firstName";
	// Do some property definition customization
	SCPropertyDefinition *birthDatePropertyDef = [contactDef propertyDefinitionWithName:@"birthDate"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, YYYY"];
	birthDatePropertyDef.attributes = [SCDateAttributes attributesWithDateFormatter:dateFormatter
																	 datePickerMode:UIDatePickerModeDate
													  displayDatePickerInDetailView:NO];
	SCPropertyDefinition *notesPropertyDef = [contactDef propertyDefinitionWithName:@"notes"];
	notesPropertyDef.type = SCPropertyTypeTextView;
    notesPropertyDef.uiElementClass = [CounterTextViewCell class];  // STV will use this instead of it's default SCTextViewCell
	// Add a custom property that represents a custom cell defined in ContactDataCell.xib
	NSString *bindingsString = @"1:firstName;2:lastName;3:age;4:sex"; // 1,2,3,4 are the control tags
    
	SCCustomPropertyDefinition *dataProperty = [SCCustomPropertyDefinition definitionWithName:@"Contact Data"
                                                                             uiElementNibName:@"ContactDataCell" 
                                                                         objectBindingsString:bindingsString];
    dataProperty.cellActions.willConfigure = ^(SCTableViewCell *cell, NSIndexPath *indexPath)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    };
	[contactDef insertPropertyDefinition:dataProperty atIndex:0];
    
    SCCustomPropertyDefinition *titleProperty = [SCCustomPropertyDefinition definitionWithName:@"Contact Title" uiElementClass:[PickerCell class] objectBindings:nil];
	[contactDef insertPropertyDefinition:titleProperty atIndex:1];
    
	
	
	// Create and add the objects section
	SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil entityDefinition:contactDef];
	objectsSection.addButtonItem = self.addButton;
    objectsSection.sectionActions.cellForRowAtIndexPath = ^SCCustomCell*(SCArrayOfItemsSection *itemsSection, NSIndexPath *indexPath)
    {
        // Create & return a custom cell based on the cell in ContactOverviewCell.xib
        NSString *bindingsString = @"1:firstName;2:lastName;3:karma"; // 1,2,3 are the control tags
        SCCustomCell *contactOverviewCell = [SCCustomCell cellWithText:nil objectBindingsString:bindingsString nibName:@"ContactOverviewCell"];
        contactOverviewCell.cellActions.customButtonTapped = ^(SCTableViewCell *cell, NSIndexPath *indexPath, UIButton *button)
        {
            // Get the object associated with the cell
            NSManagedObject *managedObject = (NSManagedObject *)cell.boundObject;
            
            NSInteger karma = [(NSNumber *)[managedObject valueForKey:@"karma"] intValue];
            switch (button.tag)
            {
                case 3:
                    // increment karma
                    karma += 1;
                    break;
                case 100:
                    // reset karma
                    karma = 0;
                    break;
            }
            [managedObject setValue:[NSNumber numberWithInt:karma] forKey:@"karma"];
            
            // Update cell with changes
            [cell reloadBoundValue];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return contactOverviewCell;
    };
	[self.tableViewModel addSection:objectsSection];
}


@end

