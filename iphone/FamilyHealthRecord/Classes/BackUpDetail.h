//
//  BackUpDetail.h
//  FamilyHealthRecord
//
//  Created by MAC3 on 20/06/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BackUpDetail : NSObject {
	int int_id;
	int int_drawing;
	int int_video;
	int int_file;
	int int_voice;
	int int_pics;
	int int_notes;
	NSString *str_created_date;
	NSString *str_revisions;
}

@property(nonatomic,assign) int int_id;
@property(nonatomic,assign) int int_drawing;
@property(nonatomic,assign) int int_video;
@property(nonatomic,assign) int int_file;
@property(nonatomic,assign) int int_voice;
@property(nonatomic,assign) int int_pics;
@property(nonatomic,assign) int int_notes;
@property(nonatomic,retain) NSString *str_created_date;
@property(nonatomic,retain) NSString *str_revisions;

@end
