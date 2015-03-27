//
//  UpdateUserViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 09/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyHealthRecordAppDelegate;
@interface UpdateUserViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{

	UIImageView *imageview1;
	UIImageView *imageview2;
	UITextField *txtfname;
	UITextField *txtlname;
	
	NSString *getFnameString;
	NSString *getLnameString;
	NSString *getImageString;
	NSInteger *getFamilyID;
	BOOL imageBool;
	FamilyHealthRecordAppDelegate *appDelegate;
	
}
@property(nonatomic,retain) IBOutlet UIImageView *imageview1;
@property(nonatomic,retain) IBOutlet UIImageView *imageview2;
@property(nonatomic,retain) IBOutlet UITextField *txtfname;
@property(nonatomic,retain) IBOutlet UITextField *txtlname;

@property(nonatomic,retain) IBOutlet NSString *getFnameString;
@property(nonatomic,retain) IBOutlet NSString *getLnameString;
@property(nonatomic,retain) IBOutlet NSString *getImageString;
@property(nonatomic,assign) IBOutlet NSInteger *getFamilyID;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;
-(IBAction)Back;
-(IBAction)Done;

@end
