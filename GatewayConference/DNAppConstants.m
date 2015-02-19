//
//  DNAppConstants.m
//  Parley
//
//  Created by Darren Ehlers on 2013/01/17.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import "DNAppConstants.h"
#import "ColorUtils.h"

#import "PARConstant.h"

#import "PARParleyAPI.h"

@implementation DNAppConstants

+ (NSUInteger)appStoreID        {   return [[DNAppConstants constantValue:@"appStoreID"] integerValue];           }
+ (BOOL)arEnabled               {   return [[DNAppConstants constantValue:@"arEnabled"] boolValue];               }

+ (BOOL)bumpEnabled             {   return [[DNAppConstants constantValue:@"bumpEnabled"] boolValue];             }
+ (NSString*)bumpApiKey         {   return [DNAppConstants constantValue:@"bumpApiKey"];                          }

+ (NSString*)flurryApiKey       {   return [DNAppConstants constantValue:@"flurryApiKey"];                        }

+ (NSString*)googleAnalyticsID  {   return [DNAppConstants constantValue:@"googleAnalyticsID"];                   }

+ (NSString*)hockeyAppID        {   return [DNAppConstants constantValue:@"hockeyAppID"];                         }
+ (BOOL)hockeyAppLogEnabled     {   return [[DNAppConstants constantValue:@"hockeyAppLogEnabled"] boolValue];     }

+ (NSString*)parseAppID         {   return [DNAppConstants constantValue:@"parseAppID"];                          }
+ (NSString*)parseClientKey     {   return [DNAppConstants constantValue:@"parseClientKey"];                      }

+ (BOOL)adEnabled                       {   return [[DNAppConstants constantValue:@"adEnabled"] boolValue];       }
+ (NSString*)adLocation                 {   return [DNAppConstants constantValue:@"adLocation"];                  }
+ (BOOL)adAdMobPriority                 {   return [[DNAppConstants constantValue:@"adAdMobPriority"] boolValue]; }
+ (NSString*)adAdModIphonePublisherID   {   return [DNAppConstants constantValue:@"adAdModIphonePublisherID"];    }
+ (NSString*)adAdModIpadPublisherID     {   return [DNAppConstants constantValue:@"adAdModIpadPublisherID"];      }

+ (NSString*)contactPhoneNumber         {   return [DNAppConstants constantValue:@"contactPhoneNumber"];                  }
+ (NSString*)contactEmailSubject        {   return [DNAppConstants constantValue:@"contactEmailSubject"];                 }
+ (NSArray*)contactEmailToRecipients    {   return @[ [DNAppConstants constantValue:@"contactEmailToRecipient"] ];        }
+ (NSString*)contactEmailBodyDefault    {   return [DNAppConstants constantValue:@"contactEmailBodyDefault"];             }
+ (double)contactMapLatitude            {   return [[DNAppConstants constantValue:@"contactMapLatitude"] doubleValue];    }
+ (double)contactMapLongitude           {   return [[DNAppConstants constantValue:@"contactMapLongitude"] doubleValue];   }
+ (NSString*)contactMapLocation         {   return [DNAppConstants constantValue:@"contactMapLocation"];                  }
+ (NSString*)contactFacebookProfile     {   return [DNAppConstants constantValue:@"contactFacebookProfile"];              }
+ (NSString*)contactTwitterProfile      {   return [DNAppConstants constantValue:@"contactTwitterProfile"];               }
+ (NSString*)contactWebsiteURL          {   return [DNAppConstants constantValue:@"contactWebsiteURL"];                   }

+ (NSString*)twitterHashTag             {   return [DNAppConstants constantValue:@"twitterHashTag"];                      }
+ (NSString*)instagramHashTag           {   return [DNAppConstants constantValue:@"instagramHashTag"];                    }

