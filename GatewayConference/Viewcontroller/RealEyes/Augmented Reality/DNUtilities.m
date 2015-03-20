//
//  DNUtilities.m
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/12/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#define DEBUGLOGGING
#import "DNUtilities.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AVFoundation/AVFoundation.h>

#include <CommonCrypto/CommonHMAC.h>

#import <ifaddrs.h>
#import <arpa/inet.h>

@interface DNUtilities()
{
    int                     logDebugLevel;
    NSMutableDictionary*    logDebugDomains;
}
@end

@implementation DNUtilities

+ (DNUtilities*)sharedInstance
{
    static dispatch_once_t  once;
    static DNUtilities*     instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[DNUtilities alloc] init];
    });
    
    return instance;
}

+ (BOOL)isTall
{
    static dispatch_once_t  once;
    static BOOL             result = NO;
    
    dispatch_once(&once, ^{
        CGRect bounds = [[UIScreen mainScreen] bounds];
        CGFloat height = bounds.size.height;
        CGFloat scale = [[UIScreen mainScreen] scale];
        
        result = (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ((height * scale) >= 1136));
    });
    
    return result;
}

+ (BOOL)isDeviceIPad
{
    static dispatch_once_t  once;
    static BOOL             result = NO;
    
    dispatch_once(&once, ^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            result = YES;
        }
    });
    
    return result;
}

+ (NSString*)appendNibSuffix:(NSString*)nibNameOrNil
{
    if ([DNUtilities isDeviceIPad])
    {
        NSString*   tempNibName = [NSString stringWithFormat:@"%@~ipad", nibNameOrNil];
        if([[NSBundle mainBundle] pathForResource:tempNibName ofType:@"nib"] != nil)
        {
            //file found
            nibNameOrNil = tempNibName;
        }
    }
    else
    {
        NSString*   tempNibName = [NSString stringWithFormat:@"%@~iphone", nibNameOrNil];
        if([[NSBundle mainBundle] pathForResource:tempNibName ofType:@"nib"] != nil)
        {
            //file found
            nibNameOrNil = tempNibName;
        }
        
        if ([DNUtilities isTall])
        {
            NSString*   tempNibName = [NSString stringWithFormat:@"%@-568h", nibNameOrNil];
            if([[NSBundle mainBundle] pathForResource:tempNibName ofType:@"nib"] != nil)
            {
                //file found
                nibNameOrNil = tempNibName;
            }
            
        }
    }
    
    return nibNameOrNil;
}

+ (NSString*)deviceImageName:(NSString*)name
{
    NSString*   fileName        = [[[NSFileManager defaultManager] displayNameAtPath:name] stringByDeletingPathExtension];
    NSString*   extension       = [name pathExtension];
    if ([extension length] == 0)
    {
        extension = @"png";
    }
    
    NSString*   orientationStr  = @"";
    NSString*   orientation2Str = @"";
    NSString*   deviceStr       = @"";
    NSString*   osStr           = @"";
    
    UIInterfaceOrientation  orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        {
            orientationStr  = @"-Portrait";
            orientation2Str = @"-Portrait";
            break;
        }

        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orientationStr  = @"-Portrait";
            orientation2Str = @"-PortraitUpsideDown";
            break;
        }
            
        case UIInterfaceOrientationLandscapeLeft:
        {
            orientationStr  = @"-Landscape";
            orientation2Str = @"-LandscapeLeft";
            break;
        }
            
        case UIInterfaceOrientationLandscapeRight:
        {
            orientationStr  = @"-Landscape";
            orientation2Str = @"-LandscapeRight";
            break;
        }
    }

    if ([DNUtilities isDeviceIPad])
    {
        deviceStr   = @"~ipad";
    }
    else
    {
        if ([DNUtilities isTall])
        {
            deviceStr   = @"-568h@2x";
        }
        else
        {
            deviceStr   = @"~iphone";
        }
    }

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        osStr   = @"-iOS7";
    }

    NSString*   tempName;
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@%@%@", deviceStr, orientation2Str, osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@%@", deviceStr, orientation2Str];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@%@", orientation2Str, osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", orientation2Str];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@%@%@", deviceStr, orientationStr, osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@%@", deviceStr, orientationStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@%@", orientationStr, osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", orientationStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@%@", deviceStr, osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    tempName = [fileName stringByAppendingFormat:@"%@", deviceStr];
    if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
    {
        return [tempName stringByAppendingFormat:@".%@", extension];
    }
    
    if ([osStr length] > 0)
    {
        tempName = [fileName stringByAppendingFormat:@"%@", osStr];
        if ([[NSBundle mainBundle] pathForResource:tempName ofType:extension] != nil)
        {
            return [tempName stringByAppendingFormat:@".%@", extension];
        }
    }
    
    return [fileName stringByAppendingFormat:@".%@", extension];
}

+ (void)runBlock:(void (^)())block
{
    block();
}

+ (void)runAfterDelay:(CGFloat)delay block:(void (^)())block
{
    void (^block_)() = [block copy];
    [self performSelector:@selector(runBlock:) withObject:block_ afterDelay:delay];
}

