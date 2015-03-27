//
//  DropBoxViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 11/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DropBoxViewController.h"
#import "ZipArchive.h"
#import <DropboxSDK/DropboxSDK.h>
#import "RestoreViewController.h"

@implementation DropBoxViewController

@synthesize leftbarbutton,linkButton,backupButton,restoreButton,progrssview,activityindicator;
@synthesize btn1,btn2,btn3;
@synthesize btnCancel,imageview_backup;

//API Key::fx8tp64v0sunt8j
//Secrete Key::q0medu6zf84lpr7
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([[DBSession sharedSession] isLinked]) {
		restoreButton.enabled=YES;
		backupButton.enabled=YES;
		btn2.enabled=YES;
		btn3.enabled=YES;
		[linkButton setTitle:@"                  Unlink From Dropbox" forState:UIControlStateNormal];
    }
	else {
		restoreButton.enabled=NO;
		backupButton.enabled=NO;
		btn2.enabled=NO;
		btn3.enabled=NO;
		[linkButton setTitle:@"                  Link Dropbox" forState:UIControlStateNormal];
	}

	/*else if[[DBSession sharedSession] unlinkAll])
	{
		restoreButton.enabled=NO;
		backupButton.enabled=NO;
	}*/
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	[self totalCountNo];
}
- (DBRestClient *)restClient {
	if (!restClient) 
	{
		restClient =[[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;

		}
	return restClient;
}
-(IBAction)setting
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)Link
{
    if (![[DBSession sharedSession] isLinked]) {
		//[[DBSession sharedSession] link];
		 [[DBSession sharedSession] linkFromController:self];
		restoreButton.enabled=YES;
		backupButton.enabled=YES;
		btn2.enabled=YES;
		btn3.enabled=YES;
		[linkButton setTitle:@"                  Unlink From Dropbox" forState:UIControlStateNormal];

    } else {
        [[DBSession sharedSession] unlinkAll];
        [[[[UIAlertView alloc] 
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
		restoreButton.enabled=NO;
		backupButton.enabled=NO;
		btn2.enabled=NO;
		btn3.enabled=NO;
		[linkButton setTitle:@"                  Link Dropbox" forState:UIControlStateNormal];

       // [self updateButtons];
    }
	
}
- (void)updateButtons {
    NSString* title = [[DBSession sharedSession] isLinked] ? @"             Unlink Dropbox" : @"             Link Dropbox";
    [linkButton setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
	//backupButton.enabled=NO;
	//restoreButton.enabled=NO;
}
-(IBAction)Backup
{
	
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HHmmssyyyyMMdd"];
	NSString *strdate= [formatter stringFromDate:date];
	timeString=[[NSString stringWithFormat:@"%@_File.zip",strdate] retain];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [paths objectAtIndex:0];
	BOOL isDir=NO;
	NSArray *subpaths;
	NSString *exportPath = docDirectory;
	NSFileManager *fileManager = [NSFileManager defaultManager];    
	if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir)
	{
		subpaths = [fileManager subpathsAtPath:exportPath];
		
	}
 	NSString *strname=[NSString stringWithFormat:@"%@ Notes,%@ pics,%@ voice,%@ Files,%@ Videos,%@ Drawings memos.zip",[dataArray objectAtIndex:0],[dataArray objectAtIndex:2],[dataArray objectAtIndex:1],[dataArray objectAtIndex:3],[dataArray objectAtIndex:4],[dataArray objectAtIndex:5]];

	NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:timeString];
	NSLog(@"archivePath::%@",archivePath);
	
	ZipArchive *archiver = [[ZipArchive alloc] init];
	//[archiver CreateZipFile2:archivePath];
	[archiver CreateZipFile2:archivePath Password:@"1234"];
	
	for(NSString *path in subpaths)
	{
		NSString *longPath = [exportPath stringByAppendingPathComponent:path];
		if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir)
		{
			[archiver addFileToZip:longPath newname:path];      
		}
	}
	BOOL successCompressing = [archiver CloseZipFile2];
	if(successCompressing)
		NSLog(@"Success");
	else
		NSLog(@"Fail");
	
	NSString *file1=[NSString stringWithFormat:timeString];
	//NSString *destDir = @"home/Apps/HealthInfo/";
	NSString *destDir = @"/";
	
	NSString *filename=[NSHomeDirectory() stringByAppendingPathComponent:file1];
	NSLog(@"filename%@",filename);
	NSLog(@"docDirectory%@",docDirectory);
	/*[[self restClient] uploadFile:file1 toPath:destDir
					withParentRev:nil fromPath:filename];*/
	[[self restClient] uploadFile:file1 toPath:destDir fromPath:filename];
	
	btnCancel.hidden=NO;
	imageview_backup.hidden=NO;
	progrssview.hidden=NO;
	activityindicator.hidden=NO;
	leftbarbutton.enabled=NO;
	linkButton.enabled=NO;
	backupButton.enabled=NO;
	restoreButton.enabled=NO;
	btn1.enabled=NO;
	btn2.enabled=NO;
	btn3.enabled=NO;
}
-(IBAction)Restore
{
	 RestoreViewController *viewcontroller=[[RestoreViewController alloc]initWithNibName:@"RestoreViewController" bundle:nil];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
	
	/*NSString *pathString=NSHomeDirectory();
	
	pathString=[pathString stringByAppendingPathComponent:@"Documents.zip"];
	
	[[self restClient] loadFile:@"/Documents.zip" intoPath:pathString];*/
	
}
-(void)InsertData
{
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"d/MM/yyyy hh:mm a"];
	NSString *CreatedDate=[formatter stringFromDate:date];

	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setObject:CreatedDate forKey:@"CreateDate_backup"];
	[dic setObject:timeString forKey:@"Filename_backup"];
	[dic setObject:[dataArray objectAtIndex:0] forKey:@"notes_backup"];
	[dic setObject:[dataArray objectAtIndex:2] forKey:@"pics_backup"];
	[dic setObject:[dataArray objectAtIndex:1] forKey:@"voice_backup"];
	[dic setObject:[dataArray objectAtIndex:3] forKey:@"files_backup"];
	[dic setObject:[dataArray objectAtIndex:4] forKey:@"video_backup"];
	[dic setObject:[dataArray objectAtIndex:5] forKey:@"drawings_backup"];

	NSLog(@"Dic::%@",dic);
	
	NSMutableArray *stringArray=[[NSMutableArray alloc] init];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyStrings"]];
    if ([temp count]>0) {
        stringArray =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyStrings"]];

    }
		NSLog(@"stringArray::%@",stringArray);
	[stringArray addObject:dic];
	[[NSUserDefaults standardUserDefaults] setObject:stringArray forKey:@"MyStrings"];
	NSLog(@"stringArray::%@",stringArray);
}

