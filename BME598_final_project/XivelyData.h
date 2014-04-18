//
//  XivelyData.h
//  BME598_final_project
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XivelyTimepoint.h"

@interface XivelyData : NSObject


@property NSString *name;
@property double maxValue;
@property double minValue;

@property XivelyTimepoint *currentTimepoint;
@property (nonatomic) NSMutableArray *timePoints;

-(instancetype)initWithJsonDictionary:(NSDictionary *)json;
@end
