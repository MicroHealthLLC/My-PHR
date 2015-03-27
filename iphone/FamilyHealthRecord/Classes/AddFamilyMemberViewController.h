//
//  AddFamilyMemberViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 04/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "FMDatabase.h"

@interface AddFamilyMemberViewController : UIViewController<UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate> {
	UIImageView *imageview1;
	UIImageView *imageview2;
	UITextField *txtfname;
	UITextField *txtlname;
	
	sqlite3 *database;
	sqlite3_stmt *statement;
	BOOL imageBool;
	FMDatabase *database1;
	
	//NSString *databasePath;
	//NSString *documentsDir;
	//NSString *OrderNoString;
}
@property(nonatomic,retain) IBOutlet UIImageView *imageview1;
@property(nonatomic,retain) IBOutlet UIImageView *imageview2;
@property(nonatomic,retain) IBOutlet UITextField *txtfname;
@property(nonatomic,retain) IBOutlet UITextField *txtlname;

-(void)FetchMaxOrderNo;
-(IBAction)Done;
-(IBAction)Cancel;
@end
