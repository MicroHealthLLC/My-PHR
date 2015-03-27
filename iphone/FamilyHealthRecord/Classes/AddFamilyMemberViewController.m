//
//  AddFamilyMemberViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 04/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AddFamilyMemberViewController.h"
//#import "FMDatabase.h"


@implementation AddFamilyMemberViewController
@synthesize imageview1,imageview2,txtfname,txtlname;
int OrderNoString;

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
	txtfname.delegate=self;
	txtlname.delegate=self;
	
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
		const char *sqlStatement = "SELECT MAX(ordernum) from tb_FamilyMember";

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
	[self FetchMaxOrderNo];
	
	if([txtfname.text isEqualToString:@""])
	{
	    
		NSLog(@"Ketan");
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please select an image and enter the first name of family member." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=NO;
			
	}
	else
	{
	NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"HHmmssyyyyMMdd"];
    NSString* str = [formatter stringFromDate:date];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	database1 = [FMDatabase databaseWithPath:databasePath]; 
		
		[database1 open];
		
		//NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
		
		NSString *query = [NSString stringWithFormat:@"INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')",OrderNoString+1,txtfname.text,txtlname.text,str];
		[database1 executeUpdate:query];
		[database1 close];
		
	NSError *error;
	NSString *imagename=[NSString stringWithFormat:@"%@.png",str];
  NSString *folderstring = [documentsDir stringByAppendingPathComponent:@"/.MyFolder"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];

	NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
	
	UIImage *image = imageview1.image; // imageView is my image from camera
	
	NSData *imageData = UIImagePNGRepresentation(image);
	
	[imageData writeToFile:savedImagePath atomically:NO];  
	
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Family Member successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
	}
	}
		


-(IBAction)Cancel
{
	[self.navigationController popViewControllerAnimated:YES];
	NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"hhmmssyyyyMMdd"];
    NSString* str = [formatter stringFromDate:date];
	NSLog(@"%@",str);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[txtfname resignFirstResponder];
	[txtlname resignFirstResponder];
	return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	//UITouch *touch = [[UITouch alloc] init]; 
	UITouch *touch= [touches anyObject];
	//UITouch *touch=[ touches  anyObject];
    
	if (CGRectContainsPoint([self.imageview1 frame], [touch locationInView:self.view]))
	{
		
		
		
		UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo",nil];
	
		[sheet showInView:self.view];
		[sheet release];
		NSLog(@"Pressed");
		
	}
}
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) 
	{ return; 
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
-(void) imagePickerController:(UIImagePickerController *)UIPicker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
	[UIPicker dismissModalViewControllerAnimated:YES];
	
	imageview1.image=[info objectForKey:UIImagePickerControllerEditedImage];
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
