//
//  XivelyTimepoint.h
//  BME598_final_project
//
//  Created by philippe faucon on 4/17/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XivelyTimepoint : NSObject

@property double value;
@property NSDate *timestamp;


-(instancetype)initWithData:(double)val andDateString:(NSString *)rfc3339DateTimeString;
-(instancetype)initWithData:(double)val atTimePoint:(NSDate *)date;

@end
