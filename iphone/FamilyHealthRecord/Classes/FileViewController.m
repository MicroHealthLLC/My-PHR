//
//  FileViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 13/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FileViewController.h"
#import "FamilyHealthRecordAppDelegate.h"

@implementation FileViewController
@synthesize leftbutton,rightbutton;
@synthesize appDelegate,tblView,txtField,txtTitle;
int OrderNoString;
@synthesize title_string_File,id_int_File,imagename_string_File,imageview,btnview,imagePhotoView,btncancel,txtview;
@synthesize topimageview,lbltitle,webview,pdfview,activityIndicator;
int tbl_int,btnpause;
@synthesize bottom_imageview,btn_Forward,btn_delete,archived_int,btn_Archive,lbl_title;
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
	lbl_title.text=appDelegate.FamMember_String;
	appDelegate=[[UIApplication sharedApplication]delegate];
	leftbutton.title=@"Cancel";
	
	txtTitle.delegate=self;
	
	NSError *error;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    
    NSString *folderstring = [documentsDirectory1 stringByAppendingPathComponent:@"/.ModuleImage"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
	
	btncancel.hidden=YES;
	imagePhotoView.hidden=YES;
	txtview.hidden=YES;
	btnpause.hidden=YES;
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		imageview.frame=CGRectMake(105, 120, 97, 68);
		txtField.frame=CGRectMake(88, 196, 131, 31);
		txtTitle.text= title_string_File;
		tblView.hidden=YES;
		
		NSArray *imageArray=[imagename_string_File componentsSeparatedByString:@"_XVX_"];
		txtField.text=[imageArray objectAtIndex:1];
		btnview.hidden=NO;
		rightbutton.title=@"Done";
		tbl_int=2;
	
	bottom_imageview.hidden=NO;
	btn_delete.hidden=NO;
	btn_Forward.hidden=NO;
		if(archived_int==0)
		{
			btn_Archive.hidden=YES;
		}
		else 
		{
			
			btn_Archive.hidden=NO;
			
		}
}
	else if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		
		bottom_imageview.hidden=YES;
		btn_delete.hidden=YES;
		btn_Forward.hidden=YES;
	[self FetchPathData];
		//imageview.frame=CGRectMake(105, 332, 97, 68);
		//txtField.frame=CGRectMake(88, 408, 131, 31);
		imageview.frame=CGRectMake(105, 120, 97, 68);
		txtField.frame=CGRectMake(88, 196, 131, 31);
		btnview.hidden=YES;
		tblView.hidden=NO;
		topimageview.hidden=YES;
		lbltitle.hidden=YES;
		txtTitle.hidden=YES;
		rightbutton.title=@"Edit";
		tbl_int=0;
		btn_Archive.hidden=YES;
	}
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[txtTitle resignFirstResponder];
	return YES;
}
-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)viewClick
{
	if([txtField.text hasSuffix:@".png"] || [txtField.text hasSuffix:@"png"]||[txtField.text hasSuffix:@".jpg"]||[txtField.text hasSuffix:@".jpeg"]||[txtField.text hasSuffix:@".txt"]||[txtField.text hasSuffix:@".rtf"]||[txtField.text hasSuffix:@".pdf"]||[txtField.text hasSuffix:@".doc"]||[txtField.text hasSuffix:@".xls"]||[txtField.text hasSuffix:@".ppt"]||[txtField.text hasSuffix:@".mp3"]||[txtField.text hasSuffix:@".mp4"]||[txtField.text hasSuffix:@".mov"]||[txtField.text hasSuffix:@".m4v"]||[txtField.text hasSuffix:@".caf"]||[txtField.text hasSuffix:@".zip"])
		
    {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_File];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
	
	
	
	if([imagename_string_File hasSuffix:@".png"])
	{
		imagePhotoView.hidden=NO;
		
		UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
		imagePhotoView.image=img;
	}
	else if([imagename_string_File hasSuffix:@".jpg"])
	{
		imagePhotoView.hidden=NO;
		UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
		imagePhotoView.image=img;
	}
	else if([imagename_string_File hasSuffix:@".jpeg"])
	{
		imagePhotoView.hidden=NO;
		UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
		imagePhotoView.image=img;
	}
	else if([imagename_string_File hasSuffix:@".txt"] || [imagename_string_File hasSuffix:@".rtf"] ||[imagename_string_File hasSuffix:@".pdf"] || [imagename_string_File hasSuffix:@".doc"]||[imagename_string_File hasSuffix:@".xls"] ||[imagename_string_File hasSuffix:@".ppt"] )
	{
		[self.view addSubview:pdfview];
		NSURL *urlforWebView=[NSURL fileURLWithPath:getImagePath];
		NSURLRequest *urlRequest=[NSURLRequest requestWithURL:urlforWebView];
		[webview loadRequest:urlRequest];
	}
	
	else if([imagename_string_File hasSuffix:@".caf"])
	{
		
		NSError *error;
		audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:getImagePath] error:&error];
		audioPlayer.delegate = self;
        if (error)
			NSLog(@"Error: %@",[error localizedDescription]);
        else
			[audioPlayer play];
	btnpause.hidden=NO;
	}
	else if([imagename_string_File hasSuffix:@".mp3"])
	{
		
		NSError *error;
		audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:getImagePath] error:&error];
		audioPlayer.delegate = self;
        if (error)
			NSLog(@"Error: %@",[error localizedDescription]);
        else
			[audioPlayer play];
		
		btnpause.hidden=NO;
	}
	else if([imagename_string_File hasSuffix:@".mp4"])
	{
		
		NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:getImagePath];
		videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:tempUrl];
		[self.view addSubview:videoPlayer.view];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitMoviePlayer) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
		[videoPlayer prepareToPlay];
		videoPlayer.fullscreen=YES; 
		[videoPlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
	}
	else if([imagename_string_File hasSuffix:@".mov"])
	{
		
		NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:getImagePath];
		videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:tempUrl];
		[self.view addSubview:videoPlayer.view];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitMoviePlayer) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
		[videoPlayer prepareToPlay];
		videoPlayer.fullscreen=YES; 
		[videoPlayer play];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
	}
	else if([imagename_string_File hasSuffix:@".m4v"])
	{
		
		
		NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:getImagePath];
		videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:tempUrl];
		[self.view addSubview:videoPlayer.view];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitMoviePlayer) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
		[videoPlayer prepareToPlay];
		videoPlayer.fullscreen=YES; 
		[videoPlayer play];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		
	}
	
	imageview.hidden=YES;
	btnview.hidden=YES;
	btncancel.hidden=NO;
	txtField.hidden=YES;
	}
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Invalid File Format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(void)videoPlayerFinish
{
    txtview.hidden=YES;
	imageview.hidden=NO;
	btnview.hidden=NO;
	imagePhotoView.hidden=YES;
	btncancel.hidden=YES;
	txtField.hidden=NO;
	btnpause.hidden=YES;
    btncancel.hidden=YES;
}


