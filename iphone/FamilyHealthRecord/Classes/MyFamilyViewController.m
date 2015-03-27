//
//  MyFamilyViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 04/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyFamilyViewController.h"
#import "AddFamilyMemberViewController.h"
#import"FamilyHealthRecordAppDelegate.h"
#import"UserDetail.h"
#import "MemberDetailViewController.h"
#import "FMDatabase.h"
#import "MedicalHistoryViewController.h"
#import "UpdateUserViewController.h"
#import "SettingViewController.h"

@implementation MyFamilyViewController
@synthesize btnSetting,imageview1,imageview2,scrollview,leftbutton,rightbutton;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"switch"]) {
        //[self PassCode];
		
    } 
    else
    {
        [self PassCode]; 
    }
	imageview1.hidden=YES;
	imageview2.hidden=YES;
    //	btnSetting.hidden=YES;
	fileList=[[NSArray alloc]init];
	appDelegate=[[UIApplication sharedApplication]delegate];
	leftbutton.title=@"Edit";

    [super viewDidLoad];
}

-(void)PassCode
{
	KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.delegate = self;
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"setpassword"] isEqualToString:@"YES"]) 
    {
		passcodeController.strInstruction=@"Create New Password";
		//passcodeController.titleLabel.text=@"";
    }
	
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:passcodeController];
    [self.navigationController presentModalViewController:passcodeNavigationController animated:YES];
    [passcodeNavigationController release];
    [passcodeController release];
}
#pragma mark - KVPasscodeViewControllerDelegate 
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode 
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"setpassword"] isEqualToString:@"YES"]) 
    {
        if ([passCode isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"setpasswordValue"]]) {
            [controller dismissModalViewControllerAnimated:YES];
        } 
		//        else if ([passCode isEqualToString:@"0000"]) {
		//            controller.instructionLabel.text = NSLocalizedString(@"Please confirm passcode.", @"");
		//            [controller resetWithAnimation:KVPasscodeAnimationStyleConfirm];
		//        } 
        else {
            controller.instructionLabel.textColor = [UIColor redColor];
            controller.instructionLabel.text = [NSString stringWithFormat:@"Failed Password attempt"];
            [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
            
        }
		
    }
    else
    {        
        
        if (strNewPass.length==0) {
            strNewPass = [[NSString stringWithFormat:@"%@",passCode] retain];
            [controller resetWithAnimation:KVPasscodeAnimationStyleConfirm];
            controller.instructionLabel.text =@"Re-Type Password";
			//KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
//			passcodeController.delegate = self;
//			passcodeController.titleLabel.text=@"";
        }
        else if([strNewPass isEqualToString:passCode])
        {
            [controller dismissModalViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"setpassword"];
            [[NSUserDefaults standardUserDefaults] setValue:passCode forKey:@"setpasswordValue"];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"switch"];
        }
        else
        {
            strNewPass = @"";
            controller.instructionLabel.text =@"Create New Password";   
            [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];            
        }
        
        
    }
	//    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"setpassword"]; 
}

-(IBAction)Setting
{
	SettingViewController *viewcontroller=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}
-(IBAction)Add
{
	AddFamilyMemberViewController *viewcontroller=[[AddFamilyMemberViewController alloc]initWithNibName:@"AddFamilyMemberViewController" bundle:nil];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];

}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	for (UIView *view2 in scrollview.subviews) {
		[view2 removeFromSuperview ];
	}
	[self createPlaylistScrollView];
		
	if([appDelegate.UpdateString isEqualToString:@"Add"])
	{
		[self Editmethod];
		appDelegate.UpdateString=@"";
	}
	//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit:)];
}

