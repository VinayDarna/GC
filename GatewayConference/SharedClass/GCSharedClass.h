//
//  SharedClass.h
//  HowBe
//
//  Created by Teja Swaroop on 16/11/14.
//  Copyright (c) 2014 SaiTeja. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"

#import <MBProgressHUD.h>

typedef void(^GCBlock)(NSMutableArray * modelObjectsArray, BOOL Success);


@interface GCSharedClass : NSObject
{
    NSMutableArray * responceArray;
   }

@property(nonatomic, strong) UIWindow *window;

+(GCSharedClass *)sharedInstance;

-(BOOL)checkNetworkAndProceed:(UIViewController*)viewControllerObject;
-(BOOL)isNetworkAvalible;

-(void)fetchDetailsWithParameter:(NSString*)paramStr andReturnWith:(GCBlock)completionHandler;

- (void)fetchParseDetails;

- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;

- (void)dismissGlobalHUD;

@end