-(IBAction)PDFBack
{
	[pdfview removeFromSuperview];
	txtview.hidden=YES;
	imageview.hidden=NO;
	btnview.hidden=NO;
	imagePhotoView.hidden=YES;
	btncancel.hidden=YES;
	txtField.hidden=NO;
	btnpause.hidden=YES;
}
-(IBAction)cancel
{
	txtview.hidden=YES;
	imageview.hidden=NO;
	btnview.hidden=NO;
	imagePhotoView.hidden=YES;
	btncancel.hidden=YES;
	txtField.hidden=NO;
	btnpause.hidden=YES;
	if (audioPlayer.playing) {
		[audioPlayer stop];
    }
	[videoPlayer stop];
	[videoPlayer.view removeFromSuperview];
}

-(IBAction)pause
{
    if(!PlaypauseBool)
    {
	[audioPlayer pause];
    imageview.hidden=YES;
	btnview.hidden=YES;
	btncancel.hidden=NO;
	txtField.hidden=YES;
    btnpause.hidden=NO;
        [btnpause setTitle:@"Play" forState:UIControlStateNormal];
        PlaypauseBool=YES;
    }
    else
    {
        [audioPlayer play];
        [btnpause setTitle:@"Pause" forState:UIControlStateNormal];
        imageview.hidden=YES;
        btnview.hidden=YES;
        btncancel.hidden=NO;
        txtField.hidden=YES;
        btnpause.hidden=NO;
        PlaypauseBool=NO;
    }
}
-(IBAction)Done
{
	if(tbl_int==0)
	{
		rightbutton.title=@"Done";
		tblView.editing=YES;
		tblEditBool=YES;
		tbl_int=1;
	}
	else if(tbl_int==1)
	{
	rightbutton.title=@"Edit";
		tblView.editing=NO;
		tblEditBool=NO;
		tbl_int=0;
	}
	else if(tbl_int==2)
	{
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		[self InsertFile];
	}
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		[self UpdateFile];
	}
	}
}

