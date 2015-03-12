//
//  AppDelegate.h
//  GatewayConference
//
//  Created by Teja Swaroop on 09/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK.h>
#import <Accounts/Accounts.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *Fbreqid;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSString *)docPath;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property(assign) BOOL checktheId;
@property (strong, nonatomic) FBSession *session;

@end