-(void)FetchData
{
	labelNameArray=[[NSMutableArray alloc] init];
	//imageArray=[[NSMutableArray alloc] init];
	sqlite3 *database;
    sqlite3_stmt *statement;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
			const char *sqlStatement = "select family_id, f_name,l_name,image,ordernum from tb_FamilyMember";
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
			//sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
				UserDetail *objUserDetail = [[UserDetail alloc] init];
			
				objUserDetail.int_FamilyId=(int)sqlite3_column_int(statement,0);
				objUserDetail.str_f_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                objUserDetail.str_l_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
				objUserDetail.str_Imagename= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                objUserDetail.int_OrderNumber=(int)sqlite3_column_int(statement,4);
				
				NSLog(@"FnameString::%@",objUserDetail.str_f_name);
				//NSLog(@"LnameString::%@",LnameString);
				[labelNameArray addObject:objUserDetail];
			}
			
           //NSLog(@"labelNameArray::%@",objUserDetail.str_f_name);
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
		sqlite3_close(database);
	}
	
	
}
-(void)createPlaylistScrollView
{
	[self FetchData];
	for (deletebtn in scrollview.subviews) {
		[deletebtn removeFromSuperview ];
	}
    if(labelNameArray.count==0)
    {
        imageview1.hidden=NO;
        imageview2.hidden=NO;
		NSArray *Path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
		NSString *documentsDir=[Path objectAtIndex:0];
		
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.VideoFile"];
		NSString *myFilePath = [documentsDir stringByAppendingPathComponent:@"/.LogoImage"];
		NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:@"/.AudioFile"];
		
		NSFileManager  *manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
		[manager removeItemAtPath:myFilePath error:NULL];
		[manager removeItemAtPath:myFilePath2 error:NULL];
    }
    else
    {  
        imageview1.hidden=YES;
        imageview2.hidden=YES;
    }
    int tepint =labelNameArray.count;
    float rowCount= tepint/3.0;
    int temp =ceilf(rowCount);
    scrollview.contentSize =CGSizeMake(320, 120*temp);
    int incressYposition=0;
    int k=0;
    for (int i=0; i<labelNameArray.count; i++) 
    {
	 UserDetail *objUserDetail=[labelNameArray objectAtIndex:i];
        UILabel *lbltitle= [[[UILabel alloc]initWithFrame:CGRectMake(110*k, 90+incressYposition, 100, 30)] autorelease];
		//lbltitle.frame=CGRectMake(110*k, 90+incressYposition, 100, 30);
		lbltitle.textAlignment = UITextAlignmentCenter;
        lbltitle.numberOfLines = 0;
        lbltitle.backgroundColor=[UIColor clearColor];
        lbltitle.font =[UIFont systemFontOfSize:12];
        lbltitle.textColor = [UIColor blackColor];
        lbltitle.text =objUserDetail.str_f_name;
        UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(110*k, 0+incressYposition, 100, 100)];
		//UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(110*k, 0+incressYposition, 75, 75)];

		imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
        imgPhoto.clipsToBounds = YES;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//NSString *imageString=[NSString stringWithFormat:@"/ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[imageArray objectAtIndex:i]];
		NSString *imageString=[NSString stringWithFormat:@"/.MyFolder"];
        
        NSString *imagenameString=[NSString stringWithFormat:@"%@/%@.png",imageString,objUserDetail.str_Imagename];
        //[imageString stringByAppendingString:imagenameString];
        //NSLog(@"ImageString::%@",imageString);
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagenameString];
        
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        imgPhoto.image = img;
        
        [scrollview addSubview:imgPhoto];
        //            imgPhoto.tag = IMAGE_VIEW_TAG;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(110*k, 0+incressYposition, 100, 100);
     [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag=i;
        
        k++;
        if (k==3) 
        {
            k=0;
            incressYposition=incressYposition+120;
        }
		//imgPhoto.image=[UIImage imageNamed:@"accdbico.png"];
        [scrollview addSubview:imgPhoto];
        [scrollview addSubview:lbltitle];
        [scrollview addSubview:btn];
		
  }
    
}
-(IBAction)Edit
{
	if(!BarbuttonBool)
	{
		[self Editmethod];
		BarbuttonBool=YES;
		leftbutton.title=@"Done";
		rightbutton.enabled=NO;
		NextbuttonBool=YES;
        
        btnSetting.enabled=NO;
	}
	else
	{
	leftbutton.title=@"Edit";
		[self createPlaylistScrollView];
		BarbuttonBool=NO;
		rightbutton.enabled=YES;
		NextbuttonBool=NO;
        btnSetting.enabled=YES;
	}
	
	 
}

