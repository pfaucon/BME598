//
//  XivelyData.m
//  BME598_final_project
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "XivelyData.h"

@implementation XivelyData


-(instancetype)initWithJsonDictionary:(NSDictionary *)json
{
    // call principal init
    self = [self init];
    
    [self parseJson:json];
    return self;
}

-(void)parseJson:(NSDictionary *)json
{
    //wipe our array, this is gross but should work fine for now
    self.timePoints = Nil;
    
    self.name = json[@"id"];
    self.maxValue = [json[@"max_value"] doubleValue];
    self.minValue = [json[@"min_value"] doubleValue];
    self.currentTimepoint = [[XivelyTimepoint alloc] initWithData:[json[@"current_value"] doubleValue] andDateString:json[@"at"]];
    
    //try to parse out data points if they were present in the results
    //[self.timePoints addObject:self.currentTimepoint];
    NSArray *pts = json[@"datapoints"];
    if(pts)
    {
        for(NSDictionary *dict in json[@"datapoints"])
        {
            XivelyTimepoint *point = [[XivelyTimepoint alloc] initWithData:[dict[@"value"] doubleValue] andDateString:dict[@"at"]];
            [self.timePoints addObject:point];
        }
    }
}

// return the maximum and minimum timepoints in the list of points
// the "compare:" method we define compares based on timestamp
-(NSDate *)maxTime
{
    XivelyTimepoint *max = [self.timePoints valueForKeyPath:@"@max.self"];
    return [max timestamp];
}

-(NSDate *)minTime
{
    XivelyTimepoint *min = [self.timePoints valueForKeyPath:@"@min.self"];
    return [min timestamp];
}



#pragma mark - lazy instantiator
-(NSMutableArray *)timePoints
{
    if(!_timePoints) _timePoints = [NSMutableArray new];
    return _timePoints;
}
@end
