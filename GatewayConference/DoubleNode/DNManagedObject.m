//
//  DNManagedObject.m
//  Parley
//
//  Created by Darren Ehlers on 5/13/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "DNManagedObject.h"

#import "PARAppDelegate.h"

#import "NSString+HTML.h"

@implementation DNManagedObject

@dynamic nid;

+ (NSString*)entityName
{
    return NSStringFromClass(self);
}

+ (NSString*)getAll_TemplateName
{
    return nil;
}

+ (NSArray*)getAll_SortKeys
{
    return @[ @"display_order" ];
}

+ (NSString*)getFromId_TemplateName
{
    return nil;
}

+ (NSManagedObjectContext*)managedObjectContext
{
    return [[PARAppDelegate appDelegate] managedObjectContext];
}

+ (NSManagedObjectModel*)managedObjectModel
{
    return [[PARAppDelegate appDelegate] managedObjectModel];
}

+ (BOOL)saveContext
{
    return [[PARAppDelegate appDelegate] saveContext];
}

+ (NSArray*)getAll
{
    NSFetchRequest* fetchRequest    = [[[self managedObjectModel] fetchRequestTemplateForName:[self getAll_TemplateName]] copy];
    if (fetchRequest == nil)
    {
        DLog(LL_Debug, @"Unable to get fetchRequest");
        return nil;
    }
    
    //[fetchRequest setFetchLimit:1];
    
    NSMutableArray* sortDescriptors = [NSMutableArray array];
    
    NSArray*    sortKeys = [self getAll_SortKeys];
    [sortKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSString*  sortKey = obj;
         if ((sortKey != nil) && ([sortKey length] > 0))
         {
             [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]];
         }
     }];
    if ([sortDescriptors count] > 0)
    {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSError*    error;
    NSArray*    resultArray = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    if ([resultArray count] == 0)
    {
        return nil;
    }
    
    return resultArray;
}

+ (BOOL)deleteAll
{
    NSArray*    all = [self getAll];
    if ([all count] > 0)
    {
        [all enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             [obj deleteWithNoSave];
         }];
        
        [self saveContext];
    }
    
    return YES;
}

+ (instancetype)getFromId:(NSNumber*)id
{
    NSDictionary*   substDict       = [NSDictionary dictionaryWithObjectsAndKeys:id, @"NID", nil];
    
    NSFetchRequest* fetchRequest    = [[self managedObjectModel] fetchRequestFromTemplateWithName:[self getFromId_TemplateName]
                                                                            substitutionVariables:substDict];
    if (fetchRequest == nil)
    {
        DLog(LL_Debug, @"Unable to get fetchRequest");
        return nil;
    }
    
    [fetchRequest setFetchLimit:1];
    
    NSError*    error;
    NSArray*    resultArray = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    if ([resultArray count] == 0)
    {
        return nil;
    }
    
    return [resultArray objectAtIndex:0];
}

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    return [[self class] dictionaryNumber:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSNumber*)dictionaryNumber:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    NSNumber*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSString*)[NSNull null])
        {
            NSNumber*   newval  = [NSNumber numberWithInt:[object intValue]];

            if ((retval == nil) || ([newval isEqualToNumber:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    
    return retval;
}

+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    return [[self class] dictionaryDouble:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSNumber*)dictionaryDouble:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSNumber*)defaultValue
{
    NSNumber*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSString*)[NSNull null])
        {
            NSNumber*   newval  = [NSNumber numberWithDouble:[object doubleValue]];
            
            if ((retval == nil) || ([newval isEqualToNumber:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    
    return retval;
}

+ (NSString*)dictionaryString:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSString*)defaultValue
{
    return [[self class] dictionaryString:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSString*)dictionaryString:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSString*)defaultValue
{
    NSString*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if ([object isKindOfClass:[NSArray class]] == YES)
        {
            if (object != (NSArray*)[NSNull null])
            {
                if ([object count] > 0)
                {
                    NSString*   newval  = object[0];
                    
                    if ((retval == nil) || ([newval isEqualToString:retval] == NO))
                    {
                        if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                        retval = newval;
                    }
                }
            }
        }
        else
        {
            if ([object isKindOfClass:[NSString class]] == YES)
            {
                if ([object isEqualToString:@"<null>"] == YES)
                {
                    object  = @"";
                }
            }
            if (object != (NSString*)[NSNull null])
            {
                NSString*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToString:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    
    return [retval stringByDecodingXMLEntities];
}

+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSArray*)defaultValue
{
    return [[self class] dictionaryArray:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSArray*)dictionaryArray:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSArray*)defaultValue
{
    NSArray*    retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSArray*)[NSNull null])
        {
            if ([object isKindOfClass:[NSArray class]] == YES)
            {
                NSArray*   newval  = object;
                
                if ((retval == nil) || ([newval isEqualToArray:retval] == NO))
                {
                    if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                    retval = newval;
                }
            }
        }
    }
    
    return retval;
}

+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(NSDate*)defaultValue
{
    return [[self class] dictionaryDate:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (NSDate*)dictionaryDate:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(NSDate*)defaultValue
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate*   retval  = defaultValue;
    
    id  object = [dictionary objectForKey:key];
    if (object != nil)
    {
        if (object != (NSString*)[NSNull null])
        {
            NSDate*   newval  = [dateFormatter dateFromString:object];
            
            if ((retval == nil) || ([newval isEqualToDate:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    
    return retval;
}

+ (id)dictionaryObject:(NSDictionary*)dictionary withItem:(NSString*)key andDefault:(id)defaultValue
{
    return [[self class] dictionaryObject:dictionary dirty:nil withItem:key andDefault:defaultValue];
}

+ (id)dictionaryObject:(NSDictionary*)dictionary dirty:(BOOL*)dirtyFlag withItem:(NSString*)key andDefault:(id)defaultValue
{
    id  retval  = defaultValue;
    
    if ([dictionary objectForKey:key] != nil)
    {
        if (dictionary[key] != (id)[NSNull null])
        {
            id  newval  = dictionary[key];
            
            if ((retval == nil) || ([newval isEqual:retval] == NO))
            {
                if (dirtyFlag != nil)   {   *dirtyFlag = YES;   }
                retval = newval;
            }
        }
    }
    
    return retval;
}

- (instancetype)init
{
    managedObjectContext    = [[self class] managedObjectContext];
    
    NSEntityDescription*    entity = [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:managedObjectContext];
    
    self = [self initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    if (self)
    {
        [self clearData];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    return [self initWithDictionary:dict dirty:nil];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
                             dirty:(BOOL*)dirtyFlag
{
    id  saveSelf    = self;
    id  idValue     = [[self class] dictionaryNumber:dict withItem:@"nid" andDefault:nil];
    
    self = [[self class] getFromId:idValue];
    if (!self)
    {
        self = [saveSelf init];
    }
    if (self)
    {
        self.nid    = [NSNumber numberWithInt:[idValue intValue]];
        
        [self loadWithDictionary:dict dirty:dirtyFlag];
    }
    
    return self;
}

- (void)clearData
{
    self.nid    = @0;
}

- (void)loadWithDictionary:(NSDictionary*)dict
{
    [self loadWithDictionary:dict dirty:nil];
}

- (void)loadWithDictionary:(NSDictionary*)dict
                     dirty:(BOOL*)dirtyFlag
{
}

- (instancetype)save;
{
    [[self class] saveContext];
    return self;
}

- (void)deleteWithNoSave
{
    [[[self class] managedObjectContext] deleteObject:self];
}

- (void)delete
{
    [self deleteWithNoSave];
    [self save];
}

@end
