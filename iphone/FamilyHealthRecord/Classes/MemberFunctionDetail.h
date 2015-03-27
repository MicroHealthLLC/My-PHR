//
//  MemberFunctionDetail.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 25/05/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MemberFunctionDetail : NSObject {

	NSString *str_title;
	NSString *str_data;
	int int_medicaldatatype_id;
	int int_ordernum;
	int int_id;
    int int_archive;
	int int_module_id;
	NSString *str_created_date;
	NSString *str_modify_date;
	
}
@property(nonatomic,retain) NSString *str_title;
@property(nonatomic,retain) NSString *str_data;
@property(nonatomic,assign) int int_medicaldatatype_id;
@property(nonatomic,assign) int int_ordernum;
@property(nonatomic,assign) int int_id;
@property(nonatomic,assign) int int_archive;
@property(nonatomic,assign) int int_module_id;
@property(nonatomic,retain) NSString *str_created_date;
@property(nonatomic,retain) NSString *str_modify_date;
@end
