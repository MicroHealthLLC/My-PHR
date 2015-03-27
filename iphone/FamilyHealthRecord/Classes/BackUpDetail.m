//
//  BackUpDetail.m
//  FamilyHealthRecord
//
//  Created by MAC3 on 20/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BackUpDetail.h"


@implementation BackUpDetail
@synthesize int_id,int_drawing,int_video,int_file,int_voice,int_pics,int_notes,str_created_date,str_revisions;

-(void)dealloc
{
	[int_id release];
	[int_drawing release];
	[int_video release];
	[int_file release];
	[int_voice release];
	[int_pics release];
	[int_notes release];
	[str_created_date release];
	[str_revisions release];
	[super dealloc];
}
@end
