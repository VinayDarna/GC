//
//  SharedClass.m
//  HowBe
//
//  Created by Teja Swaroop on 16/11/14.
//  Copyright (c) 2014 SaiTeja. All rights reserved.
//

#import "GCSharedClass.h"

#import "Reachability.h"

#import "AFNetworking.h"

#import "GCSpeakerModel.h"


@implementation GCSharedClass

static GCSharedClass * sharedClassObj = nil;

+(GCSharedClass *)sharedInstance
{
    if(sharedClassObj == nil)
    {
        sharedClassObj = [[super allocWithZone:NULL]init];
    }
    
    return sharedClassObj;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return sharedClassObj;
}

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        // do your init here
    }
    
    return self;
}

/*
 This method checks the if the internet connection is available for the device.
 @returns Yes if the internet connection is available, otherwise no.
 */
-(BOOL)isNetworkAvalible
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [Reachability reachabilityWithHostname:@"http://www.google.co.in/"];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)fetchDetailsWithParameter:(NSString*)paramStr andReturnWith:(SpeakersBlock)completionHandler;
{
    __block NSMutableArray * speakers = [NSMutableArray new];
    
    NSString *string = [NSString stringWithFormat:@"%@/%@",GATEWAY_BASEURL,paramStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]])
         {
             if ([paramStr isEqualToString:@"speakers"])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"speakers"];
             
                 for (NSMutableDictionary * dictObj in responceArray)
                 {
                     GCSpeakerModel * gcspeaker = [GCSpeakerModel new];

                    // Speakers
                     gcspeaker.nid = [[dictObj objectForKey:@"speaker"]objectForKey:@"nid"];
                     gcspeaker.title = [[dictObj objectForKey:@"speaker"]objectForKey:@"title"];
                     gcspeaker.body = [[dictObj objectForKey:@"speaker"]objectForKey:@"body"];
                     gcspeaker.facebook = [[dictObj objectForKey:@"speaker"]objectForKey:@"facebook"];
                     gcspeaker.group_image = [[dictObj objectForKey:@"speaker"]objectForKey:@"group_image"];
                     gcspeaker.image = [[dictObj objectForKey:@"speaker"]objectForKey:@"image"];
                     gcspeaker.image_thumbnail = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_thumbnail"];
                     gcspeaker.image_api_thumbnail = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_api_thumbnail"];
                     gcspeaker.image_banner = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_banner"];
                     gcspeaker.location = [[dictObj objectForKey:@"speaker"]objectForKey:@"location"];
                     gcspeaker.organization = [[dictObj objectForKey:@"speaker"]objectForKey:@"organization"];
                     gcspeaker.organization_title = [[dictObj objectForKey:@"speaker"]objectForKey:@"organization_title"];
                     gcspeaker.quote = [[dictObj objectForKey:@"speaker"]objectForKey:@"quote"];
                     gcspeaker.session_name = [[dictObj objectForKey:@"speaker"]objectForKey:@"session_name"];
                     gcspeaker.session_summary = [[dictObj objectForKey:@"speaker"]objectForKey:@"session_summary"];
                     gcspeaker.speaker_links = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_links"];
                     gcspeaker.speaker_type = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_type"];
                     gcspeaker.twitter = [[dictObj objectForKey:@"speaker"]objectForKey:@"twitter"];
                     gcspeaker.speaker_event = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_event"];
                     gcspeaker.Banner_Link = [[dictObj objectForKey:@"speaker"]objectForKey:@"Banner Link"];
                     gcspeaker.url = [[dictObj objectForKey:@"speaker"]objectForKey:@"url"];
                     
                     [speakers addObject:gcspeaker];
                     NSLog(@"%@",speakers);
                 }
             }
             else if ([paramStr isEqualToString:@"sponsors"])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"sponsors"];
                 for (NSMutableDictionary * dictobj in responceArray)
                 {
                     GCSpeakerModel * gcspeaker = [GCSpeakerModel new];

                     gcspeaker.nid = [[dictobj objectForKey:@"sponsor"]objectForKey:@"nid"];
                     gcspeaker.title = [[dictobj objectForKey:@"sponsor"]objectForKey:@"title"];
                     gcspeaker.body = [[dictobj objectForKey:@"sponsor"]objectForKey:@"body"];
                     gcspeaker.facebook = [[dictobj objectForKey:@"sponsor"]objectForKey:@"facebook"];
                     gcspeaker.logo = [[dictobj objectForKey:@"sponsor"]objectForKey:@"logo"];
                     gcspeaker.level = [[dictobj objectForKey:@"sponsor"]objectForKey:@"level"];
                     gcspeaker.twitter = [[dictobj objectForKey:@"sponsor"]objectForKey:@"twitter"];
                     gcspeaker.url = [[dictobj objectForKey:@"sponsor"]objectForKey:@"url"];
                     
                     [speakers addObject:gcspeaker];
                 }
             }
         }
         completionHandler(speakers,YES);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         completionHandler(nil,NO);
                                     }];
    [operation start];
}

- (void)fetchParseDetails
{
    dispatch_queue_t myQueue = dispatch_queue_create("Deals Queue",NULL);
    
    dispatch_async(myQueue, ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Installation"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error)
            {
                NSLog(@"Successfully retrieved");
                
                for (PFObject *object in objects)
                {
                    NSLog(@"object %@",object);
                }
            }
            else
            {
                NSLog(@"Error: %@ %@", error, [error userInfo]);

            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
        });
    });
    
    
}


@end
