//
//  SettingDetail.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingDetail.h"


@implementation SettingDetail
@synthesize str_date,str_f_name,str_Module_data,str_title;

-(void)dealloc
{
	[str_date release];
	[str_f_name release];
	[str_Module_data release];
	[str_title release];
	[super dealloc];
}
@end