-(void)FetchPathData
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager=[NSFileManager defaultManager];
	
	fileListArray=[[NSArray alloc]init];
	DataArray=[[NSMutableArray alloc]init];
    fileListArray= [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
	NSLog(@"fileListArray::%@",fileListArray);
	for (NSString *tempString in fileListArray) {
		if([tempString isEqualToString:@"/.DB_Family/FamilyHealthRecord.sqlite"])
		{
		}
		else if([tempString isEqualToString:@"ModuleImage"]||[tempString isEqualToString:@".ModuleImage"])
		{
		}
		else if([tempString isEqualToString:@"MyFolder"]||[tempString isEqualToString:@".MyFolder"])
		{
		}
		else if([tempString isEqualToString:@"AudioFile"]||[tempString isEqualToString:@".AudioFile"])
		{
		}
		else if([tempString isEqualToString:@"LogoImage"]||[tempString isEqualToString:@".LogoImage"])
		{
		}
		else if([tempString isEqualToString:@"VideoFile"]||[tempString isEqualToString:@".VideoFile"])
		{
		}
		else if([tempString isEqualToString:@"DS_Store"]||[tempString isEqualToString:@".DS_Store"])
		{
		}
		else if([tempString isEqualToString:@"DB_Family"]||[tempString isEqualToString:@".DB_Family"])
		{
		}
		else 
		{
			[DataArray addObject:tempString];
		}
		NSLog(@"DataArray::%@",DataArray);
	}
	
}

-(void)FetchMaxOrderNo
{
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		
		//const char *sqlStatement = "select family_id, f_name,l_name,image,ordernum from tb_FamilyMember";
		const char *sqlStatement = "SELECT MAX(ordernum) from MedicalHistory";
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
			//sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                //				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				//int *OrderNoString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				OrderNoString = (int)sqlite3_column_int(statement, 0);
				
				
				NSLog(@"OrderNoString::%d",OrderNoString);
				
			}
			
			
		}
		
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
		sqlite3_close(database);
	}
}

-(void)InsertFile
{
	if([txtTitle.text isEqualToString:@""])
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please Give Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else 
	{
		/*if([txtField.text hasSuffix:@".png"] || [txtField.text hasSuffix:@"png"]||[txtField.text hasSuffix:@".jpg"]||[txtField.text hasSuffix:@".jpeg"]||[txtField.text hasSuffix:@".txt"]||[txtField.text hasSuffix:@".rtf"]||[txtField.text hasSuffix:@".pdf"]||[txtField.text hasSuffix:@".doc"]||[txtField.text hasSuffix:@".xls"]||[txtField.text hasSuffix:@".ppt"]||[txtField.text hasSuffix:@".mp3"]||[txtField.text hasSuffix:@".mp4"]||[txtField.text hasSuffix:@".mov"]||[txtField.text hasSuffix:@".m4v"]||[txtField.text hasSuffix:@".caf"])
		
		{*/
			NSDate* date = [NSDate date];
		NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat:@"HHmmssyyyyMMdd"];
		NSString* str = [formatter stringFromDate:date];
		
		NSDateFormatter *formatter1=[[[NSDateFormatter alloc]init] autorelease];
		[formatter1 setDateFormat:@"EEE MMM d yyyy HH:mm:ss a"];
		NSString *CreatedDate=[formatter1 stringFromDate:date];
		[self FetchMaxOrderNo];
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
		database1 = [FMDatabase databaseWithPath:databasePath]; 
		
		[database1 open];
		NSString *FilenameStr=[NSString stringWithFormat:@"%@_XVX_%@",str,txtField.text];
		//NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
		
		//NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,family_id,data,module_id,medicaldatatype_id,archive,created_date,modify_date,title) values ('%i','1','%@','%i','13','3',)",OrderNoString+1,str,];
		NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id,archive) values ('%i','%@','4','%@','%@','%@','%@','%@','0')",OrderNoString+1,FilenameStr,txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		
		[database1 executeUpdate:query];
		[database1 close];
		
		
	NSError *error;
		NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *imagename=[NSString stringWithFormat:@"%@.png",str];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDirectory stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		//NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imagename];
		NSString *tempstr=[NSString stringWithFormat:@"%@/%@",folderstring,FilenameStr];
		
		/*UIImage *image = drawImage.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(image);
		
		[imageData writeToFile:savedImagePath atomically:NO];*/
		NSString *strname=[NSString stringWithFormat:@"/%@",txtField.text];
		NSString *savedImagePath1 = [documentsDirectory stringByAppendingPathComponent:strname];
		
		[[NSFileManager defaultManager] copyItemAtPath:savedImagePath1 toPath:tempstr error:nil];
		NSLog(@"tempstr::%@",tempstr);
		NSLog(@"savedImagePath1::%@",savedImagePath1);
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"File successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
	}
		/*else {
			
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Invalid File Format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}*/

	}
	
	
