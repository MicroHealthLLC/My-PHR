//
//  MemberDetailViewController.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FamilyHealthRecordAppDelegate;
@interface MemberDetailViewController : UIViewController <UITabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate>{

	UITableView *tblView;
	NSMutableArray *HistoryArray;
	UILabel *lbltop;
	NSString *getFnameString;
	UIBarButtonItem *leftBarButton;
	UIBarButtonItem *rightBarButton;
	BOOL EditBool;
	BOOL AddBool;
	BOOL BackBool;
	BOOL FetchBool;
	UIButton *customButton;
	int buttontag;
	FamilyHealthRecordAppDelegate *appDelegate;
	
}
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) IBOutlet UILabel *lbltop;
@property(nonatomic,retain) NSString *getFnameString;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *leftBarButton;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *rightBarButton;
@property(nonatomic,retain) FamilyHealthRecordAppDelegate *appDelegate;
-(IBAction)Back;
-(IBAction)Edit;
-(void)getModuleData;
@end