+ (UIColor*)colorDefaultTabContentBG    {   return [DNAppConstants colorWithString:@"colorDefaultTabContentBG"];    }
+ (UIColor*)colorTitlingBG              {   return [DNAppConstants colorWithString:@"colorTitlingBG"];              }
+ (UIColor*)colorTitlingFG              {   return [DNAppConstants colorWithString:@"colorTitlingFG"];              }
+ (UIColor*)colorListTextBG             {   return [DNAppConstants colorWithString:@"colorListTextBG"];             }
+ (UIColor*)colorListTextFG             {   return [DNAppConstants colorWithString:@"colorListTextFG"];             }
+ (UIColor*)colorBioTitlingFG           {   return [DNAppConstants colorWithString:@"colorBioTitlingFG"];           }
+ (UIColor*)colorBioTitlingShadow       {   return [DNAppConstants colorWithString:@"colorBioTitlingShadow"];       }
+ (UIColor*)colorBioTextBG              {   return [DNAppConstants colorWithString:@"colorBioTextBG"];              }
+ (UIColor*)colorBioTextFG              {   return [DNAppConstants colorWithString:@"colorBioTextFG"];              }
+ (UIColor*)colorNoteNavBarFG           {   return [DNAppConstants colorWithString:@"colorNoteNavBarFG"];           }
+ (UIColor*)colorSystemMenuAboutFG      {   return [DNAppConstants colorWithString:@"colorSystemMenuAboutFG"];      }
+ (UIColor*)colorSystemMenuFAQFG        {   return [DNAppConstants colorWithString:@"colorSystemMenuFAQFG"];        }
+ (UIColor*)colorMapCategoryTopBG       {   return [DNAppConstants colorWithString:@"colorMapCategoryTopBG"];       }
+ (UIColor*)colorMapCategoryBottomBG    {   return [DNAppConstants colorWithString:@"colorMapCategoryBottomBG"];    }
+ (UIColor*)colorMapBG                  {   return [DNAppConstants colorWithString:@"colorMapBG"];                  }
+ (UIColor*)colorMapDragBG              {   return [DNAppConstants colorWithString:@"colorMapDragBG"];              }
+ (UIColor*)colorMapListBG              {   return [DNAppConstants colorWithString:@"colorMapListBG"];              }
+ (UIColor*)colorMapListAltBG           {   return [DNAppConstants colorWithString:@"colorMapListAltBG"];           }
+ (UIColor*)colorMapListFG              {   return [DNAppConstants colorWithString:@"colorMapListFG"];              }
+ (UIColor*)colorMapListTitleBG         {   return [DNAppConstants colorWithString:@"colorMapListTitleBG"];         }
+ (UIColor*)colorMapListTitleFG         {   return [DNAppConstants colorWithString:@"colorMapListTitleFG"];         }
+ (UIColor*)colorScheduleSessionSelectBigLabelFG    {   return [DNAppConstants colorWithString:@"colorScheduleSessionSelectBigLabelFG"];    }
+ (UIColor*)colorScheduleSessionSelectLabelFG       {   return [DNAppConstants colorWithString:@"colorScheduleSessionSelectLabelFG"];       }
+ (UIColor*)colorScheduleSessionBG      {   return [DNAppConstants colorWithString:@"colorScheduleSessionBG"];      }
+ (UIColor*)colorScheduleSessionAltBG   {   return [DNAppConstants colorWithString:@"colorScheduleSessionAltBG"];   }
+ (UIColor*)colorScheduleSessionDateFG  {   return [DNAppConstants colorWithString:@"colorScheduleSessionDateFG"];  }
+ (UIColor*)colorScheduleSessionTimeFG  {   return [DNAppConstants colorWithString:@"colorScheduleSessionTimeFG"];  }
+ (UIColor*)colorScheduleSessionTitleFG {   return [DNAppConstants colorWithString:@"colorScheduleSessionTitleFG"]; }
+ (UIColor*)colorScheduleFAQBG          {   return [DNAppConstants colorWithString:@"colorScheduleFAQBG"];          }
+ (UIColor*)colorScheduleFAQAltBG       {   return [DNAppConstants colorWithString:@"colorScheduleFAQAltBG"];       }
+ (UIColor*)colorScheduleFAQBodyFG      {   return [DNAppConstants colorWithString:@"colorScheduleFAQBodyFG"];      }
+ (UIColor*)colorScheduleFAQTitleFG     {   return [DNAppConstants colorWithString:@"colorScheduleFAQTitleFG"];     }
+ (UIColor*)colorShareSocialTitleFG     {   return [DNAppConstants colorWithString:@"colorShareSocialTitleFG"];     }
+ (UIColor*)colorShareSocialNameFG      {   return [DNAppConstants colorWithString:@"colorShareSocialNameFG"];      }
+ (UIColor*)colorShareSocialMessageFG   {   return [DNAppConstants colorWithString:@"colorShareSocialMessageFG"];   }
+ (UIColor*)colorShareSocialAgeFG       {   return [DNAppConstants colorWithString:@"colorShareSocialAgeFG"];       }
+ (UIColor*)colorShareSocialBG          {   return [DNAppConstants colorWithString:@"colorShareSocialBG"];          }
+ (UIColor*)colorShareSocialAltBG       {   return [DNAppConstants colorWithString:@"colorShareSocialAltBG"];       }
+ (UIColor*)colorShareInstagramBG       {   return [DNAppConstants colorWithString:@"colorShareInstagramBG"];       }
+ (UIColor*)colorShareInstagramAltBG    {   return [DNAppConstants colorWithString:@"colorShareInstagramAltBG"];    }
+ (UIColor*)colorPreImageBG             {   return [DNAppConstants colorWithString:@"colorPreImageBG"];             }