//}
-(void)UpdateFile 
{
	if([txtTitle.text isEqualToString:@""])
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please Give Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else 
	{
		NSDate* date = [NSDate date];
		/*	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
		 [formatter setDateFormat:@"HHmmssyyyyMMdd"];
		 NSString* str = [formatter stringFromDate:date];*/
		
		NSDateFormatter *formatter1=[[[NSDateFormatter alloc]init] autorelease];
		[formatter1 setDateFormat:@"EEE MMM d yyyy HH:mm:ss a"];
		NSString *CreatedDate=[formatter1 stringFromDate:date];
		[self FetchMaxOrderNo];
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
		database1 = [FMDatabase databaseWithPath:databasePath]; 
		
		[database1 open];
		
		//NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
		
		//NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,family_id,data,module_id,medicaldatatype_id,archive,created_date,modify_date,title) values ('%i','1','%@','%i','13','3',)",OrderNoString+1,str,];
		//NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id) values ('%i','%@','3','%@','%@','%@','%@','%@')",OrderNoString+1,str,txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *query = [NSString stringWithFormat:@"UPDATE MedicalHistory SET title='%@',modify_date='%@' where id='%i'",txtTitle.text,CreatedDate,id_int_File];
		[database1 executeUpdate:query];
		[database1 close];
		
	
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"File successfully Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
}
}

-(IBAction)Forward_Email
{
	if(archived_int==0)
	{
		UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Message",@"Mark As Archived",nil];
		[sheet showInView:self.view];
		[sheet release];
	}
	else if(archived_int==1)
	{
		UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Message",@"Remove 'Archived' Label",nil];
		[sheet showInView:self.view];
		[sheet release];
	}
	
}
-(IBAction)delete_Email
{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
	database1 = [FMDatabase databaseWithPath:databasePath];    
    [database1 open];
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",id_int_File];
	[database1 executeUpdate:temp];
	[database1 close];
	
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_File];
	
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
	// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	imageBool=YES;
}

