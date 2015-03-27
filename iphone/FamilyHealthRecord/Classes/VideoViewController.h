//
//  VideoViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import"FMDatabase.h"
#import "sqlite3.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVBase.h>
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>

@class FamilyHealthRecordAppDelegate;
@interface VideoViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,AVAsynchronousKeyValueLoading>
{
UILabel *lbl_title;
    NSMutableArray *recordArray;
	NSMutableArray *recordPathArray;
    
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	UIButton *playButton;
	UIButton *recordButton;
	UIButton *stopButton;
	
	UILabel *lblRecord;
	UILabel *lblPlay;
	UILabel *lblStop;
	UITextField *txtTitle;
	UIImagePickerController *picker;
	NSData *sounds;
	
	MPMoviePlayerController *videoPlayer;
	
	NSFileManager *manager;
	NSArray *fileList;
	
	FMDatabase *database1;
	FamilyHealthRecordAppDelegate *appDelegate;
	sqlite3 *database;
	sqlite3_stmt *statement;
	
    
	NSString *title_string_video;
	NSInteger *id_int_video;
	NSString *imagename_string_video;
	BOOL imageBool;
	UIImage *logoimage;
	
	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
}
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;
@property (retain, nonatomic) IBOutlet UIImageView *tempImageview;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;

@property(nonatomic,retain) IBOutlet UILabel *lblRecord;
@property(nonatomic,retain) IBOutlet UILabel *lblPlay;
@property(nonatomic,retain) IBOutlet UILabel *lblStop;

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

@property(nonatomic,retain) IBOutlet UITextField *txtTitle;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;

@property(nonatomic,retain) NSString *title_string_video;
@property(nonatomic,assign) NSInteger *id_int_video;
@property(nonatomic,retain) NSString *imagename_string_video;

@property(nonatomic,retain) IBOutlet UIImageView *bottom_imageview;
@property(nonatomic,retain) IBOutlet UIButton *btn_Forward;
@property(nonatomic,retain) IBOutlet UIButton *btn_delete;

@property(nonatomic,assign) NSInteger *archived_int;
@property(nonatomic,retain) IBOutlet UIButton *btn_Archive;
-(IBAction)Done;
-(IBAction)Back;
-(IBAction) recordAudio;
-(IBAction) playAudio;
-(IBAction) stop;
-(IBAction)playVideo:(id)sender;
-(void)FetchMaxOrderNo;
-(void)FetchVideo;
-(void)InsertVideo;
-(void)UpdateVideo;
-(void)videoPlayerFinish;
-(void)exitMoviePlayer;

-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;

-(void)displayComposerSheet;
@end