+ (BOOL)flagBioTitlingForceUpper        {   return [DNAppConstants boolWithString:@"flagBioTitlingForceUpper"];         }
+ (BOOL)flagPeopleSpeakersTextList      {   return [DNAppConstants boolWithString:@"flagPeopleSpeakersTextList"];       }
+ (BOOL)flagPeoplePartnersTextList      {   return [DNAppConstants boolWithString:@"flagPeoplePartnersTextList"];       }
+ (BOOL)flagPeopleSponsorsTextList      {   return [DNAppConstants boolWithString:@"flagPeopleSponsorsTextList"];       }
+ (BOOL)flagPeopleWorshipTextList       {   return [DNAppConstants boolWithString:@"flagPeopleWorshipTextList"];        }
+ (BOOL)flagPeopleHostAndEmceesTextList {   return [DNAppConstants boolWithString:@"flagPeopleHostAndEmceesTextList"];  }
+ (BOOL)flagScheduleActivitiesTextList  {   return [DNAppConstants boolWithString:@"flagScheduleActivitiesTextList"];   }
+ (BOOL)flagScheduleLocationsTextList   {   return [DNAppConstants boolWithString:@"flagScheduleLocationsTextList"];    }
+ (BOOL)flagMediaMediaTextList          {   return [DNAppConstants boolWithString:@"flagMediaMediaTextList"];           }
+ (BOOL)flagPeopleSpeakersTab           {   return [DNAppConstants boolWithString:@"flagPeopleSpeakersTab"];            }
+ (BOOL)flagPeopleSpeakersTitles        {   return [DNAppConstants boolWithString:@"flagPeopleSpeakersTitles"];         }
+ (BOOL)flagPeoplePartnersTab           {   return [DNAppConstants boolWithString:@"flagPeoplePartnersTab"];            }
+ (BOOL)flagPeopleSponsorsTab           {   return [DNAppConstants boolWithString:@"flagPeopleSponsorsTab"];            }
+ (BOOL)flagPeopleWorshipTab            {   return [DNAppConstants boolWithString:@"flagPeopleWorshipTab"];             }
+ (BOOL)flagPeopleHostAndEmceesTab      {   return [DNAppConstants boolWithString:@"flagPeopleHostAndEmceesTab"];       }
+ (BOOL)flagScheduleSpeakersTab         {   return [DNAppConstants boolWithString:@"flagScheduleSpeakersTab"];          }
+ (BOOL)flagScheduleLocationsTab        {   return [DNAppConstants boolWithString:@"flagScheduleLocationsTab"];         }
+ (BOOL)flagScheduleActivitiesTab       {   return [DNAppConstants boolWithString:@"flagScheduleActivitiesTab"];        }
+ (BOOL)flagScheduleSessionsTab         {   return [DNAppConstants boolWithString:@"flagScheduleSessionsTab"];          }
+ (BOOL)flagScheduleFAQTab              {   return [DNAppConstants boolWithString:@"flagScheduleFAQTab"];               }
+ (BOOL)flagShareMediaTab               {   return [DNAppConstants boolWithString:@"flagShareMediaTab"];                }
+ (BOOL)flagShareShareTab               {   return [DNAppConstants boolWithString:@"flagShareShareTab"];                }
+ (BOOL)flagShareSocialTab              {   return [DNAppConstants boolWithString:@"flagShareSocialTab"];               }
+ (BOOL)flagShareInstagramTab           {   return [DNAppConstants boolWithString:@"flagShareInstagramTab"];            }
+ (BOOL)flagLocationsMapTab             {   return [DNAppConstants boolWithString:@"flagLocationsMapTab"];              }

