//
//  VideoViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoViewController.h"
#import"FamilyHealthRecordAppDelegate.h"

@implementation VideoViewController
@synthesize tempImageview;
@synthesize activity;
@synthesize leftbutton,rightbutton;
@synthesize playButton,recordButton,stopButton,txtTitle;
@synthesize lblRecord,lblPlay,lblStop,appDelegate;
int name,OrderNoString,play_int;
@synthesize bottom_imageview,btn_Forward,btn_delete,archived_int,btn_Archive;
@synthesize title_string_video,id_int_video,imagename_string_video,lbl_title;

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
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
	
	lblPlay.enabled=NO;
	lblStop.enabled=NO;
	
	sounds = [[NSMutableData alloc]init];
	
	appDelegate=[[UIApplication sharedApplication]delegate];
	
	
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		
		txtTitle.text=title_string_video;
			/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			
			NSString *txtString=[NSString stringWithFormat:@"/ModuleImage/%@_%@/%@.mp4",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_video];
			
			NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:txtString];
			NSLog(@"myPathDocs::%@",myPathDocs);
			NSURL *soundFilePath = [[NSURL alloc] initFileURLWithPath:myPathDocs];
			
			NSString *Foldername=[NSString stringWithFormat:@"/VideoFile/"];
			NSString *myPathDocs1 = [documentsDirectory
									 stringByAppendingPathComponent:Foldername];
			NSURL *soundFilePath1 = [[NSURL alloc] initFileURLWithPath:myPathDocs1];
			
			[[NSFileManager defaultManager]moveItemAtPath:myPathDocs toPath:myPathDocs1 error:nil];*/
        NSArray *temp =[imagename_string_video  componentsSeparatedByString:@","] ;
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

-(void)InsertVideo
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
		NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id,archive) values ('%i','%@','5','%@','%@','%@','%@','%@','0')",OrderNoString+1,[recordArray componentsJoinedByString:@","],txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		
		[database1 executeUpdate:query];
		[database1 close];
		
		NSError *error;
		//NSString *imagename=[NSString stringWithFormat:@"/%@.caf",[recordArray componentsJoinedByString:@","]];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		NSString *folderstring1 = [documentsDir stringByAppendingPathComponent:@"/.LogoImage"];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring1])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring1 withIntermediateDirectories:NO attributes:nil error:&error];
		
		
		
		//NSError *error;
		NSString *imagename=[NSString stringWithFormat:@"/%@.png",[recordArray componentsJoinedByString:@","]];
		NSString *savedImagePath = [folderstring1 stringByAppendingPathComponent:imagename];
		
		//UIImage *image = imageview.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(tempImageview.image);
		
		[imageData writeToFile:savedImagePath atomically:NO];
		
		
		
		NSArray *inboxContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/.VideoFile", documentsDir] error:nil];
		
		for (int i = 0; i != [inboxContents count]; i++) {	
			NSString *oldPath = [NSString stringWithFormat:@"%@/.VideoFile/%@", documentsDir, [inboxContents objectAtIndex:i]];
			NSString *newPath = [NSString stringWithFormat:@"%@/%@", folderstring, [inboxContents objectAtIndex:i]];		
			[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
		}

		
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.VideoFile"];

		
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"VideoFile successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
	}
}
-(void)UpdateVideo
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
		
		
		//NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id) values ('%i','%@','2','%@','%@','%@','%@','%@')",OrderNoString+1,str,txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *query = [NSString stringWithFormat:@"UPDATE MedicalHistory SET title='%@',data='%@',modify_date='%@' where id='%i'",txtTitle.text,[recordArray componentsJoinedByString:@","],CreatedDate,id_int_video];
		
		[database1 executeUpdate:query];
		[database1 close];
		
		
		NSError *error;
		//NSString *imagename=[NSString stringWithFormat:@"/%@.caf",[recordArray componentsJoinedByString:@","]];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		
		NSArray *inboxContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/.VideoFile", documentsDir] error:nil];
		
		for (int i = 0; i != [inboxContents count]; i++) {	
			NSString *oldPath = [NSString stringWithFormat:@"%@/.VideoFile/%@", documentsDir, [inboxContents objectAtIndex:i]];
			NSString *newPath = [NSString stringWithFormat:@"%@/%@", folderstring, [inboxContents objectAtIndex:i]];		
			[[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
		}
		
		NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.VideoFile"];
	
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myFilePath1 error:NULL];
		
		NSString *folderstring1 = [documentsDir stringByAppendingPathComponent:@"/.LogoImage"];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring1])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring1 withIntermediateDirectories:NO attributes:nil error:&error];
		
		
		
		//NSError *error;
		NSString *imagename=[NSString stringWithFormat:@"/%@.png",[recordArray componentsJoinedByString:@","]];
		NSString *savedImagePath = [folderstring1 stringByAppendingPathComponent:imagename];
		
		//UIImage *image = imageview.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(tempImageview.image);
		
		[imageData writeToFile:savedImagePath atomically:NO];
		
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"VideoFile successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
		
	}
}


