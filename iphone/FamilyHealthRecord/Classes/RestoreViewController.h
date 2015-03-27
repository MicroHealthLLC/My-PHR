//
//  RestoreViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 20/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import"sqlite3.h"
#import"FMDatabase.h"

@class DBRestClient;
@interface RestoreViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,DBRestClientDelegate,DBSessionDelegate,UITableViewDataSource,UITableViewDelegate>{

	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	BOOL EditBool;
	DBRestClient *restClient;
 	NSMutableArray *labelNameArray;
    UITableView *tblview;
	NSString *strname;
	UIProgressView *progrssview;
    UIActivityIndicatorView *activityindicator;
	UIButton *btnCancel;
	UIImageView *imageview_backup;
    NSMutableArray *stringArray1;
}
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) IBOutlet UITableView *tblview;

@property(nonatomic,retain) IBOutlet UIProgressView *progrssview;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityindicator;
@property(nonatomic,retain) IBOutlet UIButton *btnCancel;
@property(nonatomic,retain) IBOutlet UIImageView *imageview_backup;
-(IBAction)Back;
-(IBAction)Done;
-(void)FetchData;
-(IBAction)Cancel;
@end
