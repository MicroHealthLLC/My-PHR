//
//  UserDetail.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDetail.h"


@implementation UserDetail

@synthesize str_f_name,str_l_name,int_OrderNumber,str_Imagename,int_FamilyId;
-(void) dealloc
{
	[str_f_name release];
	[str_l_name release];
	[int_OrderNumber release];
	[str_Imagename release];
	[int_OrderNumber release];
	[super dealloc];
}

@end