-(IBAction)Done
{
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		[self InsertVideo];
	}
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		[self UpdateVideo];
	}
	
}
-(IBAction)Back
{

	
	
	
	NSArray *Path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDir=[Path objectAtIndex:0];
	
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.VideoFile"];
	
	
	manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	[videoPlayer stop];
	[self.navigationController popViewControllerAnimated:YES];
	
	/*}
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		[self.navigationController popViewControllerAnimated:YES];
	}*/

}
-(IBAction) recordAudio
{
    play_int=0;
    picker =[[UIImagePickerController alloc] init];
	picker.delegate=self;
	picker.sourceType=UIImagePickerControllerSourceTypeCamera;
	picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
	picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
	picker.videoMaximumDuration = 60.0f;
	[self presentModalViewController:picker animated:YES];
	
}
-(void)FetchVideo
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *folderpath=[NSString stringWithFormat:@"/.VideoFile/"];
	NSString *pathFolder=[documentsDirectoryPath stringByAppendingPathComponent:folderpath];
	
	manager = [NSFileManager defaultManager];
	fileList= [manager contentsOfDirectoryAtPath:pathFolder error:nil];
	NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"];
	NSArray *onlyCaf = [fileList filteredArrayUsingPredicate:fltr];
	
    AVMutableComposition *composition =[AVMutableComposition composition]; 
    
    AVMutableCompositionTrack * composedTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo                                                  
                                                                         preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack * composedTrackaudio = [composition addMutableTrackWithMediaType:AVMediaTypeAudio                                                 
                                                                         preferredTrackID:kCMPersistentTrackID_Invalid];
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI_2);
    composedTrack.preferredTransform =rotationTransform;
    int i=0;
    CMTime lastvideoduration;
	NSLog(@"fileList::%@",onlyCaf);
	for (NSString *path in onlyCaf) 
	{	path = [pathFolder stringByAppendingFormat:@"/%@",path];
		NSURL *soundFilePath = [[NSURL alloc] initFileURLWithPath:path];
		NSLog(@"soundFilePath::%@",soundFilePath);
        
        i++;
        
        
        AVURLAsset* video1 = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:path] options:nil];
        
        if (i==1) {
            [composedTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
             
                                   ofTrack:[[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
             
                                    atTime:kCMTimeZero
             
                                     error:nil];
            [composedTrackaudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
             
                                   ofTrack:[[video1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
             
                                    atTime:kCMTimeZero
             
                                     error:nil];

            lastvideoduration=video1.duration;

        }
        else
        {
            [composedTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, video1.duration)
             
                                   ofTrack:[[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
             
                                    atTime:lastvideoduration
             
                                     error:nil];
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
    
    NSString* myDocumentPath= [documentsDirectoryPath stringByAppendingPathComponent:@"merge_video.mp4"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
        
    {
        
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality] ;
    
    
//    exporter.videoComposition = AVVideo
    exporter.outputURL=url;
    
    exporter.outputFileType = @"com.apple.quicktime-movie";
    
   exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exporter status]) {
                
            case AVAssetExportSessionStatusFailed:
                NSLog(@"fail");
                break;
                
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"cancle");
                break;
                
            case AVAssetExportSessionStatusCompleted:
                [activity stopAnimating];
                [self playVideo:nil];
               

                break;
                
            default:
                
                break;
                
        }
        
    }];
}

-(IBAction)playVideo:(id)sender
{

    
    NSString *audioString=[recordPathArray objectAtIndex:0];
    NSURL *tempUrl = [[NSURL alloc] initFileURLWithPath:audioString];
    videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:tempUrl];
   [self.view addSubview:videoPlayer.view];
    play_int=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
   
//    videoPlayer.movieSourceType = MPMovieSourceTypeFile;
    //  NSLog(@"%@",videoPlayer.errorLog);
    //logoimage= [videoPlayer thumbnailImageAtTime:(NSTimeInterval)1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [videoPlayer prepareToPlay];
    videoPlayer.fullscreen=YES; 
    [videoPlayer play];
}
-(void)videoPlayerFinish
{
    if(recordPathArray.count>=1)
{
    play_int++;
    if(recordPathArray.count-1 >= play_int)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
		NSString *audioString=[recordPathArray objectAtIndex:play_int];
		NSURL *url1=[NSURL fileURLWithPath:audioString];
		//audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:nil];
        videoPlayer.contentURL = url1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

        //logoimage= [videoPlayer thumbnailImageAtTime:(NSTimeInterval)1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [videoPlayer prepareToPlay];
        videoPlayer.fullscreen=YES; 
        [videoPlayer play];
    }
    else
    {
        [videoPlayer.view removeFromSuperview];
        [videoPlayer release];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}
}
-(void)exitMoviePlayer
{
//    [videoPlayer.view removeFromSuperview];
}
-(IBAction) playAudio
{
    [activity startAnimating];
	//[self FetchVideo];
	
	/*[[NSFileManager defaultManager] createFileAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.mp3"] contents:sounds attributes:nil];
	NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.mp4"]);
	
	
	videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.mp4"]]];*/
    
   }
