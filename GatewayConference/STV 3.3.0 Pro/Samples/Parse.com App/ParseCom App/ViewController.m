//
//  ViewController.m
//  ParseCom App
//
//  Copyright (c) 2012 Sensible Cocoa. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationBarType = SCNavigationBarTypeAddRightEditLeft;
    
    // To get your own applicationId & restAPIKey, please visit http://www.parse.com and register there for free.
    
    SCParseComDefinition *taskDef = [SCParseComDefinition definitionWithClassName:@"Task" columnNamesString:@"name;description;category;active" applicationId:@"5lg8lYLmgco0mFnimqXGdb4AK95YVOZabc4YJmHp" restAPIKey:@"MUwEy6QSxay6dkpN0Noo1AKN81lToXiE5sVSAHOy"];
    SCPropertyDefinition *namePDef = [taskDef propertyDefinitionWithName:@"name"];
    namePDef.required = TRUE;
    SCPropertyDefinition *descPDef = [taskDef propertyDefinitionWithName:@"description"];
    descPDef.type = SCPropertyTypeTextView;
    SCPropertyDefinition *categoryPDef = [taskDef propertyDefinitionWithName:@"category"];
    categoryPDef.type = SCPropertyTypeSelection;
    categoryPDef.attributes = [SCSelectionAttributes attributesWithItems:[NSArray arrayWithObjects:@"Home", @"Work", @"Other", nil] allowMultipleSelection:NO allowNoSelection:NO];
    SCPropertyDefinition *activePDef = [taskDef propertyDefinitionWithName:@"active"];
    activePDef.type = SCPropertyTypeSwitch;
    
    SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil webServiceDefinition:taskDef batchSize:0];
    objectsSection.dataFetchOptions.sort = TRUE;
    objectsSection.addButtonItem = self.addButton;
    [self.tableViewModel addSection:objectsSection];
    
    self.tableViewModel.enablePullToRefresh = TRUE;
}


@end
