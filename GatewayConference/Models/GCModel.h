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

@property (nonatomic, strong) NSString *nid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *group_image;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *image_thumbnail;
@property (nonatomic, strong) NSString *image_api_thumbnail;
@property (nonatomic, strong) NSString *image_banner;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *organization_title;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *session_name;
@property (nonatomic, strong) NSString *session_summary;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSArray  *links;
@property (nonatomic, strong) NSArray  *speaker_type;
@property (nonatomic, strong) NSArray  *speaker_event;
@property (nonatomic, strong) NSArray  *Banner_Link;

// Sponsor
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *level;

//Tracks
@property (nonatomic, strong) NSString *survey;

//Places
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSArray *category;


//Schedules

@property (nonatomic, strong) NSString *roomNid;
@property (nonatomic, strong) NSString *roomFloorPlan;
@property (nonatomic, strong) NSString *roomImage;
@property (nonatomic, strong) NSString *roomTitle;
@property (nonatomic, strong) NSString *sessionDay;
@property (nonatomic, strong) NSString *track;
@property (nonatomic, strong) NSString *additionalInformation;
@property (nonatomic, strong) NSString *isRegistered;
@property (nonatomic, strong) NSString *roomBody;
@property (nonatomic, strong) NSString *datetime;
@property (nonatomic, strong) NSString *sessionTime;

@property (nonatomic, strong) NSArray *speakers;

@end
