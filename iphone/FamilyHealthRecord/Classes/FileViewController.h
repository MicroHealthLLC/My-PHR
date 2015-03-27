//
//  FileViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 13/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"sqlite3.h"
#import"FMDatabase.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVBase.h>
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>
@class FamilyHealthRecordAppDelegate;
@interface FileViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
	UILabel *lbl_title;
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	FamilyHealthRecordAppDelegate *appDelegate;
	NSArray *fileListArray;
	NSMutableArray *DataArray;
	UITableView *tblView;
	UITextField *txtField;
	UITextField *txtTitle;
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL imageBool;
	FMDatabase *database1;
	
	NSString *title_string_File;
	NSInteger *id_int_File;
	NSString *imagename_string_File;
	UIImageView *imageview;
	UIButton *btnview;
	UIButton *btncancel;
	UIImageView *imagePhotoView;
	UITextView *txtview;
	AVAudioPlayer *audioPlayer;
	MPMoviePlayerController *videoPlayer;
	UIImageView *topimageview;
	UILabel *lbltitle;
	BOOL tblEditBool;
	UIButton *btnpause;
	UIWebView *webview;
	UIView *pdfview;
	UIActivityIndicatorView *activityIndicator;
	
	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
    BOOL PlaypauseBool;
}
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) IBOutlet UITextField *txtField;
@property(nonatomic,retain) IBOutlet UITextField *txtTitle;

@property(nonatomic,retain) NSString *title_string_File;
@property(nonatomic,assign) NSInteger *id_int_File;
@property(nonatomic,retain) NSString *imagename_string_File;
@property(nonatomic,retain) IBOutlet  UIImageView *imageview;
@property(nonatomic,retain) IBOutlet  UIButton *btnview;
@property(nonatomic,retain) IBOutlet  UIImageView *imagePhotoView;
@property(nonatomic,retain) IBOutlet  UIButton *btncancel;
@property(nonatomic,retain) IBOutlet  UITextView *txtview;
@property(nonatomic,retain) IBOutlet  UIImageView *topimageview;
@property(nonatomic,retain) IBOutlet  UILabel *lbltitle;
@property(nonatomic,retain) IBOutlet  UIButton *btnpause;
@property(nonatomic,retain) IBOutlet  UIWebView *webview;
@property(nonatomic,retain) IBOutlet  UIView *pdfview;
@property(nonatomic,retain) IBOutlet  UIActivityIndicatorView *activityIndicator;

@property(nonatomic,retain) IBOutlet UIImageView *bottom_imageview;
@property(nonatomic,retain) IBOutlet UIButton *btn_Forward;
@property(nonatomic,retain) IBOutlet UIButton *btn_delete;

@property(nonatomic,assign) NSInteger *archived_int;
@property(nonatomic,retain) IBOutlet UIButton *btn_Archive;
-(IBAction)Done;
-(IBAction)Back;
-(void)FetchPathData;
-(void)InsertFile;
-(void)UpdateFile ;
-(void)FetchMaxOrderNo;
-(IBAction)viewClick;
-(IBAction)cancel;
-(IBAction)pause;
-(IBAction)PDFBack;

-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;

-(void)displayComposerSheet;
@end
