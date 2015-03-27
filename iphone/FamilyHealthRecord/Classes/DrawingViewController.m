//
//  DrawingViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 14/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawingViewController.h"
#import "FamilyHealthRecordAppDelegate.h"

@implementation DrawingViewController
@synthesize leftbutton,rightbutton,txtTitle;
@synthesize btnUndo;
@synthesize btnRedo;
@synthesize sliderVIew;
@synthesize slide,appDelegate;
int OrderNoString;
@synthesize title_string_Drawing,id_int_Drawing,imagename_string_Drawing;
@synthesize btnPen,btnEraser,btnColor;
int ButtonClick;
@synthesize colorSwatch;
const float* colors ;
float red,green,blue,alpha;
@synthesize bottom_imageview,btn_Forward,btn_delete,archived_int,btn_Archive,sliderVIew1;
@synthesize  imageview1,imageview2,imageview3,imageview4,imageview5,lbl_title;
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
	red=0.000000;
	green=0.000000;
	blue=0.000000;
	alpha=1.000000;
	ButtonClick=1;
	leftbutton.title=@"Cancel";
	rightbutton.title=@"Done";
	txtTitle.delegate=self;
	
	lbl_title.text=appDelegate.FamMember_String;
    arrimageData = [[NSMutableArray alloc] init];
	
   // drawImage.frame = self.view.frame;
   // drawImage.frame=CGRectMake(0, 103, 320, 285);
    //[self.view addSubview:drawImage];
    mouseMoved = 0;
    insertIndex = 0;
	sliderVIew1.hidden=YES;
	sliderVIew.hidden=YES;
    //eraserValue=sliderVIew.value;
    penValue=sliderVIew.value;
	
	NSError *error;
	
   NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
    NSString *folderstring = [documentsDirectory stringByAppendingPathComponent:@"/.ModuleImage"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:&error];
	
	appDelegate=[[UIApplication sharedApplication]delegate];
	NSLog(@"FamilyID_String::%@",appDelegate.FamilyID_String);
	NSLog(@"ModuleID_String::%@",appDelegate.ModuleID_String);
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		drawImage = [[UIImageView alloc] initWithImage:nil];
        drawImage.frame=CGRectMake(0, 103, 320, 218);
        sliderVIew.frame=CGRectMake(50, 320, 207, 22);
        sliderVIew1.frame=CGRectMake(55, 322, 207, 22);
        btnColor.frame=CGRectMake(13, 350, 52, 32);
        btnPen.frame=CGRectMake(73, 350, 52, 32);
        btnEraser.frame=CGRectMake(134, 350, 52, 32);
        btnUndo.frame=CGRectMake(196, 350, 52, 32);
        btnRedo.frame=CGRectMake(255, 350, 52, 32);
        imageview1.frame=CGRectMake(30, 358, 15, 15);
        imageview2.frame=CGRectMake(91, 358, 15, 15);
        imageview3.frame=CGRectMake(152, 358, 15, 15);
        imageview4.frame=CGRectMake(214, 358, 15, 15);
        imageview5.frame=CGRectMake(273, 358, 15, 15);
        [self.view addSubview:drawImage];
		txtTitle.text= title_string_Drawing;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
		NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_Drawing];
		NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
		
		UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
		
		drawImage.image = img;
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
    if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
        drawImage = [[UIImageView alloc] initWithImage:nil];
         drawImage.frame=CGRectMake(0, 103, 320, 285);
        sliderVIew.frame=CGRectMake(50, 387, 207, 22);
        sliderVIew1.frame=CGRectMake(55, 393, 207, 22);
        btnColor.frame=CGRectMake(13, 417, 52, 32);
        btnPen.frame=CGRectMake(73, 417, 52, 32);
        btnEraser.frame=CGRectMake(134, 417, 52, 32);
        btnUndo.frame=CGRectMake(196, 417, 52, 32);
        btnRedo.frame=CGRectMake(255, 417, 52, 32);
        imageview1.frame=CGRectMake(30, 425, 15, 15);
         imageview2.frame=CGRectMake(91, 425, 15, 15);
         imageview3.frame=CGRectMake(152, 425, 15, 15);
         imageview4.frame=CGRectMake(214, 425, 15, 15);
         imageview5.frame=CGRectMake(273, 425, 15, 15);
        [self.view addSubview:drawImage];
		
        bottom_imageview.hidden=YES;
		btn_delete.hidden=YES;
		btn_Forward.hidden=YES;
		btn_Archive.hidden=YES;

        //drawImage = [[UIImageView alloc] initWithImage:nil];
    }
	/*SystemSoundID soundID = 0;
	CFURLRef soundFileURL = (CFURLRef)[NSURL URLWithString:somePathString];
	OSStatus errorCode = AudioServicesCreateSystemSoundID(soundFileURL, &soundID);
	if (errorCode != 0) {
		// Handle failure here
	}*/
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

