//
//  DNManagedObject.h
//  Parley
//
//  Created by Darren Ehlers on 5/13/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "NSString+HTML.h"

@interface DNManagedObject : NSManagedObject <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController* fetchedResultsController;
    NSManagedObjectContext*     managedObjectContext;
}

@property (nonatomic, retain) NSNumber * nid;

+ (NSString*)entityName;
+ (NSString*)getAll_TemplateName;
+ (NSString*)getFromId_TemplateName;

+ (NSManagedObjectContext*)managedObjectContext;
+ (NSManagedObjectModel*)managedObjectModel;

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSString*)dictionaryString:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSString*)defaultValue;
+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSArray*)defaultValue;
+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDate*)defaultValue;
+ (id)dictionaryObject:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(id)defaultValue;

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue;
+ (NSString*)dictionaryString:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSString*)defaultValue;
+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSArray*)defaultValue;
+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDate*)defaultValue;
+ (id)dictionaryObject:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(id)defaultValue;

+ (BOOL)saveContext;
+ (NSArray*)getAll;
+ (BOOL)deleteAll;

+ (instancetype)getFromId:(NSNumber*)id;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithDictionary:(NSDictionary*)dict dirty:(BOOL*)dirtyFlag;

- (void)clearData;
- (void)loadWithDictionary:(NSDictionary*)dict;
- (void)loadWithDictionary:(NSDictionary*)dict dirty:(BOOL*)dirtyFlag;

- (instancetype)save;
- (void)deleteWithNoSave;
- (void)delete;

@end
