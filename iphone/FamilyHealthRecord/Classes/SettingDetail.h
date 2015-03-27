//
//  SettingDetail.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 08/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingDetail : NSObject {

	NSString *str_date;
	NSString *str_f_name;
	NSString *str_Module_data;
	NSString *str_title;
}

@property(nonatomic,retain) NSString *str_date;
@property(nonatomic,retain) NSString *str_f_name;
@property(nonatomic,retain) NSString *str_Module_data;
@property(nonatomic,retain) NSString *str_title;
@end
