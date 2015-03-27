//
//  MemberFunctionViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "MemberFunctionViewController.h"
#import"TextViewController.h"
#import "AudioViewController.h"
#import "VideoViewController.h"
#import "DrawingViewController.h"
#import "PhotoViewController.h"
#import "MemberFunctionDetail.h"
#import "FamilyHealthRecordAppDelegate.h"
#import "FMDatabase.h"
#import "FileViewController.h"

@implementation MemberFunctionViewController
@synthesize getModulename,lblTabbar,leftbutton,rightbutton;
@synthesize imageview,scrollview,appDelegate;
@synthesize btnPhoto,btntext,btnAudio,btnFile,btnVideo,btnDrawing;
@synthesize lblPhoto,lbltext,lblAudio,lblFile,lblVideo,lblDrawing; 

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
- (void)viewDidLoad {
    [super viewDidLoad];
	lblTabbar.text=getModulename;
	leftbutton.title=@"Back";
	rightbutton.title=@"Edit";
	appDelegate=[[UIApplication sharedApplication]delegate];
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(Edit:)];
	//[self.navigationItem setLeftBarButtonItem:addButton];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(BarbuttonBool==YES)
	{
		[self Editmethod];
	}
	else
	{
		for (UIView *view2 in scrollview.subviews) {
			[view2 removeFromSuperview ];
		}
		[self createPlaylistScrollView];
	}
	//[self FetchData];
}
-(IBAction)Edit
{
	if(!BarbuttonBool)
	{
        ArchiveBool=YES;
        [self createPlaylistScrollView];
		[self Editmethod];
		BarbuttonBool=YES;
		rightbutton.title=@"Done";
		leftbutton.enabled=NO;
		NextbuttonBool=YES;
		btnPhoto.enabled=NO;
		btnDrawing.enabled=NO;
		btnFile.enabled=NO;
		btntext.enabled=NO;
		btnVideo.enabled=NO;
		btnAudio.enabled=NO;
		
		lblPhoto.enabled=NO;
		lblDrawing.enabled=NO;
		lblFile.enabled=NO;
		lbltext.enabled=NO;
		lblVideo.enabled=NO;
		lblAudio.enabled=NO;
       
		
	}
	else
	{
		rightbutton.title=@"Edit";
        ArchiveBool=NO;
		[self createPlaylistScrollView];
		BarbuttonBool=NO;
		leftbutton.enabled=YES;
		NextbuttonBool=NO;
		
		btnPhoto.enabled=YES;
		btnDrawing.enabled=YES;
		btnFile.enabled=YES;
		btntext.enabled=YES;
		btnVideo.enabled=YES;
		btnAudio.enabled=YES;
		
		lblPhoto.enabled=YES;
		lblDrawing.enabled=YES;
		lblFile.enabled=YES;
		lbltext.enabled=YES;
		lblVideo.enabled=YES;
		lblAudio.enabled=YES;
	}
}
-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)Photo
{
	PhotoViewController *viewcontroller=[[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
	
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) 
	{ 
		return; 
	}
	switch (buttonIndex) {
		case 0:
		{
			NSLog(@"Camera");
			UIImagePickerController *picker=[[UIImagePickerController alloc] init];
			picker.delegate=self;
			picker.sourceType=UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:picker animated:YES];
			[picker release];
			break;
		}
		case 1:
		{
			NSLog(@"Gallery");
			UIImagePickerController *picker=[[UIImagePickerController alloc] init];
			picker.delegate=self;
			picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		    picker.allowsImageEditing=YES;
			[self presentModalViewController:picker animated:YES];
			[picker release];
			break;
		}
			
	}
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	imageview.image=[info objectForKey:UIImagePickerControllerOriginalImage];
}
-(IBAction)Text
{
	
	TextViewController *viewcontroller=[[TextViewController alloc]initWithNibName:@"TextViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
-(IBAction)Audio
{
	AudioViewController *viewcontroller=[[AudioViewController alloc]initWithNibName:@"AudioViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
-(IBAction)File
{
	FileViewController *viewcontroller=[[FileViewController alloc]initWithNibName:@"FileViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
-(IBAction)Video
{
	VideoViewController *viewcontroller=[[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
-(IBAction)Drawing
{
	DrawingViewController *viewcontroller=[[DrawingViewController alloc]initWithNibName:@"DrawingViewController" bundle:nil];
    appDelegate.Str_UpdateFunction=@"Sub";
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
#pragma mark FetchTableData
-(void)FetchData
{
	labelNameArray=[[NSMutableArray alloc] init];
	imageArray=[[NSMutableArray alloc] init];
	NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentDir=[documentPath objectAtIndex:0];
	NSString *databasePath=[documentDir  stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
	FMDatabase *database=[FMDatabase databaseWithPath:databasePath];
	[database open];
	
		//HistoryArray=[[NSMutableArray alloc]init];
	NSString *executeString=[NSString stringWithFormat:@"select ordernum,id,archive,module_id,created_date,modify_date,title,data,medicaldatatype_id From MedicalHistory where family_id=%@ and module_id=%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		FMResultSet *results = [database executeQuery:executeString];	
		
		while([results next]) {
			MemberFunctionDetail  *objMemberdetails=[[MemberFunctionDetail alloc]init];
			objMemberdetails.str_title=[results stringForColumn:@"title"];
			objMemberdetails.str_data=[results stringForColumn:@"data"];
			objMemberdetails.str_created_date=[results stringForColumn:@"created_date"];
			objMemberdetails.str_modify_date=[results stringForColumn:@"modify_date"];
			
			objMemberdetails.int_medicaldatatype_id=[results intForColumn:@"medicaldatatype_id"];
			objMemberdetails.int_id=[results intForColumn:@"id"];
			objMemberdetails.int_ordernum=[results intForColumn:@"ordernum"];
            objMemberdetails.int_archive=[results intForColumn:@"archive"];
			objMemberdetails.int_module_id=[results intForColumn:@"module_id"];
			
			
			[labelNameArray addObject:objMemberdetails];
		   // [labelNameArray addObject:objMemberdetails.str_title];
			NSLog(@"str_title::%@",	objMemberdetails.str_title);
			NSLog(@"str_data::%@",	objMemberdetails.str_data);
			NSLog(@"str_created_date::%@",	objMemberdetails.str_created_date);
			NSLog(@"str_modify_date::%@",	objMemberdetails.str_modify_date);
			NSLog(@"int_medicaldatatype_id::%d",	objMemberdetails.int_medicaldatatype_id);
			NSLog(@"int_id::%d",	objMemberdetails.int_id);
			NSLog(@"int_ordernum::%d",	objMemberdetails.int_ordernum);
            NSLog(@"objMemberdetails.int_archive::%d",	objMemberdetails.int_archive);
			   NSLog(@"objMemberdetails.int_module_id::%d",	objMemberdetails.int_module_id);
		}
}
-(void)createPlaylistScrollView
{
	[self FetchData];
    int tepint =labelNameArray.count;
    float rowCount= tepint/3.0;
    int temp =ceilf(rowCount);
    scrollview.contentSize =CGSizeMake(320, 120*temp);
    int incressYposition=0;
    int k=0;
	for (deletebtn in scrollview.subviews) {
	 [deletebtn removeFromSuperview ];
	 }
    for (int i=0; i<labelNameArray.count; i++) 
    {
		UITextView *txtView;
		MemberFunctionDetail *objUserDetail=[labelNameArray objectAtIndex:i];
        UILabel *lbltitle= [[[UILabel alloc]initWithFrame:CGRectMake(110*k, 90+incressYposition, 100, 30)] autorelease];
		//lbltitle.frame=CGRectMake(110*k, 90+incressYposition, 100, 30);
		lbltitle.textAlignment = UITextAlignmentCenter;
        lbltitle.numberOfLines = 0;
        lbltitle.backgroundColor=[UIColor clearColor];
        lbltitle.font =[UIFont systemFontOfSize:12];
        lbltitle.textColor = [UIColor blackColor];
        lbltitle.text =objUserDetail.str_title;
        UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(110*k, 0+incressYposition, 100, 100)];
		//UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(110*k, 0+incressYposition, 75, 75)];
		
		imgPhoto.contentMode = UIViewContentModeScaleAspectFill;
        imgPhoto.clipsToBounds = YES;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//NSString *imageString=[NSString stringWithFormat:@"/ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[imageArray objectAtIndex:i]];
		NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];

		
		if(objUserDetail.int_medicaldatatype_id==3)
		{
			NSString *imagenameString=[NSString stringWithFormat:@"%@/%@.png",imageString,objUserDetail.str_data];
			//[imageString stringByAppendingString:imagenameString];
			//NSLog(@"ImageString::%@",imageString);
			NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagenameString];
			
			UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
			imgPhoto.image = img;
			 [scrollview addSubview:imgPhoto];
		}
		if(objUserDetail.int_medicaldatatype_id==1)
		{
			
			UIImage *img=[UIImage imageNamed:@"defaulttxtbck1.png"];
			imgPhoto.image = img;
			txtView=[[UITextView alloc]initWithFrame:CGRectMake(110*k, 5+incressYposition, 90, 90)];
			txtView.backgroundColor=[UIColor clearColor];
			txtView.textColor=[UIColor blackColor];
			//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			//NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSString *txtString=[NSString stringWithFormat:@"%@/%@.txt",imageString,objUserDetail.str_data];

			NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:txtString];
			
			NSString *myString = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
			NSLog(@"txtString::%@",txtString);
			NSLog(@"myString::%@",myString);
			txtView.text=myString;
			 [scrollview addSubview:imgPhoto];
				[scrollview addSubview:txtView];
		}
		
		if(objUserDetail.int_medicaldatatype_id==2)
		{
			UIImage *img = [UIImage imageNamed:@"defaultaudioimg.png"];
			imgPhoto.image = img;
			[scrollview addSubview:imgPhoto];
		}
		if(objUserDetail.int_medicaldatatype_id==6)
		{
			
			
			
			NSString *imagenameString=[NSString stringWithFormat:@"%@/%@.png",imageString,objUserDetail.str_data];
			
			NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagenameString];
			
			UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
			imgPhoto.image = img;
			[scrollview addSubview:imgPhoto];
			
		}
		if(objUserDetail.int_medicaldatatype_id==5)
		{
			NSString *imagenameString=[NSString stringWithFormat:@".LogoImage/%@.png",objUserDetail.str_data];
			
			NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imagenameString];
			
			UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
			imgPhoto.image = img;
			[scrollview addSubview:imgPhoto];
		}
		
		if(objUserDetail.int_medicaldatatype_id==4)
		{
			
			NSString *code = [objUserDetail.str_data substringFromIndex: [objUserDetail.str_data length] - 3];
			NSLog(@"code::%@",code);	
			
			if([objUserDetail.str_data hasSuffix:@".png"])
			   {
			UIImage *img = [UIImage imageNamed:@"pngico.png"];
			imgPhoto.image = img;
			[scrollview addSubview:imgPhoto];
			   }
			else if([objUserDetail.str_data hasSuffix:@".jpeg"])
			{
				UIImage *img = [UIImage imageNamed:@"jpegico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".jpg"])
			{
				UIImage *img = [UIImage imageNamed:@"jpegico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			
			  else if([objUserDetail.str_data hasSuffix:@".txt"])
				  {
					  UIImage *img = [UIImage imageNamed:@"textico.png"];
					  imgPhoto.image = img;
					  [scrollview addSubview:imgPhoto];
				  }
				  else if([objUserDetail.str_data hasSuffix:@".caf"])
					 {
						 UIImage *img = [UIImage imageNamed:@"mp3ico.png"];
						 imgPhoto.image = img;
						 [scrollview addSubview:imgPhoto];
					 }
			         else if([objUserDetail.str_data hasSuffix:@".mp3"])
			           {
			            	UIImage *img = [UIImage imageNamed:@"mp3ico.png"];
                           imgPhoto.image = img;
				            [scrollview addSubview:imgPhoto];
					   }
					 else if([objUserDetail.str_data hasSuffix:@".mp4"])
						{
							UIImage *img = [UIImage imageNamed:@"movico.png"];
							imgPhoto.image = img;
							[scrollview addSubview:imgPhoto];
						}
			else if([objUserDetail.str_data hasSuffix:@".mov"])
			{
				UIImage *img = [UIImage imageNamed:@"movico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".m4v"])
			{
				UIImage *img = [UIImage imageNamed:@"movico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".pdf"])
			{
				UIImage *img = [UIImage imageNamed:@"pdfico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".xls"])
			{
				UIImage *img = [UIImage imageNamed:@"textico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".ppt"])
			{
				UIImage *img = [UIImage imageNamed:@"ppptxico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".pdf"])
			{
				UIImage *img = [UIImage imageNamed:@"pdfico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else if([objUserDetail.str_data hasSuffix:@".rtf"])
			{
				UIImage *img = [UIImage imageNamed:@"textico.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			else
			{
				UIImage *img = [UIImage imageNamed:@"defaultfileimg.png"];
				imgPhoto.image = img;
				[scrollview addSubview:imgPhoto];
			}
			
		}
		
        //            imgPhoto.tag = IMAGE_VIEW_TAG;
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(110*k, 0+incressYposition, 100, 100);
		[btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag=i;
       
        if(ArchiveBool==NO)
        {
       if (objUserDetail.int_archive==1) {
            archiveLabel = [UIButton buttonWithType:UIButtonTypeCustom];
            archiveLabel.frame = CGRectMake(110*k, 75+incressYposition, 100, 25);
            [archiveLabel setBackgroundImage:[UIImage imageNamed:@"blbcka.png"] forState:UIControlStateNormal];
            archiveLabel.lineBreakMode=UILineBreakModeWordWrap;
            [archiveLabel setTitle:@"Archived" forState:UIControlStateNormal];
            [archiveLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
              [scrollview addSubview:archiveLabel];
       }
        }
        
        k++;
        if (k==3) 
        {
            k=0;
            incressYposition=incressYposition+120;
        }
		//imgPhoto.image=[UIImage imageNamed:@"accdbico.png"];
       
        [scrollview addSubview:lbltitle];
        [scrollview addSubview:btn];
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
		MemberFunctionDetail *objUserDetail=[labelNameArray objectAtIndex:i];
		archivebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        archivebtn.frame = CGRectMake(115*k, 35+incressYposition, 65, 35);
		[archivebtn setFont:[UIFont fontWithName:@"Helvetica" size:10]];
		archivebtn.lineBreakMode=UILineBreakModeWordWrap;
        if(objUserDetail.int_archive==0)
        {
		//[archivebtn setImage:[UIImage imageNamed:@"blackbtn.png"] forState:UIControlStateNormal];
			[archivebtn setBackgroundImage:[UIImage imageNamed:@"blackbtn.png"] forState:UIControlStateNormal];
	        [archivebtn setTitle:@"Mark As Archived" forState:UIControlStateNormal];
		}
        else if(objUserDetail.int_archive==1)
        {
        	[archivebtn setBackgroundImage:[UIImage imageNamed:@"greenbtn.png"] forState:UIControlStateNormal];
			[archivebtn setTitle:@"Remove Archived Label" forState:UIControlStateNormal];
			//archivebtn.titleLabel.text=@"MMark As Not Taking";
		}
            [archivebtn addTarget:self action:@selector(archivebtnclick:) forControlEvents:UIControlEventTouchUpInside];
		
		archivebtn.tag=i;
		
		k++;
        if (k==3) 
        {
            k=0;
            incressYposition=incressYposition+120;
        }
		
		[scrollview addSubview:deletebtn];
		[scrollview addSubview:archivebtn];
      
		
        if(objUserDetail.int_module_id==5)
		{
			[archivebtn removeFromSuperview];
			
		}
        
	}
}
-(void)archivebtnclick:(id)sender
{
    MemberFunctionDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];    
    [database1 open];
    NSString *temp;
    if(objUserDetail.int_archive==0)
    {
	temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",objUserDetail.int_id];
    }
    else if(objUserDetail.int_archive==1)
    {
    temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",objUserDetail.int_id];
    }
	[database1 executeUpdate:temp];
	[database1 close];
    for (UIView *view2 in scrollview.subviews) {
		[view2 removeFromSuperview ];
	}
	[self createPlaylistScrollView];
	[self Editmethod];
    //[archiveLabel removeFromSuperview];

}
-(void)deletebtnclick:(id)sender
{
	MemberFunctionDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];    
    [database1 open];
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",objUserDetail.int_id];
	[database1 executeUpdate:temp];
	[database1 close];
	NSString *imageString;
    NSString *LogoString;
	if(objUserDetail.int_medicaldatatype_id==3)
	{
		imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,objUserDetail.str_data];
		NSLog(@"imagenamestring::%@",imageString);
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
		
		NSFileManager  *manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
	}
	if(objUserDetail.int_medicaldatatype_id==1)
	{
		imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.txt",appDelegate.FamilyID_String,appDelegate.ModuleID_String,objUserDetail.str_data];
		NSLog(@"imagenamestring::%@",imageString);
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
		
		NSFileManager  *manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
	}
	if(objUserDetail.int_medicaldatatype_id==2)
	{
		//imageString=[NSString stringWithFormat:@"/ModuleImage/%@_%@/%@.caf",appDelegate.FamilyID_String,appDelegate.ModuleID_String,objUserDetail.str_data];
		
		NSArray *temp =[objUserDetail.str_data  componentsSeparatedByString:@","] ;
        NSMutableArray *recordArray = [[NSMutableArray arrayWithArray:temp] retain];
		NSLog(@"recordArray::%@",recordArray);
		
		for (int i = 0; i < [recordArray count]; i++)
		{	
			
			NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[recordArray objectAtIndex:i]];
			
			NSString *myPathDocs =  [documentsDir stringByAppendingPathComponent:txtString];
			NSLog(@"myFilePath2::%@",myPathDocs);
			[[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:NULL];
		}
	}
	if(objUserDetail.int_medicaldatatype_id==5)
	{
		NSArray *temp =[objUserDetail.str_data  componentsSeparatedByString:@","] ;
        NSMutableArray *recordArray = [[NSMutableArray arrayWithArray:temp] retain];
		NSLog(@"recordArray::%@",recordArray);
		LogoString=[NSString stringWithFormat:@"/.LogoImage/%@.png",objUserDetail.str_data];
NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
		for (int i = 0; i < [recordArray count]; i++)
		{	
			
			NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[recordArray objectAtIndex:i]];
			
			NSString *myPathDocs =  [documentsDir stringByAppendingPathComponent:txtString];
			NSLog(@"myFilePath2::%@",myPathDocs);
			[[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:NULL];
		}        
		
				
		[[NSFileManager defaultManager] removeItemAtPath:myFilePath2 error:NULL];
	}
	if(objUserDetail.int_medicaldatatype_id==6)
	{
		imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,objUserDetail.str_data];
       
		NSLog(@"imagenamestring::%@",imageString);
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
		// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
		
		NSFileManager  *manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
	}
	if(objUserDetail.int_medicaldatatype_id==4)
	{
		imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,objUserDetail.str_data];
		
		NSLog(@"imagenamestring::%@",imageString);
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
		// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
		
		NSFileManager  *manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
	}
	
	[labelNameArray removeObjectAtIndex:[sender tag]];
	NSLog(@"labelArraycount::%i",[labelNameArray count]);
	
	//[self Editmethod];
	//[scrollview reloadInputViews];
	for (UIView *view2 in scrollview.subviews) {
		[view2 removeFromSuperview ];
	}
	[self createPlaylistScrollView];
	[self Editmethod];
   // [archiveLabel removeFromSuperview];
}
-(void)btnClick:(id)sender
{
	MemberFunctionDetail *objUserDetail=[labelNameArray objectAtIndex:[sender tag]];
	
	if(objUserDetail.int_medicaldatatype_id==1)
	{
		TextViewController *viewcontroller=[[TextViewController alloc]initWithNibName:@"TextViewController" bundle:nil];
		viewcontroller.title_string_text=objUserDetail.str_title;
		viewcontroller.id_int_text=objUserDetail.int_id;
		viewcontroller.imagename_string_text=objUserDetail.str_data;
		viewcontroller.archived_int=objUserDetail.int_archive;
		appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}	
	if(objUserDetail.int_medicaldatatype_id==3)
	{
		PhotoViewController *viewcontroller=[[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
		viewcontroller.title_string=objUserDetail.str_title;
		viewcontroller.id_int=objUserDetail.int_id;
		viewcontroller.imagename_string=objUserDetail.str_data;
		viewcontroller.archived_int=objUserDetail.int_archive;
		appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
	if(objUserDetail.int_medicaldatatype_id==2)
	{
		AudioViewController *viewcontroller=[[AudioViewController alloc]initWithNibName:@"AudioViewController" bundle:nil];
		viewcontroller.title_string_audio=objUserDetail.str_title;
		viewcontroller.id_int_audio=objUserDetail.int_id;
		viewcontroller.imagename_string_audio=objUserDetail.str_data;
		viewcontroller.archived_int=objUserDetail.int_archive;
		appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
	if(objUserDetail.int_medicaldatatype_id==4)
	{
		FileViewController *viewcontroller=[[FileViewController alloc]initWithNibName:@"FileViewController" bundle:nil];
		viewcontroller.title_string_File=objUserDetail.str_title;
		viewcontroller.id_int_File=objUserDetail.int_id;
		viewcontroller.imagename_string_File=objUserDetail.str_data;
		viewcontroller.archived_int=objUserDetail.int_archive;
		appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
	if(objUserDetail.int_medicaldatatype_id==5)
	{
		VideoViewController *viewcontroller=[[VideoViewController alloc]initWithNibName:@"VideoViewController" bundle:nil];
		viewcontroller.title_string_video=objUserDetail.str_title;
		viewcontroller.id_int_video=objUserDetail.int_id;
		viewcontroller.imagename_string_video=objUserDetail.str_data;
		viewcontroller.archived_int=objUserDetail.int_archive;
	    appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
        NSLog(@"objUserDetail::%@",objUserDetail.str_title);
        NSLog(@"objUserDetail::%d",objUserDetail.int_id);
        NSLog(@"objUserDetail::%@",objUserDetail.str_data);
	}
	if(objUserDetail.int_medicaldatatype_id==6)
	{
		DrawingViewController *viewcontroller=[[DrawingViewController alloc]initWithNibName:@"DrawingViewController" bundle:nil];
		viewcontroller.title_string_Drawing=objUserDetail.str_title;
		viewcontroller.id_int_Drawing=objUserDetail.int_id;
		viewcontroller.imagename_string_Drawing=objUserDetail.str_data;
        viewcontroller.archived_int=objUserDetail.int_archive;
		appDelegate.FamilyName_String=getModulename;
		appDelegate.Str_UpdateFunction=@"Add";
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
}

/*
// Override to allow orientatcions other than the default portrait orientation.
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
