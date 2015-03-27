//
//  RestoreViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 20/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RestoreViewController.h"
#import "BackUpDetail.h"
#import "ZipArchive.h"

@implementation RestoreViewController
@synthesize leftbutton,rightbutton,tblview;
@synthesize activityindicator,btnCancel,imageview_backup;
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
	leftbutton.title=@"Back";
	rightbutton.title=@"Edit";
	[self FetchData];
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	
	NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
	stringArray1=[[NSMutableArray arrayWithArray:[userdefault objectForKey:@"MyStrings"]]retain];
	NSLog(@"stringArray1::%@ ",stringArray1);
}
-(void)FetchData
{
	labelNameArray=[[NSMutableArray alloc] init];
	NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentDir=[documentPath objectAtIndex:0];
	NSString *databasePath=[documentDir  stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
	FMDatabase *database=[FMDatabase databaseWithPath:databasePath];
	[database open];
	
	//HistoryArray=[[NSMutableArray alloc]init];
	NSString *executeString=[NSString stringWithFormat:@"select id, datemed, revisions, notes, pics, voice,files, videos, drawings  from backupmed"];
	FMResultSet *results = [database executeQuery:executeString];	
	
	while([results next]) {
		BackUpDetail  *objMemberdetails=[[BackUpDetail alloc]init];
	
		objMemberdetails.str_revisions=[results stringForColumn:@"revisions"];
		objMemberdetails.str_created_date=[results stringForColumn:@"datemed"];
		
		objMemberdetails.int_id=[results intForColumn:@"id"];
		objMemberdetails.int_notes=[results intForColumn:@"notes"];
		objMemberdetails.int_pics=[results intForColumn:@"pics"];
		objMemberdetails.int_voice=[results intForColumn:@"voice"];
		objMemberdetails.int_file=[results intForColumn:@"files"];
		objMemberdetails.int_video=[results intForColumn:@"videos"];
		objMemberdetails.int_drawing=[results intForColumn:@"drawings"];
		
		[labelNameArray addObject:objMemberdetails];
		// [labelNameArray addObject:objMemberdetails.str_title];
	}
	NSLog(@"labelNameArray::%@",labelNameArray);
}
- (DBRestClient *)restClient {
	if (!restClient) 
	{
		restClient =[[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}
-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
	
}
-(IBAction)Done
{
	if(!EditBool)
	{
	rightbutton.title=@"Done";
	EditBool=YES;
		leftbutton.enabled=NO;
		tblview.editing=YES;
	}
	else
	{
	rightbutton.title=@"Edit";
		EditBool=NO;
		leftbutton.enabled=YES;
		tblview.editing=NO;
	}

}

#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [stringArray1 count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	else
	{
		
	}
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[stringArray1 objectAtIndex:indexPath.row]];
//BackUpDetail *objUserdeatil=[labelNameArray objectAtIndex:indexPath.row];
	NSString *str=[NSString stringWithFormat:@"%@ Notes,%@ pics,%@ voice,%@ Files,%@ Videos,%@ Drawings memos",[dic objectForKey:@"notes_backup"],[dic objectForKey:@"pics_backup"],[dic objectForKey:@"voice_backup"],[dic objectForKey:@"files_backup"],[dic objectForKey:@"video_backup"],[dic objectForKey:@"drawings_backup"]];
	cell.textLabel.text=str;
	cell.detailTextLabel.text=[NSString stringWithFormat:@"Backed up on:%@",[dic objectForKey:@"CreateDate_backup"]];
	cell.font=[UIFont systemFontOfSize:11];
	cell.detailTextLabel.font=[UIFont systemFontOfSize:10];

	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//strname=[[NSString alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[stringArray1 objectAtIndex:indexPath.row]];
//	BackUpDetail *objUserdeatil=[labelNameArray objectAtIndex:indexPath.row];
	//strname=[[NSString stringWithFormat:@"%d Notes,%d pics,%d voice,%d Files,%d Videos,%d Drawings memos.zip",objUserdeatil.int_notes,objUserdeatil.int_pics,objUserdeatil.int_voice,objUserdeatil.int_file,objUserdeatil.int_video,objUserdeatil.int_drawing] retain];
	strname=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"Filename_backup"]] retain];
	NSLog(@"strname::%@",strname);
	
	UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Restore",nil];
	[sheet showInView:self.view];
	[sheet release];
	
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[stringArray1 objectAtIndex:indexPath.row]];

    [stringArray1 removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:stringArray1 forKey:@"MyStrings"];
	
	[self.tblview reloadData];
	
	NSString *strpath=[NSString stringWithFormat:@"/%@",[dic objectForKey:@"Filename_backup"]];
	
	[[self restClient] deletePath:strpath];
}

-(IBAction)Cancel
{
	NSString *str1=[NSString stringWithFormat:@"/%@",strname];
	NSLog(@"str1::%@",str1);
	[[self restClient] cancelFileLoad:str1];
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	leftbutton.enabled=YES;
	rightbutton.enabled=YES;
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
			
			btnCancel.hidden=NO;
			imageview_backup.hidden=NO;
			progrssview.hidden=NO;
			activityindicator.hidden=NO;
			NSLog(@"Restore:");
			
			NSString *pathString=NSHomeDirectory();
			 
			 pathString=[pathString stringByAppendingPathComponent:strname];
			 
			NSLog(@"pathString::%@",pathString);
			NSString *str1=[NSString stringWithFormat:@"/%@",strname];
			NSLog(@"str1::%@",str1);
			 [[self restClient] loadFile:str1 intoPath:pathString];
			leftbutton.enabled=NO;
			rightbutton.enabled=NO;
			break;
		}
				
	}
	
}




- (void)restClient:(DBRestClient*)client restoredFile:(DBMetadata *)fileMetadata
{
}
- (void)restClient:(DBRestClient*)client restoreFileFailedWithError:(NSError *)error
{
    NSLog(@"restore Error%@",error.description);
}
-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath
{
	
	NSLog(@"strname::%@",strname);
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory = [paths objectAtIndex:0];
	
	NSString *pathString=[NSHomeDirectory() stringByAppendingPathComponent:strname];
    
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
	[activityindicator stopAnimating];
	
	UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Restore Successful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alerview show];
	[alerview release];
	
	
	btnCancel.hidden=YES;
	imageview_backup.hidden=YES;
	progrssview.hidden=YES;
	activityindicator.hidden=YES;
	
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		leftbutton.enabled=YES;
		rightbutton.enabled=YES;
		
		NSString *archivePath = [NSHomeDirectory() stringByAppendingPathComponent:strname];
		[[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
	}
}
-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
	UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Restore UnSuccessful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alerview show];
	[alerview release];
    NSLog(@"Fail %@",error.description);
}
-(void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath
{
	[activityindicator startAnimating];
    progrssview.progress=progress;
    //progrssview.progress=progress;
    
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
