//
//  RootViewController.m
//  Custom View App
//
//  Copyright 2013 Sensible Cocoa. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarType = SCNavigationBarTypeAddLeftEditRight;
    
    SCDictionaryDefinition *taskDef = [SCDictionaryDefinition definitionWithDictionaryKeyNamesString:@"name;description"];
    [taskDef propertyDefinitionWithName:@"description"].type = SCPropertyTypeTextView;
    
    NSMutableDictionary *task1 = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"Editable Task"}];
    NSMutableDictionary *task2 = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"Non-editable Task"}];
    NSMutableArray *tasksArray = [NSMutableArray arrayWithArray:@[task1, task2]];
    
    SCArrayOfObjectsSection *tasksSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil items:tasksArray itemsDefinition:taskDef];
    tasksSection.addButtonItem = self.addButton;
	tasksSection.allowDeletingItems = FALSE;
	[self.tableViewModel addSection:tasksSection];
    
    tasksSection.cellActions.didSelect = ^(SCTableViewCell *cell, NSIndexPath *indexPath)
    {
        switch (indexPath.row) 
        {
            case 0:
            {
                // let STV handle this
                SCArrayOfObjectsSection *ownerSection = (SCArrayOfObjectsSection *)cell.ownerSection;
                [ownerSection dispatchEventSelectRowAtIndexPath:indexPath];
            }
                break;
            case 1:
            {
                // we'll handle this ourselves by displaying the non-editable view controller
                SCViewController *nonEditableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NoneditableViewController"];
                [self.navigationController pushViewController:nonEditableVC animated:YES];
            }
                break;
        }
    };
    
    // Let STV know about our custom editable view controller
    tasksSection.sectionActions.detailViewControllerForRowAtIndexPath = ^UIViewController*(SCTableViewSection *section, NSIndexPath *indexPath)
    {
        if(indexPath.row == NSNotFound)  // if new task
            return nil;  // use STV's default detail view controller
        //else
        SCViewController *editableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditableViewController"];
        
        return editableVC;
    };
}


@end

