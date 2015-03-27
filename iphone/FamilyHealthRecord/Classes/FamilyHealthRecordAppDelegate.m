//
//  FamilyHealthRecordAppDelegate.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 03/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FamilyHealthRecordAppDelegate.h"
#import"DropBoxViewController.h"
@implementation FamilyHealthRecordAppDelegate

@synthesize window;
@synthesize tabBarController,navigation,imageData,lblname,UpdateString,FamilyID_String,ModuleID_String,FamMember_String,FamilyName_String;
@synthesize Str_UpdateFunction;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.

	
	
	NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"passLock"]];
	if([str isEqualToString:@"(null)"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"switch"];
		[[NSUserDefaults standardUserDefaults]setValue:@"No" forKey:@"passLock"];
	}
    // Add the tab bar controller's view to the window and display.
    //[window addSubview:tabBarController.view];
	sleep(2);
	
	NSError *error;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
	
    NSString *folderstring = [documentsDirectory1 stringByAppendingPathComponent:@"/.DB_Family"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
	
	[self createEditableCopyOfDatabaseIfNeeded];
   [self DropBoxFunction];
	
	[window addSubview:[navigation view]];
    [window makeKeyAndVisible];
	imageData=[[NSArray alloc]init];
	lblname=[[NSArray alloc]init];
    NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSInteger majorVersion = 
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
	if (launchURL && majorVersion < 4) {
		// Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
		// iOS versions 3.2 or below
		[self application:application handleOpenURL:launchURL];
		return NO;
	}
	return YES;
}
-(void)DropBoxFunction
{
    NSString* appKey = @"gva0cat7tjpvwhh";
	NSString* appSecret = @"zgzgvlf4dgu8lov";
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps 
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist = 
        [NSPropertyListSerialization 
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
	DBSession* session = 
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    [session release];
	
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
    
 /*  rootViewController.photoViewController = [[PhotoViewController new] autorelease];
    if ([[DBSession sharedSession] isLinked]) {
        navigationController.viewControllers = 
        [NSArray arrayWithObjects:rootViewController, rootViewController.photoViewController, nil];
    }
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];*/
	
	/*NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSInteger majorVersion = 
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
	if (launchURL && majorVersion < 4) {
		// Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
		// iOS versions 3.2 or below
		[self application:application handleOpenURL:launchURL];
		return NO;
	}*/
    
}
- (void)createEditableCopyOfDatabaseIfNeeded {
	NSString *databaseName = @"/.DB_Family/FamilyHealthRecord.sqlite";
	NSString *databaseName2 = @"FamilyHealthRecord.sqlite";
	//NSString *databaseName=@"/DB_Family";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    
	//databasePath = [[[documentsDir stringByAppendingFormat:databaseName];
	NSString *databasePath=[[NSString alloc] initWithString: [documentsDir stringByAppendingPathComponent: databaseName]];
	
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	
	if (success) {
		///NSLog(@"Successfuly created");
		return;
	}
	else
	{
		NSString *databasePathFromApp = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:databaseName2];
		NSData *adata = [[NSData alloc]initWithContentsOfFile:databasePathFromApp];
		[adata writeToFile:databasePath atomically:YES];
		//	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		//	[self createTest];
		//	NSLog(@"Newly created");
	}
}
+(sqlite3 *) getNewDBConnection
{
    sqlite3 *newDBconnection;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &newDBconnection) == SQLITE_OK) {
        NSLog(@"Database Successfully Opened :)");
    }
    else {
        NSLog(@"Error in opening database :(");
    }
    return newDBconnection;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		if ([[DBSession sharedSession] isLinked]) {
			//[navigationController pushViewController:rootViewController.photoViewController animated:YES];
		}
		return YES;
	}
	
	return NO;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
	[[NSUserDefaults standardUserDefaults]setObject:@"yes1" forKey:@"passLock"];
}



#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}
#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = [userId retain];
	[[[[UIAlertView alloc] 
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self 
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
	  autorelease]
	 show];
}
- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}
#pragma mark -
#pragma mark UIAlertViewDelegate methods

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:relinkUserId fromController:DropBoxViewController];
	}
	[relinkUserId release];
	relinkUserId = nil;
}
*/

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}




@end

