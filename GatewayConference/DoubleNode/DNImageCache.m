//
//  DNImageCache.m
//  Parley
//
//  Created by Darren Ehlers on 2/18/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "DNImageCache.h"

DNImageCache*   _DNsharedCache = nil;

@implementation DNImageCache

inline static NSString* keyForURL(NSURL* url)
{
	return [url absoluteString];
}

+ (DNImageCache*)sharedCache
{
	if (!_DNsharedCache)
    {
		_DNsharedCache = [[DNImageCache alloc] init];
	}
	return _DNsharedCache;
}

- (BOOL)isExpired:(NSString*)cacheKey
          withTTL:(NSUInteger)ttl
{
    NSDate* lastCheck = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"[IMG]%@", cacheKey]];
    NSLog(@"[IMG]%@ lastCheck=%@", cacheKey, lastCheck);
    if (lastCheck)
    {
        NSCalendar*         gregorian   = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger          unitFlags   = NSDayCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents*   components  = [gregorian components:unitFlags fromDate:lastCheck toDate:[NSDate date] options:0];
        
        NSInteger   days    = [components day];
        NSInteger   minutes = [components minute];
        NSLog(@"days=%d, minutes=%d", days, minutes);
        
        if (minutes < ttl)
        {
            NSLog(@"NOT expired");
            return NO;
        }
    }
    
    NSLog(@"Expired");
    return YES;
}

- (void)markUpdated:(NSString*)cacheKey
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[NSString stringWithFormat:@"[IMG]%@", cacheKey]];
}

- (void) imageForURL:(NSURL*)url completionBlock:(CompletionBlock_Image_Cached)completion
{
    [self imageForURL:url key:keyForURL(url) completionBlock:completion];
}

- (void) imageForURL:(NSURL*)url key:(NSString*)key completionBlock:(CompletionBlock_Image_Cached)completion
{
    [super imageForURL:url key:key completionBlock:completion];
    
    if ([self isExpired:key withTTL:60] == NO)
    {
        return;
    }
    
    NSLog(@"*** EXPIRED - [IMG]%@", key);
    [self markUpdated:key];
    
    [[JMImageCache sharedCache] removeImageForKey:key];
    
    [super imageForURL:url key:key completionBlock:nil];
}

@end
