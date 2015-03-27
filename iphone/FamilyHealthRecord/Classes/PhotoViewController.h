//
//  PhotoViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 17/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>

@class FamilyHealthRecordAppDelegate;
@interface PhotoViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate> {
	UIImageView *imageview;
	
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	UITextField *txtTitle;
	FMDatabase *database1;
	FamilyHealthRecordAppDelegate *appDelegate;
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL imageBool;
	
	NSString *title_string;
	NSInteger *id_int;
	NSString *imagename_string;
	
	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
	UILabel *lbl_title;
	
}
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;
@property(nonatomic,retain) IBOutlet UIImageView *imageview;

@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) IBOutlet UITextField *txtTitle;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;

@property(nonatomic,retain) NSString *title_string;
@property(nonatomic,assign) NSInteger *id_int;
@property(nonatomic,retain) NSString *imagename_string;

@property(nonatomic,retain) IBOutlet UIImageView *bottom_imageview;
@property(nonatomic,retain) IBOutlet UIButton *btn_Forward;
@property(nonatomic,retain) IBOutlet UIButton *btn_delete;
@property(nonatomic,assign) NSInteger *archived_int;
@property(nonatomic,retain) IBOutlet UIButton *btn_Archive;


-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Done;
-(IBAction)Back;
-(void)InsertPhoto;
-(void)UpdatePhoto;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;



-(void)displayComposerSheet;
@end
