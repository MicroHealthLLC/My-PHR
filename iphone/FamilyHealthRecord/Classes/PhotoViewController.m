
//
//  PhotoViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 17/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FamilyHealthRecordAppDelegate.h"

@implementation PhotoViewController
@synthesize imageview;
@synthesize leftbutton,rightbutton,txtTitle,appDelegate;
int OrderNoString;
@synthesize title_string,id_int,imagename_string;
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
	NSLog(@"appDelegate.FamMember_String::%@",appDelegate.FamMember_String);
    
    NSError *error;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];

    NSString *folderstring = [documentsDirectory1 stringByAppendingPathComponent:@"/.ModuleImage"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
	appDelegate=[[UIApplication sharedApplication]delegate];
	
	
	leftbutton.title=@"Cancel";
	rightbutton.title=@"Done";
	txtTitle.delegate=self;
	NSLog(@"FamilyID_String::%@",appDelegate.FamilyID_String);
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		txtTitle.text= title_string;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
		NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string];
		NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
		
		UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
		imageview.image=img;
		 //data = [NSData dataWithContentsOfFile:getImagePath];
		bottom_imageview.hidden=NO;
		btn_delete.hidden=NO;
		btn_Forward.hidden=NO;
		Action_Bool=NO;
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
	   Action_Bool=YES;
	   btn_Archive.hidden=YES;
	   UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
       
       [sheet showInView:self.view];
       [sheet release];
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
-(IBAction)Done
{
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
		{
			[self InsertPhoto];
		}
		if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
		{
				[self UpdatePhoto];
		}
		
}
-(void)UpdatePhoto
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
		NSString *query = [NSString stringWithFormat:@"UPDATE MedicalHistory SET title='%@',modify_date='%@' where id='%i'",txtTitle.text,CreatedDate,id_int];
		[database1 executeUpdate:query];
		[database1 close];
		
		NSError *error;
		NSString *imagename=[NSString stringWithFormat:@"%@.png",imagename_string];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:error];
		
		NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
		
		UIImage *image = imageview.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(image);
		
		[imageData writeToFile:savedImagePath atomically:NO];  
		
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Image successfully Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
	}
}
-(void)InsertPhoto
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
		NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id,archive) values ('%i','%@','3','%@','%@','%@','%@','%@','0')",OrderNoString+1,str,txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		
		[database1 executeUpdate:query];
		[database1 close];
		
		NSError *error;
		NSString *imagename=[NSString stringWithFormat:@"%@.png",str];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
		
		NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
		
		UIImage *image = imageview.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(image);
		
		[imageData writeToFile:savedImagePath atomically:NO];  
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Image successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",id_int];
	[database1 executeUpdate:temp];
	[database1 close];
	
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string];

	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
	// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	imageBool=YES;
}
-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
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

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(Action_Bool==YES)
	{
		if (buttonIndex == actionSheet.cancelButtonIndex) 
		{ 
			[self.navigationController popViewControllerAnimated:YES];
			return; 
		}
	switch (buttonIndex) {
		case 0:
		{
			NSLog(@"Camera");
			UIImagePickerController *picker=[[UIImagePickerController alloc] init];
			picker.delegate=self;
			picker.sourceType=UIImagePickerControllerSourceTypeCamera;
			[picker setAllowsEditing:YES];
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
			[picker setAllowsEditing:YES];
			[self presentModalViewController:picker animated:YES];
			[picker release];
			break;
		}
	}
			
	}
	else if(Action_Bool==NO)
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
				[self displayComposerSheet];
				NSLog(@"Messages");
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
				   NSLog(@"Archived Lagel");
					temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",id_int];
 
					
					UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item archived." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert show];
					[alert release];
				}
				else if(archived_int==1)
				{
					NSLog(@"Remove Archived Lagel");
					temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",id_int];
					
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
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
	
	imageview.image=[info objectForKey:UIImagePickerControllerEditedImage];
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
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
		NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string];
		NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
		
		NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
		[picker addAttachmentData:data1 mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png",imagename_string]];
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


@end
