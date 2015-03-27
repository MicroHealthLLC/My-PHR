//
//  FamilyHealthRecordAppDelegate.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 03/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <DropboxSDK/DropboxSDK.h>

@interface FamilyHealthRecordAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,DBSessionDelegate, DBNetworkRequestDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UINavigationController *navigation;
	NSArray *imageData;
	NSArray *lblname;
	NSString *UpdateString;
	NSString *Str_UpdateFunction;
	NSString *FamilyID_String;
	NSString *ModuleID_String;
	NSString *relinkUserId;
	NSString *FamMember_String;
	NSString *FamilyName_String;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigation;
@property (nonatomic, retain) NSArray *imageData;
@property (nonatomic, retain) NSArray *lblname;
@property(nonatomic,retain)  NSString *UpdateString;
@property(nonatomic,retain)  NSString *Str_UpdateFunction;
@property(nonatomic,retain)  NSString *FamilyID_String;
@property(nonatomic,retain)  NSString *ModuleID_String;
@property(nonatomic,retain)  NSString *FamMember_String;
@property(nonatomic,retain)  NSString *FamilyName_String;
- (void)createEditableCopyOfDatabaseIfNeeded;
-(void)DropBoxFunction;
@end
