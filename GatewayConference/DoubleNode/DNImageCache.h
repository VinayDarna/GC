//
//  DNImageCache.h
//  Parley
//
//  Created by Darren Ehlers on 2/18/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "JMImageCache.h"

@interface DNImageCache : JMImageCache

+ (DNImageCache*)sharedCache;

- (void) imageForURL:(NSURL *)url completionBlock:(CompletionBlock_Image_Cached)completion;
- (void) imageForURL:(NSURL *)url key:(NSString *)key completionBlock:(CompletionBlock_Image_Cached)completion;

@end
