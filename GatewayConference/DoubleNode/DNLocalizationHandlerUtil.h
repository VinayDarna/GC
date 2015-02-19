//
//  DNLocalizationHandlerUtil.h
//  Parley
//
//  Created by Darren Ehlers on 3/26/13.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNLocalizationHandlerUtil : NSObject

+ (DNLocalizationHandlerUtil*)singleton;

- (NSString *)localizedString:(NSString *)key comment:(NSString *)comment;

@end
