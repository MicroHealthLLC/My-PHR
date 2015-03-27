//
//  MemberDetail.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 10/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MemberDetail : NSObject {

	NSString *str_Module_data;
	int int_module_id;
	int int_enable;
	int int_order_data;
}
@property(nonatomic,retain) NSString *str_Module_data;
@property(nonatomic,assign) int int_module_id;
@property(nonatomic,assign) int int_enable;
@property(nonatomic,assign) int int_order_data;
@end
