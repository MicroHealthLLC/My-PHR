//
//  AudioViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>
@class FamilyHealthRecordAppDelegate;
@interface AudioViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate> 
{
   UILabel *lbl_title;
	AVAudioRecorder *audioRecorder;
	AVAudioPlayer *audioPlayer;
	
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	
	UIButton *playButton;
	UIButton *recordButton;
	UIButton *stopButton;
	UITextField *txtTitle;
	UILabel *lblRecord;
	UILabel *lblPlay;
	UILabel *lblStop;
	
	FMDatabase *database1;
	FamilyHealthRecordAppDelegate *appDelegate;
	sqlite3 *database;
	sqlite3_stmt *statement;
	NSMutableData *sounds;
	NSArray *fileList;
	NSFileManager *manager;
	BOOL imageBool;
	
	NSString *title_string_audio;
	NSInteger *id_int_audio;
	NSString *imagename_string_audio;
	NSMutableArray *recordArray;
	NSMutableArray *recordPathArray;
	
	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
    
}
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;

@property(nonatomic,retain) IBOutlet UITextField *txtTitle;

@property(nonatomic,retain) IBOutlet UILabel *lblRecord;
@property(nonatomic,retain) IBOutlet UILabel *lblPlay;
@property(nonatomic,retain) IBOutlet UILabel *lblStop;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;

@property(nonatomic,retain) NSString *title_string_audio;
@property(nonatomic,assign) NSInteger *id_int_audio;
@property(nonatomic,retain) NSString *imagename_string_audio;

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
-(void)FetchAudio;
-(void)InsertAudio;
-(void)UpdateAudio;

-(void)recordvoice;

-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;

-(void)displayComposerSheet;
@end
