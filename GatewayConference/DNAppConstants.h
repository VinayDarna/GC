//
//  DNAppConstants.h
//  Parley
//
//  Created by Darren Ehlers on 2013/01/17.
//  Copyright (c) 2013 Gateway Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAppConstants : NSObject

+ (NSUInteger)appStoreID;
+ (BOOL)arEnabled;

+ (BOOL)bumpEnabled;
+ (NSString*)bumpApiKey;

+ (NSString*)hockeyAppID;
+ (BOOL)hockeyAppLogEnabled;

+ (NSString*)flurryApiKey;

+ (NSString*)googleAnalyticsID;

+ (NSString*)parseAppID;
+ (NSString*)parseClientKey;

+ (BOOL)adEnabled;
+ (NSString*)adLocation;
+ (BOOL)adAdMobPriority;
+ (NSString*)adAdModIphonePublisherID;
+ (NSString*)adAdModIpadPublisherID;

+ (NSString*)contactPhoneNumber;
+ (NSString*)contactTwitterProfile;
+ (NSString*)contactFacebookProfile;
+ (NSString*)contactEmailSubject;
+ (NSArray*)contactEmailToRecipients;
+ (NSString*)contactEmailBodyDefault;
+ (double)contactMapLatitude;
+ (double)contactMapLongitude;
+ (NSString*)contactMapLocation;
+ (NSString*)contactWebsiteURL;

+ (NSString*)twitterHashTag;
+ (NSString*)instagramHashTag;

+ (UIColor*)colorDefaultTabContentBG;
+ (UIColor*)colorTitlingBG;
+ (UIColor*)colorTitlingFG;
+ (UIColor*)colorListTextBG;
+ (UIColor*)colorListTextFG;
+ (UIColor*)colorBioTitlingFG;
+ (UIColor*)colorBioTitlingShadow;
+ (UIColor*)colorBioTextBG;
+ (UIColor*)colorBioTextFG;
+ (UIColor*)colorNoteNavBarFG;
+ (UIColor*)colorSystemMenuAboutFG;
+ (UIColor*)colorSystemMenuFAQFG;
+ (UIColor*)colorMapCategoryTopBG;
+ (UIColor*)colorMapCategoryBottomBG;
+ (UIColor*)colorMapBG;
+ (UIColor*)colorMapDragBG;
+ (UIColor*)colorMapListBG;
+ (UIColor*)colorMapListAltBG;
+ (UIColor*)colorMapListFG;
+ (UIColor*)colorMapListTitleBG;
+ (UIColor*)colorMapListTitleFG;
+ (UIColor*)colorScheduleSessionSelectBigLabelFG;
+ (UIColor*)colorScheduleSessionSelectLabelFG;
+ (UIColor*)colorScheduleSessionBG;
+ (UIColor*)colorScheduleSessionAltBG;
+ (UIColor*)colorScheduleSessionDateFG;
+ (UIColor*)colorScheduleSessionTimeFG;
+ (UIColor*)colorScheduleSessionTitleFG;
+ (UIColor*)colorScheduleFAQBG;
+ (UIColor*)colorScheduleFAQAltBG;
+ (UIColor*)colorScheduleFAQBodyFG;
+ (UIColor*)colorScheduleFAQTitleFG;
+ (UIColor*)colorShareSocialTitleFG;
+ (UIColor*)colorShareSocialNameFG;
+ (UIColor*)colorShareSocialMessageFG;
+ (UIColor*)colorShareSocialAgeFG;
+ (UIColor*)colorShareSocialBG;
+ (UIColor*)colorShareSocialAltBG;
+ (UIColor*)colorShareInstagramBG;
+ (UIColor*)colorShareInstagramAltBG;
+ (UIColor*)colorPreImageBG;

+ (BOOL)flagBioTitlingForceUpper;
+ (BOOL)flagPeopleSpeakersTextList;
+ (BOOL)flagPeoplePartnersTextList;
+ (BOOL)flagPeopleSponsorsTextList;
+ (BOOL)flagPeopleWorshipTextList;
+ (BOOL)flagPeopleHostAndEmceesTextList;
+ (BOOL)flagScheduleActivitiesTextList;
+ (BOOL)flagScheduleLocationsTextList;
+ (BOOL)flagMediaMediaTextList;
+ (BOOL)flagPeopleSpeakersTab;
+ (BOOL)flagPeopleSpeakersTitles;
+ (BOOL)flagPeoplePartnersTab;
+ (BOOL)flagPeopleSponsorsTab;
+ (BOOL)flagPeopleWorshipTab;
+ (BOOL)flagPeopleHostAndEmceesTab;
+ (BOOL)flagScheduleSpeakersTab;
+ (BOOL)flagScheduleLocationsTab;
+ (BOOL)flagScheduleActivitiesTab;
+ (BOOL)flagScheduleSessionsTab;
+ (BOOL)flagScheduleFAQTab;
+ (BOOL)flagShareMediaTab;
+ (BOOL)flagShareShareTab;
+ (BOOL)flagShareSocialTab;
+ (BOOL)flagShareInstagramTab;
+ (BOOL)flagLocationsMapTab;

+ (UIFont*)fontSystemMenuAbout;
+ (UIFont*)fontSystemMenuFAQ;
+ (UIFont*)fontTitling;
+ (UIFont*)fontListText;
+ (UIFont*)fontBioTitling;
+ (UIFont*)fontBioText;
+ (UIFont*)fontNoteNavBar;
+ (UIFont*)fontMapList;
+ (UIFont*)fontMapListTitle;
+ (UIFont*)fontScheduleFAQBody;
+ (UIFont*)fontScheduleFAQTitle;
+ (UIFont*)fontScheduleSessionSelectBigLabel;
+ (UIFont*)fontScheduleSessionSelectLabel;
+ (UIFont*)fontScheduleSessionDate;
+ (UIFont*)fontScheduleSessionTime;
+ (UIFont*)fontScheduleSessionTitle;
+ (UIFont*)fontShareSocialTitle;
+ (UIFont*)fontShareSocialName;
+ (UIFont*)fontShareSocialMessage;
+ (UIFont*)fontShareSocialAge;
+ (UIFont*)fontShareShareLabels;
+ (UIFont*)fontShareShareHeader;
+ (UIFont*)fontShareShareFooter;

+ (CGSize)sizePeoplePartnersThumbnails;
+ (CGSize)sizePeopleSpeakersThumbnails;
+ (CGSize)sizePeopleSponsorsThumbnails;
+ (CGSize)sizeScheduleActivitiesThumbnails;
+ (CGSize)sizeScheduleLocationsThumbnails;
+ (CGSize)sizeShareMediaThumbnails;

+ (double)noteNavBarCornerRadius;
+ (double)toolbarAlphaHidden;

+ (NSString*)plistConfig:(NSString*)key;

@end