- (void)instanceRunBlock:(void (^)())block
{
    block();
    //[DNUtilities runBlock:block];
}

+ (NSTimer*)repeatRunAfterDelay:(CGFloat)delay block:(void (^)())block
{
    void (^block_)() = [block copy];

    return [NSTimer scheduledTimerWithTimeInterval:delay target:[DNUtilities sharedInstance] selector:@selector(instanceRunBlock:) userInfo:block_ repeats:YES];
}

+ (void)runOnMainThreadWithoutDeadlocking:(void (^)(void))block
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (bool)canDevicePlaceAPhoneCall
{
    /*
        Returns YES if the device can place a phone call
     */
    
    // Check if the device can place a phone call
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
    {
        // Device supports phone calls, lets confirm it can place one right now
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        
        if (([mnc length] > 0) && (![mnc isEqualToString:@"65535"]))
        {
            // Device can place a phone call
            return YES;
        }
    }

    // Device does not support phone calls
    return  NO;
}

+(AVAudioPlayer*)createSound:(NSString*)fName ofType:(NSString*)ext
{
    AVAudioPlayer*  avSound = nil;
    
    NSString*   path  = [[NSBundle mainBundle] pathForResource:fName ofType:ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSURL*  pathURL = [NSURL fileURLWithPath:path];
        
        avSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
        [avSound prepareToPlay];
    }
    else
    {
        DLog(LL_Debug, @"error, file not found: %@", path);
    }
    
    return avSound;
}

+ (void)playSound:(NSString*)name
{
    static AVAudioPlayer*  avSound_buzz = nil;
    static AVAudioPlayer*  avSound_ding = nil;
    static AVAudioPlayer*  avSound_tada = nil;
    
    static dispatch_once_t  once;
    
    dispatch_once(&once, ^{
        avSound_buzz    = [DNUtilities createSound:@"buzz" ofType:@"mp3"];
        avSound_ding    = [DNUtilities createSound:@"ding" ofType:@"mp3"];
        avSound_tada    = [DNUtilities createSound:@"tada" ofType:@"mp3"];
    });

    if ([name isEqualToString:@"buzz"] == YES)
    {
        [avSound_buzz play];
    }
    else if ([name isEqualToString:@"ding"] == YES)
    {
        [avSound_ding play];
    }
    else if ([name isEqualToString:@"tada"] == YES)
    {
        [avSound_tada play];
    }
}

+ (NSString*)encodeWithHMAC_SHA1:(NSString*)data withKey:(NSString*)key
{
    const char* cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString*   hexStr = [NSString  stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        cHMAC[0], cHMAC[1], cHMAC[2], cHMAC[3], cHMAC[4],
                        cHMAC[5], cHMAC[6], cHMAC[7],
                        cHMAC[8], cHMAC[9], cHMAC[10], cHMAC[11], cHMAC[12],
                        cHMAC[13], cHMAC[14], cHMAC[15],
                        cHMAC[16], cHMAC[17], cHMAC[18], cHMAC[19]
                     ];
    
    return hexStr;
}

+ (NSString*)getIPAddress
{
    struct ifaddrs* interfaces  = NULL;
    struct ifaddrs* temp_addr   = NULL;
    
    NSString*   wifiAddress = nil;
    NSString*   cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if (!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if (sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString*   name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString*   addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                }
                else
                {
                    if([name isEqualToString:@"pdp_ip0"])
                    {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

+ (UIImage*)imageScaledForRetina:(UIImage*)image
{
    // [UIImage imageWithCGImage:[newImage CGImage] scale:2.0 orientation:UIImageOrientationUp];
    // [newImage scaleProportionalToSize:CGSizeMake(32, 32)];
    
    double  scale   = [[UIScreen mainScreen] scale];
    NSLog(@"scale=%.2f", scale);
    
    return [UIImage imageWithCGImage:[image CGImage] scale:scale orientation:UIImageOrientationUp];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        logDebugLevel   = LL_Everything;
        logDebugDomains = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)logSetLevel:(int)level
{
    logDebugLevel   = level;
}

- (void)logEnableDomain:(NSString*)domain
{
    [logDebugDomains setObject:@YES forKey:domain];
}

- (void)logDisableDomain:(NSString*)domain
{
    [logDebugDomains setObject:@NO forKey:domain];
}

- (BOOL)isLogEnabledDomain:(NSString*)domain
                  andLevel:(int)level
{
    if (level > logDebugLevel)
    {
        return NO;
    }

    if ([logDebugDomains valueForKey:domain] != nil)
    {
        return [[logDebugDomains objectForKey:domain] boolValue];
    }

    return YES;
}

@end

void DNLogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...)
{
    if ([[DNUtilities sharedInstance] isLogEnabledDomain:domain andLevel:level] == YES)
    {
        va_list args;
        va_start(args, format);

        NSString*   formattedStr = [[NSString alloc] initWithFormat:format arguments:args];
        NSLog(@"{%@} [%@:%d] %@", domain, [[NSString stringWithUTF8String:filename] lastPathComponent], lineNumber, formattedStr);

        va_end(args);
    }
}
