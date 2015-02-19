//
//  DNLocalizationHandlerUtil.m
//  Parley
//
//  Created by Darren Ehlers on 3/26/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "DNLocalizationHandlerUtil.h"

@implementation DNLocalizationHandlerUtil

DNLocalizationHandlerUtil*  singleton;

NSString*   stringTableName;

+ (DNLocalizationHandlerUtil *)singleton
{
    return singleton;
}

__attribute__((constructor))
static void staticInit_singleton()
{
    singleton = [[DNLocalizationHandlerUtil alloc] init];
}

- (NSString *)localizedString:(NSString *)key comment:(NSString *)comment
{
    if ([stringTableName length] == 0)
    {
        stringTableName = [NSString stringWithFormat:@"InfoPlist%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PlistPost"]];
    }
    
    // default localized string loading
    NSString * localizedString = [[NSBundle mainBundle] localizedStringForKey:key value:key table:stringTableName];
    
    // if (value == key) and comment is not nil -> returns comment
    if([localizedString isEqualToString:key] && comment !=nil)
    {
        return comment;
    }
    
    return localizedString;
}

@end
