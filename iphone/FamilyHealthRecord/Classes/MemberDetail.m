//
//  MemberDetail.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 10/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberDetail.h"


@implementation MemberDetail
@synthesize str_Module_data,int_module_id,int_enable,int_order_data;
-(void)dealloc
{
	[str_Module_data release];
	[int_module_id release];
	[int_enable release];
	[int_order_data release];
	[super dealloc];
}
@end
