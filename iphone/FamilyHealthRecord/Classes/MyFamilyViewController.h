//
//  MyFamilyViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 04/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"Sqlite3.h"
#import "KVPasscodeViewController.h"

@class FamilyHealthRecordAppDelegate;
@interface MyFamilyViewController : UIViewController <UIApplicationDelegate,KVPasscodeViewControllerDelegate>{
	NSString *FnameString;
	NSString *LnameString;
	UIImageView *imageview1;
	UIImageView *imageview2;
	UIButton *btnSetting;
	
	UIScrollView *scrollview;
	NSMutableArray *labelNameArray;
	NSMutableArray *imageArray;
	NSArray *fileListArray;
	FamilyHealthRecordAppDelegate *appDelegate;
	UIButton *btn;
	UIButton *deletebtn;
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	BOOL BarbuttonBool;
	BOOL NextbuttonBool;
	
	NSString *strNewPass;
    NSString *strRePass;
	NSArray *fileList;
	
}
-(IBAction)Add;
-(IBAction)Edit;
@property(nonatomic,retain) IBOutlet UIImageView *imageview1;
@property(nonatomic,retain) IBOutlet UIImageView *imageview2;;
@property(nonatomic,retain) IBOutlet UIButton *btnSetting;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;

//UIButton *btnSetting;
-(void)createPlaylistScrollView;
-(void)FetchData;
-(void)Editmethod;
-(IBAction)Setting;
-(void)PassCode;
@end
