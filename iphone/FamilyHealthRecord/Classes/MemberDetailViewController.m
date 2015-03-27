//
//  MemberDetailViewController.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "FMDatabase.h"
#import "MemberDetail.h"
#import "MemberFunctionViewController.h"
#import"FamilyHealthRecordAppDelegate.h"


@implementation MemberDetailViewController
@synthesize tblView,lbltop,getFnameString,leftBarButton,rightBarButton,appDelegate;

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
#pragma mark View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"appDelegate.FamMember_String::%@",appDelegate.FamMember_String);
	lbltop.text=getFnameString;
	leftBarButton.title=@"Back";
	rightBarButton.title=@"Edit";
	appDelegate=[[UIApplication sharedApplication]delegate];

}
-(void)viewWillAppear:(BOOL)animated
{
	FetchBool=NO;
	BackBool=YES;
	[super viewWillAppear:animated];
	[self getModuleData];	
}
-(void)getModuleData
{
	//HistoryArray=[[NSMutableArray alloc]init];
	NSArray *documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentDir=[documentPath objectAtIndex:0];
	NSString *databasePath=[documentDir  stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
	FMDatabase *database=[FMDatabase databaseWithPath:databasePath];
	[database open];
	
	if(FetchBool==YES)
	{
		HistoryArray=[[NSMutableArray alloc]init];
	FMResultSet *results = [database executeQuery:@"select Module_data, module_id, order_data, enable from Module_table where enable=0"];	
	
	while([results next]) {
		MemberDetail  *objMemberdetails=[[MemberDetail alloc]init];
        objMemberdetails.str_Module_data=[results stringForColumn:@"Module_data"];
        objMemberdetails.int_module_id=[results intForColumn:@"module_id"];
		objMemberdetails.int_order_data=[results intForColumn:@"order_data"];
		objMemberdetails.int_enable=[results intForColumn:@"enable"];
		//NSLog(@"Module::%@",objMemberdetails.str_Module_data);
	    [HistoryArray addObject:objMemberdetails];
	}
	}
	else if(FetchBool==NO)
	{
		HistoryArray=[[NSMutableArray alloc]init];
		FMResultSet *results = [database executeQuery:@"select Module_data, module_id, order_data, enable from Module_table where enable=1  ORDER BY order_data"];	
		//FMResultSet *results = [database executeQuery:@"select Module_data, module_id, order_data, enable from Module_table where enable=1"];	

		while([results next]) {
			MemberDetail  *objMemberdetails=[[MemberDetail alloc]init];
			objMemberdetails.str_Module_data=[results stringForColumn:@"Module_data"];
			objMemberdetails.int_module_id=[results intForColumn:@"module_id"];
			objMemberdetails.int_order_data=[results intForColumn:@"order_data"];
			objMemberdetails.int_enable=[results intForColumn:@"enable"];
			//NSLog(@"Module::%@",objMemberdetails.str_Module_data);
			[HistoryArray addObject:objMemberdetails];
			
	}
	}
	[database close];
}
#pragma mark  Button Method
-(IBAction)Back
{
	if(AddBool==YES)
	{
		[leftBarButton setImage:[UIImage imageNamed:@""]];
		leftBarButton.title=@"Back";
		rightBarButton.enabled=NO;
		AddBool=NO;
		BackBool=NO;
		tblView.editing=NO;
		FetchBool=YES;
		[self getModuleData];
		[self.tblView reloadData];
	}
	else
	{
		if(!BackBool)
		{
		//leftBarButton.title=@"Back";
		rightBarButton.enabled=YES;
        rightBarButton.title=@"Edit";
		tblView.editing=NO;
		EditBool=NO;
		//[self getModuleData];
			BackBool=YES;
			FetchBool=NO;
			[self getModuleData];
			[self.tblView reloadData];
			
		}
		else
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	
}
-(IBAction)Edit
{
	if(!EditBool)
	{
		tblView.editing=YES;
		EditBool=YES;
		rightBarButton.title=@"Done";
       // leftBarButton.title=UIBarButtonSystemItemAdd;
		[leftBarButton setImage:[UIImage imageNamed:@"plusicon.png"]];
		AddBool=YES;
		//[self getModuleData];
		//
	}
	else 
	{
		tblView.editing=NO;
		EditBool=NO;
		rightBarButton.title=@"Edit";
		[leftBarButton setImage:[UIImage imageNamed:@""]];
		leftBarButton.title=@"Back";
		AddBool=NO;
		BackBool=YES;
	
	}
}
#pragma mark Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [HistoryArray count];
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

    MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:indexPath.row];
	//cell.textLabel.text=[HistoryArray objectAtIndex:indexPath.row];
	cell.textLabel.text=objMemberDetail.str_Module_data;
	cell.font=[UIFont systemFontOfSize:20];
	//cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	//cell.hidesAccessoryWhenEditing = YES;
	if(FetchBool==YES)
	{
		cell.accessoryType=UITableViewCellAccessoryNone;
		customButton = [UIButton buttonWithType:UIButtonTypeCustom];
		customButton.frame=CGRectMake(283,8,27,28);
		[customButton setImage:[UIImage imageNamed:@"plusround.png"] forState:UIControlStateNormal];
		[customButton setBackgroundColor:[UIColor whiteColor]];
		[customButton addTarget:self action:@selector(restorebutton:) forControlEvents: UIControlEventTouchUpInside];
		customButton.tag = indexPath.row;
		buttontag++;
		[cell.contentView addSubview:customButton];
	}
	else if(FetchBool==NO)
	{
	/*customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	customButton.frame=CGRectMake(278,8,27,28);
	[customButton setImage:[UIImage imageNamed:@"bluearrow.png.png"] forState:UIControlStateNormal];
	[customButton setBackgroundColor:[UIColor whiteColor]];
	//[customButton addTarget:self action:@selector(deletebutton:) forControlEvents: UIControlEventTouchUpInside];
	//customButton.tag = indexPath.row;
	//buttontag++;
	[cell.contentView addSubview:customButton];	*/
		cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	}
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:indexPath.row];
    int moduleid=objMemberDetail.int_module_id;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    //FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
	FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
	[database open];
	
	//INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
	NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET enable='0' WHERE module_id='%i'",moduleid];
	//NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='1' WHERE module_id='%i'",moduleid];

	[database executeUpdate:query];
	[database close];
	//[HistoryArray removeObjectAtIndex:indexPath];
	[self getModuleData];
	[self.tblView reloadData];
}
#pragma mark TableView Reorder
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath 
{
	/*NSString *item = [[HistoryArray objectAtIndex:fromIndexPath.row] retain];
	[HistoryArray removeObject:item];
	[HistoryArray insertObject:item atIndex:toIndexPath.row];
	[item release];*/
	
	int from=fromIndexPath.row;
	int to=toIndexPath.row;
	int kp=toIndexPath.row;
	NSLog(@"from::%i",from);
	NSLog(@"to::%i",to);
	
	if (from < to) { // for up to down
		for (int i=from+1; i<=to; i++)
		{
			//from++;
			//boolean x = dbAdapter.updateModuleOrder(moduleListEnabled.get(i).getId(), i-1);
			MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:i];
			 int moduleid=objMemberDetail.int_module_id;
			 NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			 NSString *documentsDir = [documentPaths objectAtIndex:0];
			 NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
			
			
			 //FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
			 FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
			 [database open];
			
			 //INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
			 NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='%i' WHERE module_id='%i'",i-1,moduleid];
			 //NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='1' WHERE module_id='%i'",moduleid];
			
			 [database executeUpdate:query];
			 [database close];
			 //[HistoryArray removeObjectAtIndex:indexPath];
			
			/*if(x) {
				//moduleListEnabled.get(i).setOrder(i-1);
				[self getModuleData];
			}*/
		}
	}
	
	if (from > to) { // for up to down
		for (int j=to; j<=from-1; j++)
		{
			//from++;
			//boolean x = dbAdapter.updateModuleOrder(moduleListEnabled.get(i).getId(), i-1);
			MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:j];
			int moduleid=objMemberDetail.int_module_id;
			NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDir = [documentPaths objectAtIndex:0];
			NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
			
			
			//FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
			FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
			[database open];
			
			//INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
			NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='%i' WHERE module_id='%i'",j+1,moduleid];
			//NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='1' WHERE module_id='%i'",moduleid];
			
			[database executeUpdate:query];
			[database close];
			//[HistoryArray removeObjectAtIndex:indexPath];
			
	
		}
	}
	
		MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:from];
		int moduleid=objMemberDetail.int_module_id;
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
		
		
		//FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
		FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
		[database open];
		
		//INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
		NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='%i' WHERE module_id='%i'",kp,moduleid];
		//NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET order_data='1' WHERE module_id='%i'",moduleid];
		
		[database executeUpdate:query];
		[database close];
		
		FetchBool=NO;
		[self getModuleData];
		//[self.tblView reloadData];
	tblView.editing=YES;
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	MemberDetail *ObjMemberDetail=[HistoryArray objectAtIndex:indexPath.row];
	MemberFunctionViewController *viewcontroller=[[MemberFunctionViewController alloc]initWithNibName:@"MemberFunctionViewController" bundle:nil];
	viewcontroller.getModulename=ObjMemberDetail.str_Module_data;
	appDelegate.ModuleID_String=[NSString stringWithFormat:@"%d", ObjMemberDetail.int_module_id];
	appDelegate.FamMember_String=getFnameString;
	[self.navigationController pushViewController:viewcontroller animated:YES];
    [viewcontroller release];
}
-(void)restorebutton:(id)sender
{
	MemberDetail *objMemberDetail=[HistoryArray objectAtIndex:[sender tag]];
    int moduleid=objMemberDetail.int_module_id;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath=[documentsDir stringByAppendingPathComponent:@"/.DB_Family/FamilyHealthRecord.sqlite"];
	
    //FMDatabase *database1 = [FMDatabase databaseWithPath:databasePath];  
	FMDatabase *database = [FMDatabase databaseWithPath:databasePath]; 
	[database open];
	
	//INSERT INTO tb_FamilyMember (ordernum,f_name,l_name,image) values ('%i','%@','%@','%@')
	NSString *query = [NSString stringWithFormat:@"UPDATE  Module_table SET enable='1' WHERE module_id='%i'",moduleid];
	
	[database executeUpdate:query];
	[database close];
	//[HistoryArray removeObjectAtIndex:indexPath];
	[self getModuleData];
	[self.tblView reloadData];
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
