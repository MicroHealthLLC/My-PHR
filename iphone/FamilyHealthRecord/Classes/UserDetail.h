//
//  UserDetail.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDetail : NSObject
{
	NSString *str_f_name;
	NSString *str_l_name;
	int int_OrderNumber;
	NSString *str_Imagename;
	int int_FamilyId;
}

@property(nonatomic,retain)   NSString *str_f_name;
@property(nonatomic,retain)  NSString *str_l_name;
@property(nonatomic,assign) int int_OrderNumber;
@property(nonatomic,retain)  NSString *str_Imagename;
@property(nonatomic,assign) int int_FamilyId;

@end
