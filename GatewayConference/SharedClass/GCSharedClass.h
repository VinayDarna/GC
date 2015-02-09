//
//  SharedClass.h
//  HowBe
//
//  Created by Teja Swaroop on 16/11/14.
//  Copyright (c) 2014 SaiTeja. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SpeakersBlock)(NSMutableArray * speakers, BOOL Success);

@interface GCSharedClass : NSObject
{
    NSMutableArray * responceArray;
}
+(GCSharedClass *)sharedInstance;

-(BOOL)isNetworkAvalible;
-(void)fetchDetailsWithParameter:(NSString*)paramStr andReturnWith:(SpeakersBlock)completionHandler;

- (void)fetchParseDetails;

@end
