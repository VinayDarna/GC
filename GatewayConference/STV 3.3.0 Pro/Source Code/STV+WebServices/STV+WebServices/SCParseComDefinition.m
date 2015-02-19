/*
 *  SCParseComDefinition.h
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


#import "SCParseComDefinition.h"

@implementation SCParseComDefinition

@synthesize className = _className;
@synthesize applicationId = _applicationId;
@synthesize restAPIKey = _restAPIKey;


+ (id)definitionWithClassName:(NSString *)className columnNamesString:(NSString *)columnNames applicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey
{
    return [[[self class] alloc] initWithClassName:className columnNamesString:columnNames applicationId:applicationId restAPIKey:restAPIKey];
}


- (id)init
{
	if( (self = [super init]) )
	{
        self.baseURL = [NSURL URLWithString:@"https://api.parse.com/1/classes/"];
        
        self.resultsKeyName = @"results";
        [self.httpHeaders setValue:@"application/json" forKey:@"Content-Type"];
        self.objectIdKeyName = @"objectId";
        self.readOnlyKeyNames = @"objectId;createdAt;updatedAt";
        
        _applicationId = nil;
        _restAPIKey = nil;
	}
	return self;
}

- (id)initWithClassName:(NSString *)className columnNamesString:(NSString *)columnNames applicationId:(NSString *)applicationId restAPIKey:(NSString *)restAPIKey
{
    self = [self initWithDictionaryKeyNamesString:columnNames];
    if(self)
    {
        self.className = className;
        self.applicationId = applicationId;
        self.restAPIKey = restAPIKey;
    }
    
    return self;
}


- (void)setClassName:(NSString *)className
{
    _className = className;
    
    self.fetchObjectsAPI = className;
    self.insertObjectAPI = className;
    self.updateObjectAPI = className;
    self.deleteObjectAPI = className;
}

- (void)setApplicationId:(NSString *)applicationId
{
    _applicationId = applicationId;
    
    [self.httpHeaders setValue:applicationId forKey:@"X-Parse-Application-Id"];
}

- (void)setRestAPIKey:(NSString *)restAPIKey
{
    _restAPIKey = restAPIKey;
    
    [self.httpHeaders setValue:restAPIKey forKey:@"X-Parse-REST-API-Key"];
}

@end
