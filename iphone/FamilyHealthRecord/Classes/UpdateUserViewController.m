//
//  UpdateUserViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 09/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateUserViewController.h"
#import "FMDatabase.h"
#import "MyFamilyViewController.h"
#import "FamilyHealthRecordAppDelegate.h"

@implementation UpdateUserViewController
@synthesize imageview1,imageview2,txtfname,txtlname;
@synthesize getFnameString,getLnameString,getImageString,getFamilyID,appDelegate;

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
	appDelegate=[[UIApplication sharedApplication]delegate];
	txtfname.delegate=self;
	txtlname.delegate=self;
	txtfname.text=getFnameString;
	txtlname.text=getLnameString;
	NSLog(@"FamiliID::%i",getFamilyID);
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.MyFolder/%@.png",getImageString];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
	
	UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
	
	imageview1.image = img;
}
-(IBAction)Back
{
	appDelegate.UpdateString=@"Add";
	[self.navigationController popViewControllerAnimated:YES];
	
}
-(IBAction)Done
{
/*	if(imageview1.image==nil)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please select an image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=NO;
	}
	else 
	{*/
	if([txtfname.text isEqualToString:@""])
	   {
		   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Please select an image and enter the first name of family member." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		   [alert show];
		   [alert release];
		   imageBool=NO;
	   }
	   else
	   {
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    //FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
 FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
	 [database open];
	
	//INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
	NSString *query = [NSString stringWithFormat:@"UPDATE  tb_FamilyMember SET f_name='%@' WHERE family_id='%i'",txtfname.text,getFamilyID];
   
	[database executeUpdate:query];
	 [database close];
		   NSError *error;
		   NSString *imagename=[NSString stringWithFormat:@"%@.png",getImageString];
		   NSString *folderstring = [documentsDir stringByAppendingPathComponent:@"/.MyFolder"];
		   if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			   [[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:error];
		   
		   NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
		   
		   UIImage *image = imageview1.image; // imageView is my image from camera
		   
		   NSData *imageData = UIImagePNGRepresentation(image);
		   
		   [imageData writeToFile:savedImagePath atomically:NO]; 
		   
		   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Family Member successfully Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		   [alert show];
		   [alert release];
		   imageBool=YES;
	   }
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
		/*UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Image" message:@"Please Select Image" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Gallery",@"Camera",nil]; 
		 [alert show];
		 [alert release];*/
		
		
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
			appDelegate.UpdateString=@"Add";
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
