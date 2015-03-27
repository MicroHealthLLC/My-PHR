//
//  SettingViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 01/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import"SettingDetail.h"
#import"DropBoxViewController.h"
@implementation SettingViewController
@synthesize btnPassCode,passswitch;
int  OrderNoString;
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
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"switch"]) {
        [passswitch setOn:YES animated:YES];
        
    } 
    else
    {
     [passswitch setOn:NO animated:YES];
    }
    
	btnPassCode.userInteractionEnabled=NO;
	
}
-(void)viewWillAppear:(BOOL)animated
{
    [self FetchTotalNo]; 
    //[self FetchData];
    [super viewWillAppear:animated];
}

-(IBAction)switchingbtn:(id)sender {
	
	if([passswitch isOn])
	{
        NSLog(@"ONN");
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"switch"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"switch"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		NSLog(@"OFF");
	}
}

-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)FetchData
{
	DataString=[[NSString alloc]init];
	documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	database1 = [FMDatabase databaseWithPath:databasePath]; 
	[database1 open];
	
	
	DataArray=[[NSMutableArray alloc]init];
	FMResultSet *results = [database1 executeQuery:@"select m.modify_date, t.f_name, mt.Module_data, m.title from MedicalHistory m, tb_FamilyMember t,Module_table mt where m.family_id = t.family_id and m.module_id = mt.module_id order by m.ordernum"];	
	//FMResultSet *results1 = [database1 executeQuery:@"select count(*) from tb_FamilyMember"];	

	while([results next]) {
		
		SettingDetail  *objSettingdetails=[[SettingDetail alloc]init];
		
		objSettingdetails.str_date=[results stringForColumn:@"modify_date"];
		objSettingdetails.str_f_name=[results stringForColumn:@"f_name"];
		objSettingdetails.str_Module_data=[results stringForColumn:@"Module_data"];
		objSettingdetails.str_title=[results stringForColumn:@"title"];
		
	
		NSDateFormatter *DateFormat = [[NSDateFormatter alloc] init];
		[DateFormat setDateFormat:@"EEE MMM d yyyy HH:mm:ss a"];
		NSDate *date=[DateFormat dateFromString:objSettingdetails.str_date];
		
		NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
		[inFormat setDateFormat:@"MMM d, yyyy HH:mm:ss a"];
		
		NSString *parsed = [inFormat stringFromDate:date];
		
		DataString=[DataString stringByAppendingString:parsed];
		DataString=[DataString stringByAppendingString:[NSString stringWithFormat:@"<br>FH %@:",objSettingdetails.str_f_name]];
		DataString=[DataString stringByAppendingString:objSettingdetails.str_Module_data];
		DataString=[DataString stringByAppendingString:[NSString stringWithFormat:@"<br>FH Title:%@<br><br>", objSettingdetails.str_title]];
		
		NSLog(@"DataString::%@",DataString);
		
	}	
	
	
	[database1 close];
}
-(void)FetchTotalNo
{
	
	documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	NSLog(@"%@",databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		
		//const char *sqlStatement = "select family_id, f_name,l_name,image,ordernum from tb_FamilyMember";
		const char *sqlStatement = "select count(*) from tb_FamilyMember";
		
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
	//	totalString=[NSString stringWithFormat:@"Family Histories %d Peopele",OrderNoString];
			//		 NSLog("totalString::%@",totalString);
		// Release the compiled statement from memory
		sqlite3_finalize(statement);    
		sqlite3_close(database);
	}
	
	
	
}
-(IBAction)Email
{
	EmailBool=YES;
	/*totalString=[[NSString alloc]init];
	totalString=[NSString stringWithFormat:@"Family Histories %d Peopele",OrderNoString];
	NSLog("totalString::%@",totalString);*/
	
	[self FetchData];
	[self email:@"" toString:@""];
}
-(IBAction)DeleteHistory
{
	documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
	database1 = [FMDatabase databaseWithPath:databasePath];    
	[database1 open];
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory"];
	[database1 executeUpdate:temp];
	[database1 close];
	
	
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage"];
    NSString *logoString=[NSString stringWithFormat:@"/.LogoImage"];
	NSLog(@"imagenamestring::%@",imageString);
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
    NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:logoString];
	
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
    [manager removeItemAtPath:myFilePath2 error:NULL];
	
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Family Histories Deleted"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(IBAction)PassLock
{
	
}
-(IBAction)DropBox
{
	DropBoxViewController *viewcontroller=[[DropBoxViewController alloc]initWithNibName:@"DropBoxViewController" bundle:nil];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
	
}
-(IBAction)FeedBack
{
	EmailBool=NO;
	[self email:@"" toString:@"feedback@microhealthonline.com"];
}

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
	if(EmailBool==YES)
	{
		[picker setSubject:[NSString stringWithFormat:@"Family Histories %d People",OrderNoString]];
		[picker setMessageBody:DataString isHTML:YES];
	}
	if(EmailBool==NO)
	{
		[picker setSubject:@"FeedBack For FamilyHealthRecord"];
		//[picker setMessageBody:DataString isHTML:YES];
	}
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
	
    
	// Fill out the email body text
	//[picker setMessageBody:emailBody isHTML:NO];
   	
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
