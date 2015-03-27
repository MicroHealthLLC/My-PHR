//
//  DrawingViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "ColorPickerViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import<MessageUI/MFMessageComposeViewController.h>

@class FamilyHealthRecordAppDelegate;
@interface DrawingViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,ColorPickerViewControllerDelegate,UIActionSheetDelegate>{

	UILabel *lbl_title;
	UIBarButtonItem *leftbutton;
	UIBarButtonItem *rightbutton;
	UITextField *txtTitle;
	
	UIImageView *drawImage;
	
    int mouseMoved;
    BOOL mouseSwiped;
    CGPoint lastPoint;
    NSMutableArray *arrimageData;
    IBOutlet UISegmentedControl *segment;
    int currutIndex;
    int insertIndex;
    BOOL undoredo;
    CGFloat eraserValue;
    CGFloat penValue;
	//NSArray *paths;
//	NSString *documentsDirectory;
	FamilyHealthRecordAppDelegate *appDelegate;
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL imageBool;
	FMDatabase *database1;

	
	NSString *title_string_Drawing;
	NSInteger *id_int_Drawing;
	NSString *imagename_string_Drawing;
	
	UIButton *btnPen;
	UIButton *btnEraser;
	UIButton *btnColor;
	 IBOutlet UIView *colorSwatch;

	UIImageView *bottom_imageview;
	UIButton *btn_Forward;
	UIButton *btn_delete;
	
	NSInteger *archived_int;
	BOOL Action_Bool;
	UIButton *btn_Archive;
	UISlider *sliderVIew1;
    
    
    UIImageView *imageview1;
    UIImageView *imageview2;
    UIImageView *imageview3;
    UIImageView *imageview4;
    UIImageView *imageview5;
	
}
@property(nonatomic,retain) IBOutlet UILabel *lbl_title;
@property (readwrite,nonatomic,retain) IBOutlet UIView *colorSwatch;

@property(nonatomic,retain) IBOutlet UIButton *btnPen;
@property(nonatomic,retain) IBOutlet UIButton *btnEraser;
@property(nonatomic,retain) IBOutlet UIButton *btnColor;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftbutton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightbutton;
@property(nonatomic,retain) IBOutlet UITextField *txtTitle;

@property (retain, nonatomic) IBOutlet UIButton *btnUndo;
@property (retain, nonatomic) IBOutlet UIButton *btnRedo;
- (IBAction)redo:(id)sender;
- (IBAction)undo:(id)sender;
@property (retain, nonatomic) IBOutlet UISlider *sliderVIew;
@property (retain, nonatomic) IBOutlet UISlider *sliderVIew1;
@property (retain, nonatomic) IBOutlet UIView *slide;
- (IBAction)segmentClick:(id)sender;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;

@property(nonatomic,retain) NSString *title_string_Drawing;
@property(nonatomic,assign) NSInteger *id_int_Drawing;
@property(nonatomic,retain) NSString *imagename_string_Drawing;

@property(nonatomic,retain) IBOutlet UIImageView *bottom_imageview;
@property(nonatomic,retain) IBOutlet UIButton *btn_Forward;
@property(nonatomic,retain) IBOutlet UIButton *btn_delete;

@property(nonatomic,assign) NSInteger *archived_int;
@property(nonatomic,retain) IBOutlet UIButton *btn_Archive;

@property(nonatomic,retain) IBOutlet UIImageView *imageview1;
@property(nonatomic,retain) IBOutlet UIImageView *imageview2;
@property(nonatomic,retain) IBOutlet UIImageView *imageview3;
@property(nonatomic,retain) IBOutlet UIImageView *imageview4;
@property(nonatomic,retain) IBOutlet UIImageView *imageview5;

-(IBAction)Done;
-(IBAction)Back;
-(void)InsertDrawing;
-(void)UpdateDrawing;
-(void)FetchMaxOrderNo;

-(IBAction)PenClick;
-(IBAction)EraserClick;
-(IBAction)ColorClick;
-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString;
-(void)email:(NSString *)subject toString:(NSString *)toString;
-(IBAction)Forward_Email;
-(IBAction)delete_Email;


-(void)displayComposerSheet;
@end