+ (UIFont*)fontSystemMenuAbout                  {   return [DNAppConstants fontWithPreString:@"fontSystemMenuAbout"];               }
+ (UIFont*)fontSystemMenuFAQ                    {   return [DNAppConstants fontWithPreString:@"fontSystemMenuFAQ"];                 }
+ (UIFont*)fontTitling                          {   return [DNAppConstants fontWithPreString:@"fontTitling"];                       }
+ (UIFont*)fontListText                         {   return [DNAppConstants fontWithPreString:@"fontListText"];                      }
+ (UIFont*)fontBioTitling                       {   return [DNAppConstants fontWithPreString:@"fontBioTitling"];                    }
+ (UIFont*)fontBioText                          {   return [DNAppConstants fontWithPreString:@"fontBioText"];                       }
+ (UIFont*)fontNoteNavBar                       {   return [DNAppConstants fontWithPreString:@"fontNoteNavBar"];                    }
+ (UIFont*)fontMapList                          {   return [DNAppConstants fontWithPreString:@"fontMapList"];                       }
+ (UIFont*)fontMapListTitle                     {   return [DNAppConstants fontWithPreString:@"fontMapListTitle"];                  }
+ (UIFont*)fontScheduleFAQBody                  {   return [DNAppConstants fontWithPreString:@"fontScheduleFAQBody"];               }
+ (UIFont*)fontScheduleFAQTitle                 {   return [DNAppConstants fontWithPreString:@"fontScheduleFAQTitle"];              }
+ (UIFont*)fontScheduleSessionSelectBigLabel    {   return [DNAppConstants fontWithPreString:@"fontScheduleSessionSelectBigLabel"]; }
+ (UIFont*)fontScheduleSessionSelectLabel       {   return [DNAppConstants fontWithPreString:@"fontScheduleSessionSelectLabel"];    }
+ (UIFont*)fontScheduleSessionDate              {   return [DNAppConstants fontWithPreString:@"fontScheduleSessionDate"];           }
+ (UIFont*)fontScheduleSessionTime              {   return [DNAppConstants fontWithPreString:@"fontScheduleSessionTime"];           }
+ (UIFont*)fontScheduleSessionTitle             {   return [DNAppConstants fontWithPreString:@"fontScheduleSessionTitle"];          }
+ (UIFont*)fontShareSocialTitle                 {   return [DNAppConstants fontWithPreString:@"fontShareSocialTitle"];              }
+ (UIFont*)fontShareSocialName                  {   return [DNAppConstants fontWithPreString:@"fontShareSocialName"];               }
+ (UIFont*)fontShareSocialMessage               {   return [DNAppConstants fontWithPreString:@"fontShareSocialMessage"];            }
+ (UIFont*)fontShareSocialAge                   {   return [DNAppConstants fontWithPreString:@"fontShareSocialAge"];                }
+ (UIFont*)fontShareShareLabels                 {   return [DNAppConstants fontWithPreString:@"fontShareShareLabels"];              }
+ (UIFont*)fontShareShareHeader                 {   return [DNAppConstants fontWithPreString:@"fontShareShareHeader"];              }
+ (UIFont*)fontShareShareFooter                 {   return [DNAppConstants fontWithPreString:@"fontShareShareFooter"];              }

