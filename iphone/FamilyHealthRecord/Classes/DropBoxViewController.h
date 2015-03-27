//
//  DropBoxViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 11/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import"sqlite3.h"
#import"FMDatabase.h"


@class DBRestClient;

@interface DropBoxViewController : UIViewController<DBRestClientDelegate,DBSessionDelegate,UIAlertViewDelegate> {

	UIBarButtonItem *leftbarbutton;
	DBRestClient* restClient;
	UIButton* linkButton;
	UIButton* backupButton;
	UIButton* restoreButton;
    UIProgressView *progrssview;
    UIActivityIndicatorView *activityindicator;
	UIButton *btn1;
	UIButton *btn2;
    UIButton *btn3;
	
	UIButton *btnCancel;
	UIImageView *imageview_backup;
	
	sqlite3 *database;
	sqlite3_stmt *statement;
	FMDatabase *database1;
	NSMutableArray *dataArray;
	NSString *timeString;
	BOOL success_bool;
}
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbarbutton;
@property (nonatomic, retain) IBOutlet UIButton* linkButton;
@property (nonatomic, retain) IBOutlet UIButton* backupButton;
@property (nonatomic, retain) IBOutlet UIButton* restoreButton;
@property (nonatomic, retain) IBOutlet UIProgressView *progrssview;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityindicator;
@property (nonatomic, retain) IBOutlet UIButton *btn1;
@property (nonatomic, retain) IBOutlet UIButton *btn2;
@property (nonatomic, retain) IBOutlet UIButton *btn3;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIImageView *imageview_backup;
-(IBAction)setting;
-(IBAction)Link;
-(IBAction)Backup;
-(IBAction)Restore;
- (void)updateButtons;
-(IBAction)Cancel;
-(void)InsertData;
-(void)totalCountNo;
@end
