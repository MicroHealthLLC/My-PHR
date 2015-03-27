
//
//  AudioViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioViewController.h"
#import"FamilyHealthRecordAppDelegate.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation AudioViewController
@synthesize leftbutton,rightbutton;
@synthesize playButton,recordButton,stopButton,txtTitle;
@synthesize lblRecord,lblPlay,lblStop,appDelegate;
@synthesize title_string_audio,id_int_audio,imagename_string_audio;
int name=1,OrderNoString;
int play_int;
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
    recordArray=[[NSMutableArray alloc]init];
	recordPathArray=[[NSMutableArray alloc]init];
	
    NSError *error;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    
    NSString *folderstring = [documentsDirectory1 stringByAppendingPathComponent:@"/.ModuleImage"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
	leftbutton.title=@"Cancel";
	rightbutton.title=@"Done";
	playButton.enabled=NO;
	stopButton.enabled=NO;
    txtTitle.delegate=self;	
	sounds = [[NSMutableData alloc]init];
	lblPlay.enabled=NO;
	lblStop.enabled=NO;
	appDelegate=[[UIApplication sharedApplication]delegate];
	
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		
		txtTitle.text=title_string_audio;
		
	    NSArray *temp =[imagename_string_audio  componentsSeparatedByString:@","] ;
        recordArray = [[NSMutableArray arrayWithArray:temp] retain];
		NSLog(@"recordArray::%@",recordArray);
	
		for (int i = 0; i < [recordArray count]; i++)
		{	
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[recordArray objectAtIndex:i]];
																																			
		NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:txtString];
		NSLog(@"myPathDocs::%@",myPathDocs);
		[recordPathArray addObject:myPathDocs];
		NSLog(@"recordPathArray::%@",recordPathArray);
		}
		
		playButton.enabled=YES;
		lblPlay.enabled=YES;
		
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
		btn_Archive.hidden=YES;
	}
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[txtTitle resignFirstResponder];
	return YES;
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

-(void)InsertAudio
{
	//[self FetchAudio];

	if([txtTitle.text isEqualToString:@""])
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please Give Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else 
	{
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
		
		//NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
		
		//NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,family_id,data,module_id,medicaldatatype_id,archive,created_date,modify_date,title) values ('%i','1','%@','%i','13','3',)",OrderNoString+1,str,];
		NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id,archive) values ('%i','%@','2','%@','%@','%@','%@','%@','0')",OrderNoString+1,[recordArray componentsJoinedByString:@","],txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		
		[database1 executeUpdate:query];
		[database1 close];
			
		NSError *error;
		//NSString *imagename=[NSString stringWithFormat:@"/%@.caf",[recordArray componentsJoinedByString:@","]];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		
		NSArray *inboxContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/.AudioFile", documentsDir] error:nil];
		
		for (int i = 0; i != [inboxContents count]; i++) {	
			NSString *oldPath = [NSString stringWithFormat:@"%@/.AudioFile/%@", documentsDir, [inboxContents objectAtIndex:i]];
			NSString *newPath = [NSString stringWithFormat:@"%@/%@", folderstring, [inboxContents objectAtIndex:i]];		
			[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
		}
		
		
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.AudioFile"];
		
		
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
	
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"AudioFile successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
		
		
		
		
		
	}
}
-(void)UpdateAudio
{
	//[self FetchAudio];

	if([txtTitle.text isEqualToString:@""])
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please Give Title" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else 
	{
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
		
		
		
		NSString *query = [NSString stringWithFormat:@"UPDATE MedicalHistory SET title='%@',data='%@',modify_date='%@' where id='%i'",txtTitle.text,[recordArray componentsJoinedByString:@","],CreatedDate,id_int_audio];
        
		[database1 executeUpdate:query];
		[database1 close];
	
		
		NSError *error;
		//NSString *imagename=[NSString stringWithFormat:@"/%@.caf",[recordArray componentsJoinedByString:@","]];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		
		NSArray *inboxContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/.AudioFile", documentsDir] error:nil];
		
		for (int i = 0; i != [inboxContents count]; i++) {	
			NSString *oldPath = [NSString stringWithFormat:@"%@/.AudioFile/%@", documentsDir, [inboxContents objectAtIndex:i]];
			NSString *newPath = [NSString stringWithFormat:@"%@/%@", folderstring, [inboxContents objectAtIndex:i]];		
			[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
		}
		
		
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.AudioFile"];
		
		
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"AudioFile successfully Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
}
}
-(IBAction)Done
{
	[audioPlayer stop];
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		[self InsertAudio];
	}
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		[self UpdateAudio];
	}
}
-(IBAction)Back
{
	NSArray *Path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDir=[Path objectAtIndex:0];
	
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.AudioFile"];
	
	manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	[self.navigationController popViewControllerAnimated:YES];
	[audioPlayer stop];
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
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",id_int_audio];
	[database1 executeUpdate:temp];
	[database1 close];
	
	
	for (int i = 0; i < [recordArray count]; i++)
	{	
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[recordArray objectAtIndex:i]];
		
		NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:txtString];
		NSLog(@"myPathDocs::%@",myPathDocs);
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myPathDocs error:NULL];
		NSLog(@"recordPathArray::%@",recordPathArray);
	}
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.AudioFile"];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];

	// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	
     
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	imageBool=YES;
}