-(void)InsertDrawing
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
		NSString *query = [NSString stringWithFormat:@"INSERT INTO MedicalHistory (ordernum,data,medicaldatatype_id,title,created_date,modify_date,family_id,module_id,archive) values ('%i','%@','6','%@','%@','%@','%@','%@','0')",OrderNoString+1,str,txtTitle.text,CreatedDate,CreatedDate,appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		
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
		
		NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
		
		UIImage *image = drawImage.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(image);
		
		[imageData writeToFile:savedImagePath atomically:NO];
		
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Image successfully added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
	}
	
		
}
-(void)UpdateDrawing
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
		NSString *query = [NSString stringWithFormat:@"UPDATE MedicalHistory SET title='%@',modify_date='%@' where id='%i'",txtTitle.text,CreatedDate,id_int_Drawing];
		[database1 executeUpdate:query];
		[database1 close];
		
		NSError *error;
		NSString *imagename=[NSString stringWithFormat:@"%@.png",imagename_string_Drawing];
		NSString *Foldername=[NSString stringWithFormat:@"/.ModuleImage/%@_%@",appDelegate.FamilyID_String,appDelegate.ModuleID_String];
		NSString *folderstring = [documentsDir stringByAppendingPathComponent:Foldername];
		if(![[NSFileManager defaultManager] fileExistsAtPath:folderstring])
			[[NSFileManager defaultManager] createDirectoryAtPath:folderstring withIntermediateDirectories:NO attributes:nil error:error];
		
		NSString *savedImagePath = [folderstring stringByAppendingPathComponent:imagename];
		
		UIImage *image = drawImage.image; // imageView is my image from camera
		
		NSData *imageData = UIImagePNGRepresentation(image);
		
		[imageData writeToFile:savedImagePath atomically:NO];  
		
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Image successfully Updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		imageBool=YES;
		
}
}
-(IBAction)Done
{
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Sub"])
	{
		[self InsertDrawing];
	}
	if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
	{
		[self UpdateDrawing];
	}
	
}
-(IBAction)Back
{
	[self.navigationController popViewControllerAnimated:YES];
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
- (void)viewDidUnload
{
    [segment release];
    segment = nil;
    [self setSlide:nil];
    [self setSliderVIew:nil];
    [self setBtnRedo:nil];
    [self setBtnUndo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
   /* if ([touch tapCount] == 2) {
        drawImage.image = nil;
        return;
    }*/
	//    if (insertIndex!=0) {
	//        [segment setEnabled:YES forSegmentAtIndex:3];
	//    }
	//    if (insertIndex!=arrimageData.count-1) {
	//        [segment setEnabled:YES forSegmentAtIndex:4];
	//    }
    if (undoredo==YES) {
        for (int i=insertIndex; i<arrimageData.count; i++) 
        {
            
        }
        while (insertIndex != arrimageData.count-1) {
            [arrimageData removeObjectAtIndex:insertIndex+1];
        }
        undoredo=NO;
    }
	
    if (drawImage.image!=nil) {
        insertIndex++;
        NSLog(@"touch index%i",insertIndex);     
    }
   // eraserValue=sliderVIew.value;
	if(ButtonClick==1)
	{
    penValue=sliderVIew.value;
	}
	else if(ButtonClick==2)
	{
	eraserValue=sliderVIew1.value;
	}
    //lastPoint = [touch locationInView:self.view];
    lastPoint = [touch locationInView:drawImage];
    lastPoint.y -= 10;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (ButtonClick==1)
    {
		
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject]; 
       // CGPoint currentPoint = [touch locationInView:self.view];
          CGPoint currentPoint = [touch locationInView:drawImage];

        currentPoint.y -= 20; // only for 'kCGLineCapRound'
        UIGraphicsBeginImageContextWithOptions(drawImage.frame.size, NO,[[UIScreen mainScreen]scale]);
//        [drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
        {
        [drawImage.image drawInRect:CGRectMake(0, 0, 320, 218)];
        }
        else
        {
        [drawImage.image drawInRect:CGRectMake(0, 0, 320, 285)];
        }
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), penValue);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
	 //   CGContextSetStrokeColor(UIGraphicsGetCurrentContext(), colors);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
		
        lastPoint = currentPoint;
        
        mouseMoved++;
        
        if (mouseMoved == 10) {
            mouseMoved = 0;
        }
    }
	else if (ButtonClick==2)
    {
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject]; 
        //CGPoint currentPoint = [touch locationInView:self.view];
        CGPoint currentPoint = [touch locationInView:drawImage];
        currentPoint.y -= 20; // only for 'kCGLineCapRound'
       // UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO,[[UIScreen mainScreen]scale]);
