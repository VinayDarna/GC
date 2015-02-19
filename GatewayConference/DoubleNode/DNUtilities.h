//
//  DNUtilities.h
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/12/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stats.h"
#import "DCIntrospect.h"

#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

#import "DNAppConstants.h"
#import "DNEventInterceptWindow.h"

//#import "GANTracker.h"
#import "LoggerClient.h"

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  DLog Logging Items and Macros
 */
typedef NS_ENUM(NSInteger, LogLevel)
{
    LL_Critical = 0,
    LL_Error,
    LL_Warning,
    LL_Debug,
    LL_Info,
    LL_Everything
};

#define LD_UnitTests        @"UNITTESTS"
#define LD_General          @"GENERAL"
#define LD_Framework        @"FRAMEWORK"
#define LD_CoreData         @"COREDATA"
#define LD_ViewState        @"VIEWSTATE"
#define LD_Theming          @"THEMING"

#if !defined(DEBUG)
#define DLogMarker(marker)   NSLog(@"%@", marker)
#define DLog(level,...)      NSLog(__VA_ARGS__)
#define DLogData(level,data) for(;;)
#define DLogImage(...)       for(;;)
#else
#define DLogMarker(marker)       NSLog(@"%@", marker); LogMessageF(__FILE__,__LINE__,__FUNCTION__,LD_General,level,@"%@", marker)
#define DLog(level,...)          DNLogMessageF(__FILE__,__LINE__,__FUNCTION__,LD_General,level,__VA_ARGS__); LogMessageF(__FILE__,__LINE__,__FUNCTION__,LD_General,level,__VA_ARGS__)
#define DLogData(level,data)     LogDataF(__FILE__,__LINE__,__FUNCTION__,LD_General,level,data)
#define DLogImage(level,image)   LogImageDataF(__FILE__,__LINE__,__FUNCTION__,LD_General,level,image.size.width,image.size.height,UIImagePNGRepresentation(image))

extern void LogImageDataF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, int width, int height, NSData *data);

#undef assert
#if __DARWIN_UNIX03
#define assert(e)   (__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert_rtn(__func__, __FILE__, __LINE__, #e)) : (void)0)
#else
#define assert(e)   (__builtin_expect(!(e), 0) ? (CFShow(CFSTR("assert going to fail, connect NSLogger NOW\n")), LoggerFlush(NULL,YES), __assert(#e, __FILE__, __LINE__)) : (void)0)
#endif
#endif

typedef void (^RevealBlock)();
typedef BOOL (^RevealBlock_Bool)();

@interface DNUtilities : NSObject

+ (BOOL)isTall;
+ (BOOL)isDeviceIPad;

+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil;
+ (NSString*)deviceImageName:(NSString*)name;

+ (void)runBlock:(void (^)())block;
+ (void)runAfterDelay:(CGFloat)delay block:(void (^)())block;
+ (NSTimer*)repeatRunAfterDelay:(CGFloat)delay block:(void (^)())block;
+ (void)runOnMainThreadWithoutDeadlocking:(void (^)(void))block;
+ (bool)canDevicePlaceAPhoneCall;

+ (void)playSound:(NSString*)name;
+ (NSString*)encodeWithHMAC_SHA1:(NSString*)data withKey:(NSString*)key;

+ (NSString*)getIPAddress;

+ (UIImage*)imageScaledForRetina:(UIImage*)image;

- (void)logSetLevel:(int)level;
- (void)logEnableDomain:(NSString*)domain;
- (void)logDisableDomain:(NSString*)domain;

@end

void DNLogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...);
