//
//  MemberFunctionViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyHealthRecordAppDelegate;
@interface MemberFunctionViewController : UIViewController<UIApplicationDelegate,UITabBarControllerDelegate,UIImagePickerControllerDelegate> {

	NSString *getModulename;
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	UIImageView *imageview;
	
	UIScrollView *scrollview;
	NSMutableArray *labelNameArray;
	NSMutableArray *labelNameArray1;
	
	NSMutableArray *imageArray;
	NSArray *fileList;
	UIButton *btn;
	FamilyHealthRecordAppDelegate *appDelegate;
	UIButton *deletebtn;
	UIButton *archivebtn;
	UIButton *archiveLabel;
	
	BOOL BarbuttonBool;
	BOOL NextbuttonBool;
    BOOL ArchiveBool;
	
	UIButton *btnPhoto;
	UIButton *btntext;
	UIButton *btnAudio;
	UIButton *btnFile;
	UIButton *btnVideo;
	UIButton *btnDrawing;
	
	UILabel *lblPhoto;
	UILabel *lbltext;
	UILabel *lblAudio;
	UILabel *lblFile;
	UILabel *lblVideo;
	UILabel *lblDrawing;
}
@property(nonatomic,retain) NSString *getModulename;
@property(nonatomic,retain) IBOutlet UILabel *lblTabbar; 
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) IBOutlet UIImageView *imageview;

@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;

@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;

@property(nonatomic,retain) IBOutlet  UIButton *btnPhoto;
@property(nonatomic,retain) IBOutlet  UIButton *btntext;
@property(nonatomic,retain) IBOutlet  UIButton *btnAudio;
@property(nonatomic,retain) IBOutlet  UIButton *btnFile;
@property(nonatomic,retain) IBOutlet  UIButton *btnVideo;
@property(nonatomic,retain) IBOutlet  UIButton *btnDrawing;

@property(nonatomic,retain) IBOutlet  UILabel *lblPhoto;
@property(nonatomic,retain) IBOutlet  UILabel *lbltext;
@property(nonatomic,retain) IBOutlet  UILabel *lblAudio;
@property(nonatomic,retain) IBOutlet  UILabel *lblFile;
@property(nonatomic,retain) IBOutlet  UILabel *lblVideo;
@property(nonatomic,retain) IBOutlet  UILabel *lblDrawing;
-(IBAction)Edit;
-(IBAction)Back;
-(IBAction)Photo;
-(IBAction)Text;
-(IBAction)Audio;
-(IBAction)File;
-(IBAction)Video;
-(IBAction)Drawing;
-(void)FetchData;
-(void)createPlaylistScrollView;
-(void)Editmethod;
-(void)archivebtnclick:(id)sender;
@end