-(void)totalCountNo
{
	dataArray=[[NSMutableArray alloc] init];
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		
		
		for (int i = 1; i <= 6; i++)
		{	
		
		//const char *sqlStatement = "select family_id, f_name,l_name,image,ordernum from tb_FamilyMember";
			//const char *sqlStatement =[NSString stringWithFormat:@"select count(*) from MedicalHistory where medicaldatatype_id ='%d'",i];
			NSString *sqlStatement =[NSString stringWithFormat:@"select count(*) from MedicalHistory where medicaldatatype_id ='%d'",i];

		if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)== SQLITE_OK)
		{
			NSLog(@"added");
			//sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                //				NSString *aDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				//int *OrderNoString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				 int OrderNoString= (int)sqlite3_column_int(statement, 0);
				NSString *tempString=[NSString stringWithFormat:@"%d",OrderNoString];
									  [dataArray addObject:tempString];
				
				NSLog(@"OrderNoString::%d",OrderNoString);
				
			}
		}
		NSLog(@"dataArray::%@",dataArray);
			
		}
		//	totalString=[NSString stringWithFormat:@"Family Histories %d Peopele",OrderNoString];
		//		 NSLog("totalString::%@",totalString);
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
		sqlite3_close(database);
	}
	
}
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
			  from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
	
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
	[activityindicator stopAnimating];
	UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Backup Successful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alerview show];
	[alerview release];
	
	
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	success_bool=YES;
	//[self InsertData];
}
- (void)restoreFile:(NSString *)path toRev:(NSString *)rev
{
	
}
- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
	UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"BackUp UnSuccessful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alerview show];
	[alerview release];
	success_bool=NO;
   /* btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;*/
}
- (void)restClient:(DBRestClient*)client restoredFile:(DBMetadata *)fileMetadata
{
	
}
- (void)restClient:(DBRestClient*)client restoreFileFailedWithError:(NSError *)error
{
    NSLog(@"restore Error%@",error.description);
	NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:timeString];
	[[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
}
-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [paths objectAtIndex:0];
	
	NSString *pathString=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents.zip"];
    
	ZipArchive *archiver = [[ZipArchive alloc] init];
	
	
	
    if([archiver UnzipOpenFile:pathString Password:@"1234"] )
    {
        BOOL ret = [archiver UnzipFileTo:docDirectory overWrite:YES];
        if(NO == ret)
        {
            
        }
        [archiver UnzipCloseFile];
    }
    [archiver release];
    NSLog(@"restore comlete");
	
}
-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    NSLog(@"Fail %@",error.description);
}
-(void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath
{
  
    progrssview.progress=progress;
    
}
-(void)restClient:(DBRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
	[activityindicator startAnimating];
    progrssview.progress=progress;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(success_bool==YES)
	{
		[self InsertData];
		NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:timeString];
        [[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
	if(buttonIndex==0)
		{
		btnCancel.hidden=YES;
			imageview_backup.hidden=YES;
			progrssview.hidden=YES;
			activityindicator.hidden=YES;
			
			leftbarbutton.enabled=YES;
			linkButton.enabled=YES;
			backupButton.enabled=YES;
			restoreButton.enabled=YES;
			btn1.enabled=YES;
			btn2.enabled=YES;
			btn3.enabled=YES;
		}
	}
	else {
		if(buttonIndex==0)
		{
			btnCancel.hidden=YES;
			imageview_backup.hidden=YES;
			progrssview.hidden=YES;
			activityindicator.hidden=YES;
			
			leftbarbutton.enabled=YES;
			linkButton.enabled=YES;
			backupButton.enabled=YES;
			restoreButton.enabled=YES;
			btn1.enabled=YES;
			btn2.enabled=YES;
			btn3.enabled=YES;
		}
	}

}
-(IBAction)Cancel
{
	NSString *delete_path=[NSString stringWithFormat:@"/%@",timeString];
	//[[self restClient] deletePath:delete_path];
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	leftbarbutton.enabled=YES;
	linkButton.enabled=YES;
	backupButton.enabled=YES;
	restoreButton.enabled=YES;
	btn1.enabled=YES;
	btn2.enabled=YES;
	btn3.enabled=YES;
	[[self restClient]  cancelFileUpload:delete_path];
	
	NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:timeString];
	[[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
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