+ (CGSize)sizePeoplePartnersThumbnails      {   return [DNAppConstants sizeWithPreString:@"sizePeoplePartnersThumbnails"];      }
+ (CGSize)sizePeopleSpeakersThumbnails      {   return [DNAppConstants sizeWithPreString:@"sizePeopleSpeakersThumbnails"];      }
+ (CGSize)sizePeopleSponsorsThumbnails      {   return [DNAppConstants sizeWithPreString:@"sizePeopleSponsorsThumbnails"];      }
+ (CGSize)sizeScheduleActivitiesThumbnails  {   return [DNAppConstants sizeWithPreString:@"sizeScheduleActivitiesThumbnails"];  }
+ (CGSize)sizeScheduleLocationsThumbnails   {   return [DNAppConstants sizeWithPreString:@"sizeScheduleLocationsThumbnails"];   }
+ (CGSize)sizeShareMediaThumbnails          {   return [DNAppConstants sizeWithPreString:@"sizeShareMediaThumbnails"];          }

+ (double)noteNavBarCornerRadius        {   return [DNAppConstants doubleWithPreString:@"noteNavBarCornerRadius"];      }
+ (double)toolbarAlphaHidden            {   return [DNAppConstants doubleWithPreString:@"toolbarAlphaHidden"];          }

+ (UIColor*)colorWithString:(NSString*)string
{
    return [UIColor colorWithString:[DNAppConstants constantValue:string]];
}

+ (BOOL)boolWithString:(NSString*)string
{
    return [[DNAppConstants constantValue:string] boolValue];
}

+ (double)doubleWithPreString:(NSString*)string
{
    return [[DNAppConstants constantValue:string] doubleValue];
}

+ (UIFont*)fontWithPreString:(NSString*)preString
{
    NSString*   fontName    = [DNAppConstants constantValue:[NSString stringWithFormat:@"%@Name", preString]];
    NSString*   fontSize    = [DNAppConstants constantValue:[NSString stringWithFormat:@"%@Size", preString]];
    
    UIFont* retFont  = [UIFont fontWithName:fontName size:([fontSize doubleValue] / 2)];
    
    return [retFont fontWithSize:([fontSize doubleValue] / 2)];
}

+ (CGSize)sizeWithPreString:(NSString*)preString
{
    NSString*   sizeWidth   = [DNAppConstants constantValue:[NSString stringWithFormat:@"%@Width", preString]];
    NSString*   sizeHeight  = [DNAppConstants constantValue:[NSString stringWithFormat:@"%@Height", preString]];
    
    return CGSizeMake([sizeWidth floatValue], [sizeHeight floatValue]);
}

+ (id)constantValue:(NSString*)key
{
    static BOOL firstTime = YES;
    
    @synchronized( self )
    {
        if (firstTime == YES)
        {
            BOOL    resetFlag   = [[DNAppConstants plistConfig:@"ResetConstants"] boolValue];
            if (resetFlag == YES)
            {
                [PARConstant deleteAll];
            }
            
            [[PARParleyAPI manager] expireAppStyle];
            
            firstTime = NO;
        }
    }
    
    PARConstant*    constant = [PARConstant getFromKey:key];
    if (constant == nil)
    {
        constant        = [[PARConstant alloc] init];
        constant.key    = key;
        constant.value  = [NSString stringWithFormat:@"%@", [DNAppConstants plistConfig:key]];
        [constant save];
    }
    
    return constant.value;
}

+ (id)plistConfig:(NSString*)key
{
    static NSDictionary*    dict = nil;
    
    @synchronized( self )
    {
        if (dict == nil)
        {
            dict    = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Constants_plist"] ofType:@"plist"]];
        }
    }
    
    id  value = [dict objectForKey:key];
    if ((value == nil) || (value == [NSNull null]))
    {
        NSLog(@"***** MISSING CONSTANT KEY: %@", key);
    }
    
    return value;
}

@end
