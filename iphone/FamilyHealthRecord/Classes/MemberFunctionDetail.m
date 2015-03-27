//
//  MemberFunctionDetail.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 25/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberFunctionDetail.h"


@implementation MemberFunctionDetail
@synthesize str_title,str_data,int_medicaldatatype_id,str_created_date,str_modify_date,int_ordernum,int_id,int_archive,int_module_id;
-(void)dealloc
{
	[str_data release];
	[str_title release];
	[int_medicaldatatype_id release];
	[str_created_date release];
	[str_modify_date release];
	[int_id release];
	[int_ordernum release];
    [int_archive release];
	[int_module_id release];
	[super dealloc];
}
@end