-(void)Editmethod
{
	//leftbutton.title=@"Done";
	
	int k=0;
	int incressYposition=0;
	for (int i=0; i<labelNameArray.count; i++) 
    {
		deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deletebtn.frame = CGRectMake(110*k, 0+incressYposition, 27, 27);
		[deletebtn setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
		[deletebtn addTarget:self action:@selector(deletebtnclick:) forControlEvents:UIControlEventTouchUpInside];
		
		deletebtn.tag=i;
		k++;
        if (k==3) 
        {
            k=0;
            incressYposition=incressYposition+120;
        }
		[scrollview addSubview:deletebtn];
	}
}
-(void)btnClick:(id)sender
{
	if(NextbuttonBool==YES)
	{
	UpdateUserViewController *viewcontroller=[[UpdateUserViewController alloc]initWithNibName:@"UpdateUserViewController" bundle:nil];
	
		UserDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
		viewcontroller.getFnameString=objUserDetail.str_f_name;
		viewcontroller.getLnameString=objUserDetail.str_l_name;
		viewcontroller.getImageString=objUserDetail.str_Imagename;
		viewcontroller.getFamilyID= objUserDetail.int_FamilyId;
		//viewcontroller.appDelegate.FamMember_String=objUserDetail.str_f_name;
		[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
	}
	else if(NextbuttonBool==NO)
	{
		MemberDetailViewController *viewcontroller=[[MemberDetailViewController alloc]initWithNibName:@"MemberDetailViewController" bundle:nil];
		UserDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
		viewcontroller.getFnameString=objUserDetail.str_f_name;
		appDelegate.FamilyID_String=[NSString stringWithFormat:@"%d", objUserDetail.int_FamilyId];

        [self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
}
-(void)deletebtnclick:(id)sender
{
	UserDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];    
    [database1 open];
	NSString *temp= [NSString stringWithFormat:@"delete from tb_FamilyMember where family_id=%i",objUserDetail.int_FamilyId];
	NSString *temp1= [NSString stringWithFormat:@"delete from MedicalHistory where family_id=%i",objUserDetail.int_FamilyId];

	[database1 executeUpdate:temp];
	[database1 executeUpdate:temp1];
	[database1 close];
	NSString *imageString=[NSString stringWithFormat:@"/.MyFolder/%@.png",objUserDetail.str_Imagename];
	NSLog(@"imagenamestring::%@",imageString);
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
	
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
    
	
    NSString *ModuleString=[NSString stringWithFormat:@"/.ModuleImage/"];

    NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:ModuleString];
    fileListArray=[[NSArray alloc]init];
    fileListArray= [manager contentsOfDirectoryAtPath:myFilePath2 error:nil];
    //fileListArray= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:myFilePath2 error:nil];
    NSString *idString=[NSString stringWithFormat:@"SELF beginsWith[cd] '%i_'",objUserDetail.int_FamilyId];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:idString];   
   // NSError *error;
    NSArray *letters = [fileListArray filteredArrayUsingPredicate:predicate];
    for (NSString *tempStr in letters) {
        
        NSString *temppathstr = [myFilePath2 stringByAppendingPathComponent:tempStr];
        [manager removeItemAtPath:temppathstr error:nil];
       
    }
    NSLog(@"letters::%@",letters);
    
	//[imageArray removeObjectAtIndex:[sender tag]];
	[labelNameArray removeObjectAtIndex:[sender tag]];
	NSLog(@"labelArraycount::%i",[labelNameArray count]);
	
	//[self Editmethod];
	//[scrollview reloadInputViews];
	for (UIView *view2 in scrollview.subviews) {
		[view2 removeFromSuperview ];
	}
	[self createPlaylistScrollView];
	[self Editmethod];
    imageview1.hidden=YES;
    imageview2.hidden=YES;
	//[self.scrollview relo
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
