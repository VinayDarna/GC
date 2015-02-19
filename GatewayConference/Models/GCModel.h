//
//  GCSpeakerModel.h
//  Deals4You
//
//  Created by Teja Swaroop on 14/01/15.
//  Copyright (c) 2015 SaiTeja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCModel : NSObject

//Speaker

@property (nonatomic, strong) NSString * nid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSString * facebook;
@property (nonatomic, strong) NSString * group_image;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * image_thumbnail;
@property (nonatomic, strong) NSString * image_api_thumbnail;
@property (nonatomic, strong) NSString * image_banner;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * organization;
@property (nonatomic, strong) NSString * organization_title;
@property (nonatomic, strong) NSString * quote;
@property (nonatomic, strong) NSString * session_name;
@property (nonatomic, strong) NSString * session_summary;
@property (nonatomic, strong) NSArray  * speaker_links;
@property (nonatomic, strong) NSArray  * speaker_type;
@property (nonatomic, strong) NSString * twitter;
@property (nonatomic, strong) NSArray  * speaker_event;
@property (nonatomic, strong) NSArray  * Banner_Link;
@property (nonatomic, strong) NSString  * url;

// Sponsor

@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSString * level;

//Tracks

@property (nonatomic, strong) NSString * survey;

@end