-(IBAction) recordAudio
{
	/*NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *caldate = [now description];
	soundFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];*/
    NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HHmmssyyyyMMdd"];
	NSString* str = [formatter stringFromDate:date];
	NSArray *dirPaths;
	NSString *docsDir;
	
	NSError *error;
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
	
	NSString *folderstring = [docsDir stringByAppendingPathComponent:@"/.AudioFile"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
    
	
	
	//NSString *audioname=[NSString stringWithFormat:@"/%i.caf",name];
    NSString *audioname=[[NSString stringWithFormat:@"%@.caf",str] retain];
	NSLog(@"audioname::%@",audioname);
	NSString *Foldername=[NSString stringWithFormat:@"/.AudioFile/"];
	NSString *soundFilePath1 = [docsDir
							   stringByAppendingPathComponent:Foldername];
	if(![[NSFileManager defaultManager] fileExistsAtPath:soundFilePath1])
		[[NSFileManager defaultManager] createDirectoryAtPath:soundFilePath1 withIntermediateDirectories:NO attributes:nil error:&error];
	

	NSString *soundFilePath=[[soundFilePath1 stringByAppendingString:[NSString stringWithFormat:@"/%@",audioname]] retain];
	NSLog(@"soundFilePath::%@",soundFilePath);
	NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
	
	/*NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
									[NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey, [NSNumber numberWithFloat: 44100.0], AVSampleRateKey, [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,  [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey, nil];*/
	
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat: 44100.0],                 
                              AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2],      
                              AVNumberOfChannelsKey,[NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    audioRecorder = [[AVAudioRecorder alloc]
					 initWithURL:soundFileURL
					 settings:recordSettings
					 error:&error];
	
	if (error)
	{
		NSLog(@"error: %@", [error localizedDescription]);
	} 
	else
	{
		[audioRecorder prepareToRecord];
	}
	stopButton.enabled=YES;
	playButton.enabled=NO;
	recordButton.enabled=NO;
	lblPlay.enabled=NO;
	lblStop.enabled=YES;
	lblRecord.enabled=NO;
	//name++;
   [self recordvoice];
	
	[recordArray addObject:audioname];
	[recordPathArray addObject:soundFilePath];
	
	NSLog(@"recordArray::%@",recordArray);
}
-(void)recordvoice
{
	if (!audioRecorder.recording)
	{
		playButton.enabled = NO;
		stopButton.enabled = YES;
		lblPlay.enabled=NO;
		lblStop.enabled=YES;
		[audioRecorder record];
	}
}
-(IBAction) stop
{
    stopButton.enabled = NO;
    playButton.enabled = YES;
    recordButton.enabled = YES;
	
	lblPlay.enabled=YES;
	lblStop.enabled=NO;
	lblRecord.enabled=YES;
    if (audioRecorder.recording)
    {
		[audioRecorder stop];
    } else if (audioPlayer.playing) {
		[audioPlayer stop];
    }
}

