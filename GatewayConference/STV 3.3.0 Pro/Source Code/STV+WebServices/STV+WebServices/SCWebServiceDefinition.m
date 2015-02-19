/*
 *  SCWebServiceDefinition.m
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


#import "SCWebServiceDefinition.h"

#import "SCWebServiceFetchOptions.h"
#import "SCArrayOfObjectsSection+WebServices.h"
#import "SCWebServiceStore.h"


#import "SCWebServicesForceLinkerToIncludeCategories.h"
#import "SCWebServicesForceLinkerToIncludeCategoriesNonARC.h"




@implementation SCWebServiceDefinition

@synthesize baseURL = _baseURL;
@synthesize httpHeaders = _httpHeaders;
@synthesize fetchObjectsAPI = _fetchObjectsAPI;
@synthesize fetchObjectsParameters = _fetchObjectsParameters;
@synthesize resultsKeyName = _resultsKeyName;
@synthesize atomicResultKeyName = _atomicResultKeyName;
@synthesize batchSizeParameterName = _batchSizeParameterName;
@synthesize batchStartIndexParameterName = _batchStartIndexParameterName;
@synthesize batchInitialStartIndex = _batchInitialStartIndex;
@synthesize nextBatchURLKeyName = _nextBatchURLKeyName;
@synthesize objectIdKeyName = _objectIdKeyName;
@synthesize readOnlyKeyNames = _readOnlyKeyNames;
@synthesize insertObjectAPI = _insertObjectAPI;
@synthesize insertObjectParameters = _insertObjectParameters;
@synthesize updateObjectAPI = _updateObjectAPI;
@synthesize updateObjectParameters = _updateObjectParameters;
@synthesize deleteObjectAPI = _deleteObjectAPI;
@synthesize deleteObjectParameters = _deleteObjectParameters;


+ (id)definitionWithBaseURL:(NSString *)baseURL fetchObjectsAPI:(NSString *)api resultsKeyName:(NSString *)resultsKey resultsDictionaryKeyNamesString:(NSString *)keyNamesString
{
    return [[[self class] alloc] initWithBaseURL:baseURL fetchObjectsAPI:api resultsKeyName:resultsKey resultsDictionaryKeyNamesString:keyNamesString];
}

+ (id)definitionWithBaseURL:(NSString *)baseURL fetchObjectsAPI:(NSString *)api resultsKeyName:(NSString *)resultsKey resultsDictionaryKeyNames:(NSArray *)keyNames
{
    return [[[self class] alloc] initWithBaseURL:baseURL fetchObjectsAPI:api resultsKeyName:resultsKey resultsDictionaryKeyNames:keyNames];
}


- (id)init
{
	if( (self = [super init]) )
	{
        _baseURL = nil;
        
        _httpHeaders = [[NSMutableDictionary alloc] init];
        _fetchObjectsAPI = nil;
        _fetchObjectsParameters = [[NSMutableDictionary alloc] init];
        _resultsKeyName = nil;
        _atomicResultKeyName = nil;
        _batchSizeParameterName = nil;
        _batchStartIndexParameterName = nil;
        _batchInitialStartIndex = 0;
        _nextBatchURLKeyName = nil;
        
        _objectIdKeyName = nil;
        _readOnlyKeyNames = nil;
        
        _insertObjectAPI = nil;
        _insertObjectParameters = [[NSMutableDictionary alloc] init];
        _updateObjectAPI = nil;
        _updateObjectParameters = [[NSMutableDictionary alloc] init];
        _deleteObjectAPI = nil;
        _deleteObjectParameters = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id)initWithBaseURL:(NSString *)baseURL fetchObjectsAPI:(NSString *)api resultsKeyName:(NSString *)resultsKey resultsDictionaryKeyNamesString:(NSString *)keyNamesString
{
    if( (self = [self initWithDictionaryKeyNamesString:keyNamesString]) )
	{
        self.baseURL = [NSURL URLWithString:baseURL];
        self.fetchObjectsAPI = api;
        self.resultsKeyName = resultsKey;
    }
    return self;
}

- (id)initWithBaseURL:(NSString *)baseURL fetchObjectsAPI:(NSString *)api resultsKeyName:(NSString *)resultsKey resultsDictionaryKeyNames:(NSArray *)keyNames
{
    if( (self = [self initWithDictionaryKeyNames:keyNames]) )
	{
        self.baseURL = [NSURL URLWithString:baseURL];
        self.fetchObjectsAPI = api;
        self.resultsKeyName = resultsKey;
    }
    return self;
}


- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
	NSString *credentials = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString *encodedCredentials = [SCUtilities base64EncodedStringFromString:credentials];
    [self.httpHeaders setValue:[NSString stringWithFormat:@"Basic %@", encodedCredentials] forKey:@"Authorization"];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token
{
    [self.httpHeaders setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forKey:@"Authorization"];
}

- (void)clearAuthorizationHeader
{
	[self.httpHeaders removeObjectForKey:@"Authorization"];
}


// overrides superclass
- (SCDataStore *)generateCompatibleDataStore
{
    return [SCWebServiceStore storeWithDefaultWebServiceDefinition:self];
}

// overrides superclass
- (SCDataFetchOptions *)generateCompatibleDataFetchOptions
{
    SCWebServiceFetchOptions *webServiceFetchOptions = [[SCWebServiceFetchOptions alloc] init];
    webServiceFetchOptions.sortKey = self.keyPropertyName;
    
    return webServiceFetchOptions;
}


#pragma mark -
#pragma mark Linker related

- (void)forceLinker
{
    [SCWebServicesForceLinkerToIncludeCategories forceLinker];
    [SCWebServicesForceLinkerToIncludeCategoriesNonARC forceLinker];
}


@end
