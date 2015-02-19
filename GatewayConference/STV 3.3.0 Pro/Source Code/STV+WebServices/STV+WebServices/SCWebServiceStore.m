/*
 *  SCWebServiceStore.m
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


#import "SCWebServiceStore.h"

#import <SensibleTableView/SCDataStore.h>

#import "AFNetworking.h"
#import "CJSONSerializer.h"
#import "SCWebServiceFetchOptions.h"
#import "SCWebServiceDefinition.h"

#import "SCWebServicesForceLinkerToIncludeCategories.h"
#import "SCWebServicesForceLinkerToIncludeCategoriesNonARC.h"






@interface SCJSONSerializer : CJSONSerializer

- (NSData *)serializeDate:(NSDate *)inDate error:(NSError **)outError;

@end


@implementation SCJSONSerializer

- (NSData *)serializeDate:(NSDate *)inDate error:(NSError **)outError
{
    if(!inDate)
        return NULL;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];  // ISO 8601 format
    NSString *dateString = [dateFormatter stringFromDate:inDate];
    
    return [self serializeString:dateString error:outError];
}

// overrides superclass
- (BOOL)isValidJSONObject:(id)inObject
{
    if([inObject isKindOfClass:[NSDate class]])
        return TRUE;
    //else
    return [super isValidJSONObject:inObject];
}

// overrides superclass
- (NSData *)serializeObject:(id)inObject error:(NSError **)outError
{
    if([inObject isKindOfClass:[NSDate class]])
        return [self serializeDate:inObject error:outError];
    //else
    return [super serializeObject:inObject error:outError];
}

@end







@interface AFHTTPClient (WebServices)

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters data:(NSData *)data success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)putPath:(NSString *)path parameters:(NSDictionary *)parameters data:(NSData *)data success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation AFHTTPClient (WebServices)

- (void)postPath:(NSString *)path 
      parameters:(NSDictionary *)parameters 
            data:(NSData *)data
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if(!parameters.count)
        parameters = nil;
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    if(!parameters)
        [request setHTTPBody:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)putPath:(NSString *)path 
     parameters:(NSDictionary *)parameters 
           data:(NSData *)data
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    if(!parameters.count)
        parameters = nil;
    
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    if(!parameters)
        [request setHTTPBody:data];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

@end








@interface SCWebServiceStore ()
{
    AFHTTPClient *_webServiceClient;
}

@property (nonatomic, readonly) SCWebServiceDefinition *defaultWebServiceDefinition;
@property (nonatomic, strong) AFHTTPClient *webServiceClient;

@end



@implementation SCWebServiceStore

@synthesize webServiceClient = _webServiceClient;

+ (id)storeWithDefaultWebServiceDefinition:(SCWebServiceDefinition *)definition
{
    return [[[self class] alloc] initWithDefaultWebServiceDefinition:definition];
}


- (id)init
{
	if( (self = [super init]) )
	{
        _webServiceClient = nil;
        
        self.storeMode = SCStoreModeAsynchronous;
	}
	return self;
}

- (id)initWithDefaultWebServiceDefinition:(SCWebServiceDefinition *)definition
{
    if( (self=[self initWithDefaultDataDefinition:definition]) )
    {
        // further initialization here
    }
    return self;
}



- (SCWebServiceDefinition *)defaultWebServiceDefinition
{
    SCWebServiceDefinition *definition = nil;
    if([self.defaultDataDefinition isKindOfClass:[SCWebServiceDefinition class]])
        definition = (SCWebServiceDefinition *)self.defaultDataDefinition;
    
    return definition;
}

- (void)setDefaultDataDefinition:(SCDataDefinition *)definition
{
    [super setDefaultDataDefinition:definition];
    
    if(self.defaultWebServiceDefinition)
    {
        self.webServiceClient = [[AFHTTPClient alloc] initWithBaseURL:self.defaultWebServiceDefinition.baseURL];
        
        [self.webServiceClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self.webServiceClient setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSDictionary *headersDictionary = self.defaultWebServiceDefinition.httpHeaders;
        NSArray *headersArray = [headersDictionary allKeys];
        for(NSString *header in headersArray)
        {
            [self.webServiceClient setDefaultHeader:header value:[headersDictionary valueForKey:header]];
        }
    }
    else 
    {
        self.webServiceClient = nil;
    }
}

// overrides superclass
- (NSObject *)createNewObjectWithDefinition:(SCDataDefinition *)definition
{
    [self addDataDefinition:definition];
    
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    [_uninsertedObjects addObject:object];
    
    return object;
}

// overrides superclass
- (BOOL)discardUninsertedObject:(NSObject *)object
{
    [_uninsertedObjects removeObjectIdenticalTo:object];
    
    return TRUE;
}

- (BOOL)validateOrderChangeForObject:(NSObject *)object
{
    return FALSE; 
}

// overrides superclass
- (void)asynchronousInsertObject:(NSObject *)object success:(SCDataStoreInsertSuccess_Block)success_block failure:(SCDataStoreFailure_Block)failure_block
{
    if(!self.defaultWebServiceDefinition.insertObjectAPI)
    {
        if(failure_block)
            failure_block(nil);
        SCDebugLog(@"Warning: No valid insertObjectAPI specified in SCWebServiceDefinition.");
        
        return;
    }
    
    NSError *serializeError = nil;
    NSData *objectData = [[SCJSONSerializer serializer] serializeDictionary:(NSDictionary *)object error:&serializeError];
    if(serializeError)
    {
        if(failure_block)
            failure_block(serializeError);
        SCDebugLog(@"Serialization error: %@.", serializeError);
        
        return;
    }
    [self.webServiceClient postPath:self.defaultWebServiceDefinition.insertObjectAPI parameters:self.defaultWebServiceDefinition.insertObjectParameters data:objectData
    success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [_uninsertedObjects removeObjectIdenticalTo:object];
         
         if([responseObject isKindOfClass:[NSDictionary class]] && self.defaultWebServiceDefinition.objectIdKeyName)
         {
             NSString *objectId = [responseObject valueForKey:self.defaultWebServiceDefinition.objectIdKeyName];
             [object setValue:objectId forKey:self.defaultWebServiceDefinition.objectIdKeyName];
         }
         
         if(success_block)
             success_block();
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SCDebugLog(@"Web Service Error: %@", error);
         if(failure_block)
             failure_block(error);
     }];
}

// overrides superclass
- (void)asynchronousUpdateObject:(NSObject *)object success:(SCDataStoreUpdateSuccess_Block)success_block failure:(SCDataStoreFailure_Block)failure_block
{
    if(!self.defaultWebServiceDefinition.updateObjectAPI)
    {
        if(failure_block)
            failure_block(nil);
        SCDebugLog(@"Warning: No valid updateObjectAPI specified in SCWebServiceDefinition.");
        
        return;
    }
    
    NSString *objectId = [object valueForKey:self.defaultWebServiceDefinition.objectIdKeyName];
    if(!objectId)
    {
        if(failure_block)
        {
            SCDebugLog(@"Object update failed - no value for objectIdKeyName: %@", self.defaultWebServiceDefinition.objectIdKeyName);
            if(failure_block)
                failure_block(nil);
            
            return;
        }
    }
    
    NSMutableDictionary *objectDictionary = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
    NSArray *readOnlyKeys = [self.defaultWebServiceDefinition.readOnlyKeyNames componentsSeparatedByString:@";"];
    for(NSString *readOnlyKey in readOnlyKeys)
        [objectDictionary setValue:nil forKey:readOnlyKey];
    NSData *objectData = [[SCJSONSerializer serializer] serializeDictionary:objectDictionary error:nil];
    NSString *path = [NSString stringWithFormat:@"%@/%@", self.defaultWebServiceDefinition.updateObjectAPI, objectId];
    
    [self.webServiceClient putPath:path parameters:self.defaultWebServiceDefinition.updateObjectParameters data:objectData success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success_block)
             success_block();
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SCDebugLog(@"Web Service Error: %@", error);
         if(failure_block)
             failure_block(error);
     }];
}

// overrides superclass
- (void)asynchronousDeleteObject:(NSObject *)object success:(SCDataStoreDeleteSuccess_Block)success_block failure:(SCDataStoreFailure_Block)failure_block
{
    if(!self.defaultWebServiceDefinition.deleteObjectAPI)
    {
        if(failure_block)
            failure_block(nil);
        SCDebugLog(@"Warning: No valid deleteObjectAPI specified in SCWebServiceDefinition.");
        
        return;
    }
    
    NSString *objectId = [object valueForKey:self.defaultWebServiceDefinition.objectIdKeyName];
    if(!objectId)
    {
        if(failure_block)
        {
            SCDebugLog(@"Object delete failed - no value for objectIdKeyName: %@", self.defaultWebServiceDefinition.objectIdKeyName);
            if(failure_block)
                failure_block(nil);
            
            return;
        }
    }
    
    NSString *path;
    if([objectId length])
        path = [NSString stringWithFormat:@"%@/%@", self.defaultWebServiceDefinition.deleteObjectAPI, objectId];
    else
        path = self.defaultWebServiceDefinition.deleteObjectAPI;
    
    [self.webServiceClient deletePath:path parameters:self.defaultWebServiceDefinition.deleteObjectParameters
        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success_block)
             success_block();
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SCDebugLog(@"Web Service Error: %@", error);
         if(failure_block)
             failure_block(error);
     }];
}

// overrides superclass
- (void)asynchronousFetchObjectsWithOptions:(SCDataFetchOptions *)fetchOptions success:(SCDataStoreFetchSuccess_Block)success_block failure:(SCDataStoreFailure_Block)failure_block
{
    if(!self.defaultWebServiceDefinition.fetchObjectsAPI)
    {
        if(failure_block)
            failure_block(nil);
        SCDebugLog(@"Error: No valid fetchObjectsAPI specified in SCWebServiceDefinition.");
        
        return;
    }
    
    if(!self.defaultWebServiceDefinition.resultsKeyName && !self.defaultWebServiceDefinition.atomicResultKeyName)
    {
        if(failure_block)
            failure_block(nil);
        SCDebugLog(@"Error: No valid resultsKeyName or atomicResultKeyName specified in SCWebServiceDefinition.");
        
        return;
    }
    
    SCWebServiceFetchOptions *webFetchOptions = nil;
    if([fetchOptions isKindOfClass:[SCWebServiceFetchOptions class]])
        webFetchOptions = (SCWebServiceFetchOptions *)fetchOptions;
    
    NSMutableString *path = [NSMutableString stringWithString:self.defaultWebServiceDefinition.fetchObjectsAPI];
    
    NSDictionary *parameters;
    if(webFetchOptions.nextBatchURLString)
    {
        [path appendString:webFetchOptions.nextBatchURLString];
        parameters = nil;
    }
    else 
    {
        parameters = self.defaultWebServiceDefinition.fetchObjectsParameters;
        if(self.defaultWebServiceDefinition.batchSizeParameterName && webFetchOptions.batchSize)
        {
            [parameters setValue:[NSNumber numberWithUnsignedInteger:webFetchOptions.batchSize]
                          forKey:self.defaultWebServiceDefinition.batchSizeParameterName];
        }
        if(self.defaultWebServiceDefinition.batchStartIndexParameterName)
        {
            NSUInteger nextBatchIndex = self.defaultWebServiceDefinition.batchInitialStartIndex+webFetchOptions.nextBatchStartIndex;
            [parameters setValue:[NSNumber numberWithUnsignedInteger:nextBatchIndex]
                          forKey:self.defaultWebServiceDefinition.batchStartIndexParameterName];
        }
    }
        
    [self.webServiceClient getPath:path parameters:parameters
                       success:^(__unused AFHTTPRequestOperation *operation, id JSON)
                        {
                            if(![JSON isKindOfClass:[NSDictionary class]])
                            {
                                if(failure_block)
                                    failure_block(nil);
                                SCDebugLog(@"Error: Invalid web service response. Expecting 'NSDictionary' but got '%@' instead.", NSStringFromClass([JSON class]));
                                
                                return;
                            }
                            
                            NSMutableArray *array = [NSMutableArray array];
                            
                            if(self.defaultWebServiceDefinition.nextBatchURLKeyName && webFetchOptions)
                            {
                                webFetchOptions.nextBatchURLString = [JSON valueForSensibleKeyPath:self.defaultWebServiceDefinition.nextBatchURLKeyName];
                                [webFetchOptions incrementBatchOffset];
                            }
                            else
                                if(self.defaultWebServiceDefinition.batchStartIndexParameterName && webFetchOptions)
                                {
                                    [webFetchOptions incrementBatchOffset];
                                }
                                
                        
                            NSArray *resultsArray = nil;
                            if(self.defaultWebServiceDefinition.atomicResultKeyName)
                            {
                                id atomicResult = [JSON valueForSensibleKeyPath:self.defaultWebServiceDefinition.atomicResultKeyName];
                                NSArray *atomicArray;
                                if([atomicResult isKindOfClass:[NSArray class]])
                                {
                                    atomicArray = atomicResult;
                                }
                                else
                                {
                                    atomicArray = [NSArray arrayWithObject:atomicResult];
                                }
                                
                                if(self.defaultWebServiceDefinition.resultsKeyName && atomicArray.count)
                                {
                                    NSDictionary *dictionary = [atomicArray objectAtIndex:0];
                                    resultsArray = [dictionary valueForKey:self.defaultWebServiceDefinition.resultsKeyName];
                                }
                                else
                                {
                                    resultsArray = atomicArray;
                                }
                            }
                            else
                            {
                                resultsArray = [JSON valueForSensibleKeyPath:self.defaultWebServiceDefinition.resultsKeyName];
                            }
                            
                            if(!resultsArray)
                            {
                                if(failure_block)
                                    failure_block(nil);
                                SCDebugLog(@"Error: resultsKeyName:'%@' does not exist in returned response.", self.defaultWebServiceDefinition.resultsKeyName);
                                
                                return;
                            }
                            
                            if(![resultsArray isKindOfClass:[NSArray class]])
                            {
                                if(failure_block)
                                    failure_block(nil);
                                SCDebugLog(@"Error: Invalid web service response. Expecting results array with type 'NSArray' but got '%@' instead.", NSStringFromClass([resultsArray class]));
                                
                                return;
                            }
                            
                            for (NSDictionary *dictionary in resultsArray) 
                            {
                                if(![dictionary isKindOfClass:[NSDictionary class]])
                                {
                                    if(failure_block)
                                        failure_block(nil);
                                    SCDebugLog(@"Error: Invalid web service response. Expecting results item of type'NSDictionary' but got '%@' instead.", NSStringFromClass([dictionary class]));
                                    
                                    return;
                                }
                                
                                NSMutableDictionary *webObject = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                                [array addObject:webObject];
                            }
                            
                            if(fetchOptions)
                            {
                                [fetchOptions filterMutableArray:array];
                                [fetchOptions sortMutableArray:array];
                            }
                            
                            if(success_block)
                                success_block(array);
                        }
                       failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) 
                        {
                            SCDebugLog(@"Web Service Error: %@", error);
                            if(failure_block)
                                failure_block(error);
                        }];
}

- (BOOL)validateInsertForObject:(NSObject *)object
{
    return self.defaultWebServiceDefinition.insertObjectAPI != nil;
}

- (BOOL)validateUpdateForObject:(NSObject *)object
{
    return self.defaultWebServiceDefinition.updateObjectAPI != nil;
}

- (BOOL)validateDeleteForObject:(NSObject *)object
{
    return self.defaultWebServiceDefinition.deleteObjectAPI != nil;
}

- (SCDataDefinition *)definitionForObject:(NSObject *)object
{
    return [_dataDefinitions valueForKey:[SCUtilities dataStructureNameForClass:[NSDictionary class]]];
}

- (void)bindStoreToPropertyName:(NSString *)propertyName forObject:(NSObject *)object withDefinition:(SCDataDefinition *)definition
{
    // does nothing
}



#pragma mark -
#pragma mark Linker related

- (void)forceLinker
{
    [SCWebServicesForceLinkerToIncludeCategories forceLinker];
    [SCWebServicesForceLinkerToIncludeCategoriesNonARC forceLinker];
}



@end



