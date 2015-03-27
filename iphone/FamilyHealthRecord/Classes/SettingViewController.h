//
//  SettingViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 01/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"Sqlite3.h"
#import"FMDatabase.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingViewController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{

	UIButton *btnPassCode;
	UISwitch *passswitch;	
	NSArray *documentPaths;
	NSString *documentsDir;
	FMDatabase *database1;
	
	NSMutableArray *DataArray;
	
	NSString *DataString;
	NSString *totalString;
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL EmailBool;
}
@property(nonatomic,retain) IBOutlet UIButton *btnPassCode;
@property(nonatomic,retain) IBOutlet UISwitch *passswitch;
-(IBAction)Back;
-(IBAction)switchingbtn:(id)sender;

-(IBAction)Email;
-(IBAction)DeleteHistory;


-(IBAction)DropBox;

-(IBAction)FeedBack;
-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(void)FetchData;
-(void)FetchTotalNo;
@end
