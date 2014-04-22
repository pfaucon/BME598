//
//  XivelyManager.h
//  BME598_final_project
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XivelyData.h"

@interface XivelyManager : NSObject

@property double requested_temperature;

@property (nonatomic) NSMutableDictionary *datastreamReadings;

-(void)requestUpdateWithCallback:(void(^)())block;
-(void)setDesiredTemperature:(double)desiredTemp;

+ (instancetype)sharedInstance;

//these are getters but are somewhat unsafe to use (there may be no data)
-(XivelyData *)temperature;
-(XivelyData *)humidity;

@end
