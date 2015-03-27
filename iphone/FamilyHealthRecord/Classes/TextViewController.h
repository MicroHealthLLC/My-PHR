//
//  TextViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>
@class FamilyHealthRecordAppDelegate;
@interface TextViewController : UIViewController <UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>{
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	UITextView *txtview;
	UIImageView *imageview;
	UITextField *txtTitle;
	FMDatabase *database1;
	FamilyHealthRecordAppDelegate *appDelegate;
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL imageBool;
	
	NSString *title_string_text;
	NSInteger *id_int_text;
	NSString *imagename_string_text;
	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
	UILabel *lbl_title;
}
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) IBOutlet UITextView *txtview;
@property(nonatomic,retain) IBOutlet UIImageView *imageview;
@property(nonatomic,retain) IBOutlet UITextField *txtTitle;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;


@property(nonatomic,retain) NSString *title_string_text;
@property(nonatomic,assign) NSInteger *id_int_text;
@property(nonatomic,retain) NSString *imagename_string_text;

@property(nonatomic,retain) IBOutlet UIImageView *bottom_imageview;
@property(nonatomic,retain) IBOutlet UIButton *btn_Forward;
@property(nonatomic,retain) IBOutlet UIButton *btn_delete;

@property(nonatomic,assign) NSInteger *archived_int;
@property(nonatomic,retain) IBOutlet UIButton *btn_Archive;
-(IBAction)Done;
-(IBAction)Back;
-(void)InsertText;
-(void)UpdateText;

-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;

-(void)displayComposerSheet;
@end