-(IBAction) stop
{
	[videoPlayer stop];
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
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",id_int_video];
	[database1 executeUpdate:temp];
	[database1 close];
	
	
	for (int i = 0; i < [recordArray count]; i++)
	{	

		
		NSString *txtString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,[recordArray objectAtIndex:i]];
		
		NSString *myPathDocs =  [documentsDir stringByAppendingPathComponent:txtString];
		NSLog(@"myPathDocs::%@",myPathDocs);
		manager = [NSFileManager defaultManager];
		
		[manager removeItemAtPath:myPathDocs error:NULL];
		NSLog(@"recordPathArray::%@",recordPathArray);
	}
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:@"/.VideoFile"];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	
	// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	NSString *LogoString=[NSString stringWithFormat:@"/.LogoImage/%@.png",imagename_string_video];
	NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	[manager removeItemAtPath:myFilePath2 error:NULL];
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	imageBool=YES;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	
	NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
	
	NSData *webData = [NSData dataWithContentsOfURL:videoURL];
	
	NSArray *dirPaths;
	NSString *docsDir;
    NSDate* date = [NSDate date];
    
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HHmmssyyyyMMdd"];
	NSString* str = [formatter stringFromDate:date];
    
	NSError *error;
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
    
    NSString *folderstring = [docsDir stringByAppendingPathComponent:@"/.VideoFile"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
    
    
	NSString *audioname=[[NSString stringWithFormat:@"%@.mp4",str] retain];
	NSLog(@"audioname::%@",audioname);
	NSString *Foldername=[NSString stringWithFormat:@"/.VideoFile/"];
	NSString *soundFilePath1 = [docsDir
                                stringByAppendingPathComponent:Foldername];
	if(![[NSFileManager defaultManager] fileExistsAtPath:soundFilePath1])
		[[NSFileManager defaultManager] createDirectoryAtPath:soundFilePath1 withIntermediateDirectories:NO attributes:nil error:&error];
	
    
	NSString *soundFilePath=[[soundFilePath1 stringByAppendingString:[NSString stringWithFormat:@"/%@",audioname]] retain];
	//NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createFileAtPath:soundFilePath
						 contents:webData 
					   attributes:nil];
//	name++;
    [recordArray addObject:audioname];
	[recordPathArray addObject:soundFilePath];
    videoPlayer=[[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    logoimage = [videoPlayer thumbnailImageAtTime:(NSTimeInterval)1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    tempImageview.image = logoimage;
	[picker dismissModalViewControllerAnimated:YES];
    playButton.enabled =YES;
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
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",id_int_video];
				
				
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item archived." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else if(archived_int==1)
			{
				NSLog(@"Remove Archived Label");
				temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",id_int_video];
				
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
    
    
    NSArray *temp =[imagename_string_video  componentsSeparatedByString:@","] ;
    // recordArray = [[NSMutableArray arrayWithArray:temp] retain];
   // NSLog(@"recordArray::%@",recordArray);
	
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
        [picker addAttachmentData:data1 mimeType:@"application/mp4" fileName:[NSString stringWithFormat:@"%@",[temp objectAtIndex:i]]];
    }
	/*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_video];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
    NSLog(@"getImagePath::%@",getImagePath);
	
	NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
	[picker addAttachmentData:data1 mimeType:@"application/mp4" fileName:[NSString stringWithFormat:@"%@",imagename_string_video]];*/
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
    [self setActivity:nil];
    [self setTempImageview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [activity release];
    [tempImageview release];
    [super dealloc];
}


@end