//        [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
        UIGraphicsBeginImageContextWithOptions(drawImage.frame.size, NO,[[UIScreen mainScreen]scale]);

        if([appDelegate.Str_UpdateFunction isEqualToString:@"Add"])
        {
            [drawImage.image drawInRect:CGRectMake(0, 0, 320, 218)];
        }
        else
        {
            [drawImage.image drawInRect:CGRectMake(0, 0, 320, 285)];
        }
        CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound); //kCGImageAlphaPremultipliedLast);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), eraserValue);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1, 0, 0, 10);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();        
        lastPoint = currentPoint;
        
        mouseMoved++;
        
        if (mouseMoved == 10) {
            mouseMoved = 0;
        }
        
    }
	
	
	
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    /*if ([touch tapCount] == 2) {
        drawImage.image = nil;
        return;
    }*/
    if(!mouseSwiped) {
    
    }
    NSLog(@"touch endindex%i",insertIndex);
    if (mouseSwiped==YES) {
        [arrimageData addObject:drawImage.image];
        insertIndex = arrimageData.count-1;
        if (arrimageData.count>0) {
            btnUndo.enabled=YES;
        }
        btnRedo.enabled=NO;
        NSLog(@"touch imgae"); 
    }
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(IBAction)PenClick
{
	ButtonClick=1;
	sliderVIew1.hidden=YES;
	sliderVIew.hidden=NO;
}
-(IBAction)EraserClick
{
	ButtonClick=2;
	sliderVIew1.hidden=NO;
	sliderVIew.hidden=YES;
}
-(IBAction)ColorClick
{
	ColorPickerViewController *colorPickerViewController = 
	[[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
    colorPickerViewController.delegate = self;
#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    colorPickerViewController.defaultsKey = @"SwatchColor";
#else
    // We re-use the current value set to the background of this demonstration view
   // colorPickerViewController.defaultsColor = colorSwatch.backgroundColor;
	colorPickerViewController.defaultsColor = [UIColor redColor];

#endif
    [self presentModalViewController:colorPickerViewController animated:YES];
    [colorPickerViewController release];
}
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
    NSLog(@"Color: %d",color);
   // const float* colors = CGColorGetComponents(self.view.backgroundColor.CGColor );
   // colors = CGColorGetComponents(self.view.backgroundColor.CGColor );
	colors=CGColorGetComponents(color.CGColor);
	int colorcomponet = CGColorGetNumberOfComponents(color.CGColor);
	
	if (colorcomponet==4) {
		
		const CGFloat *componets = CGColorGetComponents(color.CGColor);
		
		red=componets[0];
		green=componets[1];
		blue=componets[2];
		alpha=componets[3];
        
        NSLog(@"red::%f",red);
		 NSLog(@"green::%f",green);
		 NSLog(@"blue::%f",blue);
		 NSLog(@"alpha::%f",alpha);
		
	}
/*#ifdef IPHONE_COLOR_PICKER_SAVE_DEFAULT
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:colorPicker.defaultsKey];
    
    if ([colorPicker.defaultsKey isEqualToString:@"SwatchColor"]) {
        colorSwatch.backgroundColor = color;
    }
#else
    // No storage & check, just assign back the color
    colorSwatch.backgroundColor = color;
#endif
	*/
	
    [colorPicker dismissModalViewControllerAnimated:YES];
	ButtonClick=1;
}

- (IBAction)redo:(id)sender 
{
    undoredo=YES;
    insertIndex++;
    if (insertIndex+1==arrimageData.count) {
        btnRedo.enabled=NO;
    }
    btnUndo.enabled=YES;
    if (insertIndex<arrimageData.count) {
        drawImage.image =[arrimageData objectAtIndex:insertIndex];
    }
}

- (IBAction)undo:(id)sender 
{   undoredo=YES;
    
    if (insertIndex==-1) {
        
        
    }
    insertIndex--;
    
    if (insertIndex<arrimageData.count) {
        btnRedo.enabled=YES;
    }
    if (insertIndex>=0) {
		drawImage.image =[arrimageData objectAtIndex:insertIndex];
        
    }
    else if(insertIndex==-1)
    {
        drawImage.image=nil;
        btnUndo.enabled=NO;
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
	NSString *temp= [NSString stringWithFormat:@"delete from MedicalHistory where id=%i",id_int_Drawing];
	[database1 executeUpdate:temp];
	[database1 close];
	
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_Drawing];
	
	NSString *myFilePath1 = [documentsDir stringByAppendingPathComponent:imageString];
	// NSString *myFilePath2 = [documentsDir stringByAppendingPathComponent:LogoString];
	
	NSFileManager  *manager = [NSFileManager defaultManager];
	
	[manager removeItemAtPath:myFilePath1 error:NULL];
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	imageBool=YES;}
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
                NSLog(@"Archived Lagel");
                temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='1' where id=%i",id_int_Drawing];
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Family Health Record" message:@"Module item archived." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else if(archived_int==1)
            {
                NSLog(@"Remove Archived Lagel");
                temp= [NSString stringWithFormat:@"Update  MedicalHistory SET archive='0' where id=%i",id_int_Drawing];
                
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
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// path = [documentsDirectory stringByAppendingPathComponent:@"FamilyHealthRecord.sqlite"];
	NSString *imageString=[NSString stringWithFormat:@"/.ModuleImage/%@_%@/%@.png",appDelegate.FamilyID_String,appDelegate.ModuleID_String,imagename_string_Drawing];
	NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageString];
	
	NSData *data1= [NSData dataWithContentsOfFile:getImagePath];
	[picker addAttachmentData:data1 mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png",imagename_string_Drawing]];
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

- (void)dealloc {
    [segment release];
    [slide release];
    [sliderVIew release];
	[sliderVIew1 release];
    [btnRedo release];
    [btnUndo release];
    [super dealloc];
}

@end