/*- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error

{

}*/
-(IBAction) playAudio
{
	//[self FetchAudio];
	if (!audioRecorder.recording)
    {
		stopButton.enabled = YES;
		recordButton.enabled = NO;
        playButton.enabled=NO;
        lblStop.enabled = YES;
		lblRecord.enabled = NO;
        lblPlay.enabled=NO;
		
        if (audioPlayer)
			[audioPlayer release];
        NSError *error;
		
		NSString *audioString=[recordPathArray objectAtIndex:0];
		audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioString] error:&error];
		audioPlayer.delegate = self;
		play_int=0;
        if (error)
			NSLog(@"Error: %@",[error localizedDescription]);
        else
			[audioPlayer play];
	}
    //stopButton.enabled = NO;
   // recordButton.enabled = YES;
}
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{

	if(recordPathArray.count>1)
	{
        stopButton.enabled = YES;
		recordButton.enabled = NO;
        playButton.enabled=NO;
        
        lblStop.enabled = YES;
		lblRecord.enabled = NO;
        lblPlay.enabled=NO;
        
		play_int++;
		if(recordPathArray.count-1 >= play_int)
		{
		NSString *audioString=[recordPathArray objectAtIndex:play_int];
		NSURL *url1=[NSURL fileURLWithPath:audioString];
		audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
            audioPlayer.delegate = self;
            [audioPlayer play];
		}
	}

    if(audioPlayer.playing)
    {
        stopButton.enabled = YES;
		recordButton.enabled = NO;
        playButton.enabled=NO;
        lblStop.enabled = YES;
		lblRecord.enabled = NO;
        lblPlay.enabled=NO;
    }
   else
    {
      stopButton.enabled = NO;
		recordButton.enabled = YES;
       playButton.enabled=YES;
        lblStop.enabled = NO;
		lblRecord.enabled = YES;
        lblPlay.enabled=YES;
   }
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player 
								error:(NSError *)error
{
	NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder 
						  successfully:(BOOL)flag
{
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder 
								  error:(NSError *)error
{
	NSLog(@"Encode Error occurred");
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
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",id_int_audio];
				
				
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item archived." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else if(archived_int==1)
			{
				NSLog(@"Remove Archived Label");
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",id_int_audio];
				
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
	/*MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	 picker.mailComposeDelegate = self;
	 
	 [picker setSubject:subject];
	 
	 
	 // Set up recipients
	 if(toString!=nil)
	 {
	 NSArray *toRecipients = [NSArray arrayWithObject:toString]; 
	 [picker setToRecipients:toRecipients];
	 }
	 [picker setMessageBody:[NSString stringWithFormat:@"%@",txtView.text] isHTML:YES];
	 [self presentModalViewController:picker animated:YES];
	 [picker release];*/
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
    
    NSArray *temp =[imagename_string_audio  componentsSeparatedByString:@","] ;
	
    for (int i = 0; i < [recordArray count]; i++)
    {	
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		/*NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[temp objectAtIndex:i]];
        
		NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:txtString];
		NSLog(@"myPathDocs::%@",myPathDocs);*/
        
        NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[temp objectAtIndex:i]];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
        NSLog(@"getImagePath::%@",getImagePath);
        
        NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
        [picker addAttachmentData:data1 mimeType:@"application/caf" fileName:[NSString stringWithFormat:@"%@",[temp objectAtIndex:i]]];
    }
    
    
    
	/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_audio];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
    NSLog(@"getImagePath::%@",getImagePath);

	NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
	[picker addAttachmentData:data1 mimeType:@"application/caf" fileName:[NSString stringWithFormat:@"%@",imagename_string_audio]];*/
	// Fill out the email body text
	//[picker setMessageBody:emailBody isHTML:NO];
	
	
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
-(void)FetchAudio	
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *folderpath=[NSString stringWithFormat:@"/.AudioFile/"];
	NSString *pathFolder=[documentsDirectoryPath stringByAppendingPathComponent:folderpath];
	
	manager = [NSFileManager defaultManager];
	fileList= [manager contentsOfDirectoryAtPath:pathFolder error:nil];
	NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.caf'"];
	NSArray *onlyCaf = [fileList filteredArrayUsingPredicate:fltr];
	
	AVMutableComposition *composition =[AVMutableComposition composition]; 
	
	/*AVMutableCompositionTrack * composedTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo                                                  
	 preferredTrackID:kCMPersistentTrackID_Invalid];*/
	AVMutableCompositionTrack * composedTrackaudio = [composition addMutableTrackWithMediaType:AVMediaTypeAudio                                                 
																			  preferredTrackID:kCMPersistentTrackID_Invalid];
	//CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI_2);
	//composedTrack.preferredTransform =rotationTransform;
	int i=0;
	CMTime lastvideoduration;
	NSLog(@"fileList::%@",onlyCaf);
	for (NSString *path in onlyCaf) 
	{	path = [pathFolder stringByAppendingFormat:@"/%@",path];
		NSURL *soundFilePath = [[NSURL alloc] initFileURLWithPath:path];
		NSLog(@"soundFilePath::%@",soundFilePath);
		
		i++;
		
        
		
		AVURLAsset* video1 = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:path] options:nil];
		NSLog(@"asseat tarck %i",video1.tracks.count);
		
		if (i==1) {
			/*[composedTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
			 
			 ofTrack:[[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
			 
			 atTime:kCMTimeZero
			 
			 error:nil];*/
			[composedTrackaudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
			 
										ofTrack:[[video1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
			 
										 atTime:kCMTimeZero
			 
										  error:nil];
			
			lastvideoduration=video1.duration;
			
		}
		else
		{
			/*[composedTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
			 
			 ofTrack:[[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
			 
			 atTime:lastvideoduration
			 
			 error:nil];*/
			[composedTrackaudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
			 
										ofTrack:[[video1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
			 
										 atTime:lastvideoduration
			 
										  error:nil];
			
			lastvideoduration= CMTimeAdd(lastvideoduration, video1.duration);
			
		}
		
		
		
		
		//	NSData *sound1Data = [[NSData alloc] initWithContentsOfURL:soundFilePath];
		//[sounds appendData:sound1Data];
		//NSLog(@"%i",sounds.length);
	}
	//	NSString* documentsDirectory= [self applicationDocumentsDirectory];
	
	NSString* myDocumentPath= [documentsDirectoryPath stringByAppendingPathComponent:@"merge_video.caf"];
	
	NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
		
	{
		
		[[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
		
	}
	
	AVAssetExportSession *exporter = [[[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality] autorelease];
	
	
	
	exporter.outputURL=url;
	
	exporter.outputFileType =AVFileTypeQuickTimeMovie;
	//  exporter.outputFileType=@"com.apple.m4a-audio";
	
	exporter.shouldOptimizeForNetworkUse = YES;
	
	[exporter exportAsynchronouslyWithCompletionHandler:^{
		
		switch ([exporter status]) {
				
			case AVAssetExportSessionStatusFailed:
				
				break;
				
			case AVAssetExportSessionStatusCancelled:
				
				break;
				
			case AVAssetExportSessionStatusCompleted:
				if (!audioRecorder.recording)
				{
					stopButton.enabled = YES;
					recordButton.enabled = NO;
					lblStop.enabled=YES;
					lblRecord.enabled=NO;
					
					if (audioPlayer)
						[audioPlayer release];
					
					/*[[NSFileManager defaultManager] createFileAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.mp3"] contents:sounds attributes:nil];
					 NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.mp3"]);
					 */
					NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
					NSString *documentsDirectoryPath = [paths objectAtIndex:0];
					NSString *folderpath=[NSString stringWithFormat:@"merge_video.caf"];
					NSString *pathFolder=[documentsDirectoryPath stringByAppendingPathComponent:folderpath];
					
					NSLog(@"pathFolder::%@",pathFolder);
					
					audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathFolder] error:nil];
					
					audioPlayer.delegate = self;
					
					[audioPlayer play];
				}
				
				break;
				
			default:
				
				break;
				
		}
		
	}];
	
	
}


@end
