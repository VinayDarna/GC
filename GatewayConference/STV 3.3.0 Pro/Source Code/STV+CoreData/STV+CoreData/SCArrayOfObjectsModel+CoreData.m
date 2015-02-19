/*
 *  SCArrayOfObjectsModel+CoreData.m
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


#import "SCArrayOfObjectsModel+CoreData.h"

#import "SCCoreDataStore.h"


@implementation SCArrayOfObjectsModel (CoreData)

+ (id)modelWithTableView:(UITableView *)tableView entityDefinition:(SCEntityDefinition *)definition
{
    return [[[self class] alloc] initWithTableView:tableView entityDefinition:definition];
}

+ (id)modelWithTableView:(UITableView *)tableView entityDefinition:(SCEntityDefinition *)definition filterPredicate:(NSPredicate *)predicate
{
    return [[[self class] alloc] initWithTableView:tableView entityDefinition:definition filterPredicate:predicate];
}


- (id)initWithTableView:(UITableView *)tableView entityDefinition:(SCEntityDefinition *)definition
{
    return [self initWithTableView:tableView entityDefinition:definition filterPredicate:nil];
}

- (id)initWithTableView:(UITableView *)tableView entityDefinition:(SCEntityDefinition *)definition filterPredicate:(NSPredicate *)predicate
{
    SCCoreDataStore *store = [SCCoreDataStore storeWithManagedObjectContext:definition.managedObjectContext defaultEntityDefinition:definition];
    
    self = [self initWithTableView:tableView dataStore:store];
    if(self)
    {
        if(predicate)
        {
            self.dataFetchOptions.filter = TRUE;
            self.dataFetchOptions.filterPredicate = predicate;
        }
    }
    
    return self;
}

@end
