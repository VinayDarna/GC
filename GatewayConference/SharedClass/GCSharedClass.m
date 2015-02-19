//
//  SharedClass.m
//  HowBe
//
//  Created by Teja Swaroop on 16/11/14.
//  Copyright (c) 2014 SaiTeja. All rights reserved.
//

#import "GCSharedClass.h"

#import "GCModel.h"

#import "AppDelegate.h"

@implementation GCSharedClass

AppDelegate * appdelegateObj;


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
        appdelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        self.window = [[[UIApplication sharedApplication] windows] lastObject];
    }
    return self;
}

-(BOOL)checkNetworkAndProceed:(UIViewController*)viewControllerObject
{
    if ([self isNetworkAvalible])
    {
        return YES;
    }
    else
    {
        return NO;
    }
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

/**
 * showGlobalProgressHUDWithTitle
 *
 *  @param <#statements#> <#statements#>
 *  @param <#statements#>   <#statements#>
 */

- (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = title;
    return hud;
}

- (void)dismissGlobalHUD
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

-(void)fetchDetailsWithParameter:(NSString*)paramStr andReturnWith:(GCBlock)completionHandler;
{
    __block NSMutableArray * responseArray = [NSMutableArray new];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",baseURL,paramStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]])
         {
             if ([paramStr isEqualToString:url_Speakers])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"speakers"];
             
                 for (NSMutableDictionary * dictObj in responceArray)
                 {
                     GCModel * modelobj = [GCModel new];

                    // Speakers
                     modelobj.nid = [[dictObj objectForKey:@"speaker"]objectForKey:@"nid"];
                     modelobj.title = [[dictObj objectForKey:@"speaker"]objectForKey:@"title"];
                     modelobj.body = [[dictObj objectForKey:@"speaker"]objectForKey:@"body"];
                     modelobj.facebook = [[dictObj objectForKey:@"speaker"]objectForKey:@"facebook"];
                     modelobj.group_image = [[dictObj objectForKey:@"speaker"]objectForKey:@"group_image"];
                     modelobj.image = [[dictObj objectForKey:@"speaker"]objectForKey:@"image"];
                     modelobj.image_thumbnail = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_thumbnail"];
                     modelobj.image_api_thumbnail = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_api_thumbnail"];
                     modelobj.image_banner = [[dictObj objectForKey:@"speaker"]objectForKey:@"image_banner"];
                     modelobj.location = [[dictObj objectForKey:@"speaker"]objectForKey:@"location"];
                     modelobj.organization = [[dictObj objectForKey:@"speaker"]objectForKey:@"organization"];
                     modelobj.organization_title = [[dictObj objectForKey:@"speaker"]objectForKey:@"organization_title"];
                     modelobj.quote = [[dictObj objectForKey:@"speaker"]objectForKey:@"quote"];
                     modelobj.session_name = [[dictObj objectForKey:@"speaker"]objectForKey:@"session_name"];
                     modelobj.session_summary = [[dictObj objectForKey:@"speaker"]objectForKey:@"session_summary"];
                     modelobj.speaker_links = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_links"];
                     modelobj.speaker_type = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_type"];
                     modelobj.twitter = [[dictObj objectForKey:@"speaker"]objectForKey:@"twitter"];
                     modelobj.speaker_event = [[dictObj objectForKey:@"speaker"]objectForKey:@"speaker_event"];
                     modelobj.Banner_Link = [[dictObj objectForKey:@"speaker"]objectForKey:@"Banner Link"];
                     modelobj.url = [[dictObj objectForKey:@"speaker"]objectForKey:@"url"];
                     
                     [responseArray addObject:modelobj];
                }
             }
             else if ([paramStr isEqualToString:url_Sponsors])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"sponsors"];
                 
                 for (NSMutableDictionary * dictobj in responceArray)
                 {
                     //Sponsors
                     GCModel * modelobj = [GCModel new];

                     modelobj.nid = [[dictobj objectForKey:@"sponsor"]objectForKey:@"nid"];
                     modelobj.title = [[dictobj objectForKey:@"sponsor"]objectForKey:@"title"];
                     modelobj.body = [[dictobj objectForKey:@"sponsor"]objectForKey:@"body"];
                     modelobj.facebook = [[dictobj objectForKey:@"sponsor"]objectForKey:@"facebook"];
                     modelobj.logo = [[dictobj objectForKey:@"sponsor"]objectForKey:@"logo"];
                     modelobj.level = [[dictobj objectForKey:@"sponsor"]objectForKey:@"level"];
                     modelobj.twitter = [[dictobj objectForKey:@"sponsor"]objectForKey:@"twitter"];
                     modelobj.url = [[dictobj objectForKey:@"sponsor"]objectForKey:@"url"];
                     modelobj.image_banner = [[dictobj objectForKey:@"sponsor"]objectForKey:@"image_banner"];
                     
                     [responseArray addObject:modelobj];
                 }
             }
             else if ([paramStr isEqualToString:url_Faq])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"faqs"];
                 
                 for (NSMutableDictionary * dictobj in responceArray)
                 {
                     //FAQ
                     GCModel * modelobj = [GCModel new];
                     
                     modelobj.nid = [[dictobj objectForKey:@"faq"]objectForKey:@"nid"];
                     modelobj.title = [[dictobj objectForKey:@"faq"]objectForKey:@"title"];
                     modelobj.body = [[dictobj objectForKey:@"faq"]objectForKey:@"body"];
                     
                     [responseArray addObject:modelobj];
                 }
             }
             else if ([paramStr isEqualToString:url_Tracks])
             {
                 responceArray = (NSMutableArray *)[responseObject objectForKey:@"tracks"];
                 
                 for (NSMutableDictionary * dictobj in responceArray)
                 {
                     //Tracks
                     GCModel *modelobj = [GCModel new];
                     
                     modelobj.nid = [[dictobj objectForKey:@"track"]objectForKey:@"nid"];
                     modelobj.title = [[dictobj objectForKey:@"track"]objectForKey:@"title"];
                     modelobj.body = [[dictobj objectForKey:@"track"]objectForKey:@"body"];
                     modelobj.survey = [[dictobj objectForKey:@"track"]objectForKey:@"survey"];
                     
                     [responseArray addObject:modelobj];
                 }
             }
         }
         
         NSLog(@"responseArray :%@",responseArray);

         completionHandler(responseArray,YES);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         completionHandler(nil,NO);
                                     }];
    [operation start];
}

- (void)fetchParseDetails
{
//    dispatch_queue_t myQueue = dispatch_queue_create("Deals Queue",NULL);
//    
//    dispatch_async(myQueue, ^{
//        PFQuery *query = [PFQuery queryWithClassName:@"Course"];
//        
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            
//            if (!error)
//            {
//                NSLog(@"Successfully retrieved");
//                
//                for (PFObject *object in objects)
//                {
//                    NSLog(@"object %@",object);
//                    
//                    
//                    NSLog(@"object %@",[object objectForKey:@"courseJson"]);
//                    
//                    NSMutableDictionary * test = [[NSMutableDictionary alloc]init];
//                    
//                    test = [NSJSONSerialization JSONObjectWithData:[[object objectForKey:@"courseJson"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//                    
//                    NSLog(@"etst %@",test);
//                }
//            }
//            else
//            {
//                NSLog(@"Error: %@ %@", error, [error userInfo]);
//
//            }
//        }];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Update the UI
//            
//        });
//    });
}


@end
