//
//  AppConstants.h
//  HowBe
//
//  Created by Teja Swaroop on 16/11/14.
//  Copyright (c) 2014 SaiTeja. All rights reserved.
//


#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#ifdef UI_USER_INTERFACE_IDIOM

#define STANDARD_DEFAULTS [NSUserDefaults standardUserDefaults]

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif

#define FONT_NEW_HEADING_DEMIBOLDwithFontSize(f)   [UIFont fontWithName: @"DINCompPro-Light" size:(f)]
#define FONT_NEW_HEADING_BOLDwithFontSize(f)       [UIFont fontWithName: @"Heiti TC Medium" size:(f)]
#define FONT_NEW_HEADING_MEDIUMwithFontSize(f)     [UIFont fontWithName: @"DINCompPro" size:(f)]


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define APPLICATION_NAME @"Gateway Conference"

#import <Foundation/Foundation.h>

@interface AppConstants : NSObject

#pragma mark - Variables

OBJC_EXPORT NSString * const MainStoryBoardiPad;

OBJC_EXPORT NSString * const MainStoryBoardiPhone;

#pragma APP URLs

OBJC_EXPORT NSString * const baseURL;

OBJC_EXPORT NSString * const url_Places;

OBJC_EXPORT NSString * const url_Sponsors;

OBJC_EXPORT NSString * const url_speakers;

OBJC_EXPORT NSString * const url_Faq;

OBJC_EXPORT NSString * const url_Tracks;

OBJC_EXPORT NSString * const url_Schedules;

OBJC_EXPORT NSString * const url_Videos;


@end