#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [DataArray count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	else
	{

	}
	cell.textLabel.text=[DataArray objectAtIndex:indexPath.row];
	cell.font=[UIFont systemFontOfSize:20];
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	tblView.hidden=YES;
	topimageview.hidden=NO;
	lbltitle.hidden=NO;
	txtTitle.hidden=NO;
	rightbutton.title=@"Done";
	tbl_int=2;
 txtField.text=[DataArray objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *str=[DataArray objectAtIndex:indexPath.row];
	NSLog(@"%@",str);
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
	
	NSString *myFilePath1=[documentsDir stringByAppendingPathComponent:str];
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	[DataArray removeObjectAtIndex:indexPath.row];
	[self.tblView reloadData];
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(imageBool==YES)
	{
		if(buttonIndex==0)
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"activity started");
    [activityIndicator startAnimating];
	activityIndicator.hidden=NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"activity stopped");
    [activityIndicator stopAnimating];
	activityIndicator.hidden=YES; 
    //self.LinkView = webView;
}
#pragma mark Actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) 
	{ 
		//[self.navigationController popViewControllerAnimated:YES];
		return; 
	}
	switch (buttonIndex) {
		case 0:
		{
			NSLog(@"Email");
			[self email:@"" toString:@""];
			break;
		}
		case 1:
		{
			NSLog(@"Messages");
			[self displayComposerSheet];
			break;
		}
		case 2:
		{
			NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDir = [documentPaths objectAtIndex:0];
			NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
			
			database1 = [FMDatabase databaseWithPath:databasePath];    
			[database1 open];
			NSString *temp;
			if(archived_int==0)
			{
				NSLog(@"Archived Label");
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",id_int_File];
				
				
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item archived." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else if(archived_int==1)
			{
				NSLog(@"Remove Archived Label");
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",id_int_File];
				
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item remove from archive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			[database1 executeUpdate:temp];
			[database1 close];
			imageBool=YES;
			break;
		}
	}
	
}


#pragma mark Email
-(void)email:(NSString *)subject toString:(NSString *)toString
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet:subject toString:toString];
		}
	}
}
-(void)displayComposerSheet:(NSString *)subject toString:(NSString *)toString
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	//[picker setSubject:subject];
	[picker setSubject:@"Family Health Record"];
	//[picker setMessageBody:@"" isHTML:YES];
	// Set up recipients
	if(toString!=nil)
	{
		NSArray *toRecipients = [NSArray arrayWithObject:toString]; 
		[picker setToRecipients:toRecipients];
	}
	//NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
	//NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
	
	//[picker setCcRecipients:ccRecipients];	
	//[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_File];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
	
	NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
	// Fill out the email body text
	//[picker setMessageBody:emailBody isHTML:NO];
	
	if([imagename_string_File hasSuffix:@".png"])
	{
		[picker addAttachmentData:data1 mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@",txtField.text]];
	}
	else if([imagename_string_File hasSuffix:@".jpg"])
	{
		[picker addAttachmentData:data1 mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".jpeg"])
	{
		[picker addAttachmentData:data1 mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".txt"])
	{
		[picker addAttachmentData:data1 mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
			
	else if([imagename_string_File hasSuffix:@".rtf"])
	{
		[picker addAttachmentData:data1 mimeType:@"rtf/plain" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".pdf"])
	{
		[picker addAttachmentData:data1 mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".doc"])
	{
		[picker addAttachmentData:data1 mimeType:@"application/doc" fileName:[NSString stringWithFormat:@"%@",txtField.text]];
		
	}
	else if([imagename_string_File hasSuffix:@".xls"])
	{
		[picker addAttachmentData:data1 mimeType:@"application/xls" fileName:[NSString stringWithFormat:@"%@",txtField.text]];
		
	}
	else if([imagename_string_File hasSuffix:@".ppt"])
	{
		[picker addAttachmentData:data1 mimeType:@"application/ppt" fileName:[NSString stringWithFormat:@"%@",txtField.text]];
		
	}
	
	else if([imagename_string_File hasSuffix:@".caf"])
	{
		
		[picker addAttachmentData:data1 mimeType:@"application/caf" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".mp3"])
	{
		
		[picker addAttachmentData:data1 mimeType:@"application/mp3" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	else if([imagename_string_File hasSuffix:@".mp4"])
	{
		
		[picker addAttachmentData:data1 mimeType:@"application/mp4" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

		
	}
	else if([imagename_string_File hasSuffix:@".mov"])
	{
		[picker addAttachmentData:data1 mimeType:@"application/mov" fileName:[NSString stringWithFormat:@"%@",txtField.text]];
		
	}
	else if([imagename_string_File hasSuffix:@".m4v"])
	{
		
		[picker addAttachmentData:data1 mimeType:@"application/m4v" fileName:[NSString stringWithFormat:@"%@",txtField.text]];

	}
	
	NSString *stremail=[NSString stringWithFormat:@"%@ for %@-%@",appDelegate.FamilyName_String,appDelegate.FamMember_String,txtTitle.text];

	[picker setMessageBody:stremail isHTML:NO];
	[self presentModalViewController:picker animated:YES];
	[picker release];
	
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark Message


-(void)displayComposerSheet
{
	MFMessageComposeViewController *picker1 = [[MFMessageComposeViewController alloc] init];
	picker1.messageComposeDelegate = self;
	
	picker1.recipients =[NSArray arrayWithObjects:@"",nil]; // your recipient number or self for testing
	picker1.body=@"";
	
	[self presentModalViewController:picker1 animated:YES];
	[picker1 release];
	NSLog(@"SMS fired");
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	//message.hidden = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			//message.text = @"Result: canceled";
			NSLog(@"Result: canceled");
			break;
		case MessageComposeResultSent:
			//message.text = @"Result: sent";
			NSLog(@"Result: sent");
			break;
		case MessageComposeResultFailed:
			//	message.text = @"Result: failed";
			NSLog(@"Result: failed");
			break;
		default:
			//message.text = @"Result: not sent";
			NSLog(@"Result: not sent");
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}

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
