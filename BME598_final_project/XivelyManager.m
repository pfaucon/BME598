//
//  XivelyManager.m
//  BME598_final_project
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "XivelyManager.h"

#define API_KEY @"0w33jetxLfPW09GeAMfQLJ0MXCZf87UUcz8GSn9AYP93TB5N"
#define FEED_ID @"566430076"

@implementation XivelyManager

-(void)requestUpdateWithCallback:(void(^)())block
{
    //TODO: Make this call asynchronous
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.xively.com/v2/feeds/%@.json?duration=1hours&interval=0",FEED_ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:API_KEY forHTTPHeaderField:@"X-ApiKey"];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * requestData = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    //NSData *requestData = [NSData dataWithContentsOfURL:url];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:requestData options:kNilOptions error:Nil];
    
    for( NSDictionary *feedDict in dict[@"datastreams"])
    {
        XivelyData *newData = [[XivelyData alloc] initWithJsonDictionary:feedDict];
        self.datastreamReadings[newData.name] = newData;
    }
    
    block();
}

-(void)setDesiredTemperature:(double)desiredTemp
{
    //TODO: Make this call asynchronous
    
    //read all results that occurred in the last 6 hours from all channels
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.xively.com/v2/feeds/%@.json",FEED_ID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:API_KEY forHTTPHeaderField:@"X-ApiKey"];
    request.HTTPMethod = @"PUT";
    
    NSString *stringToPut = [NSString stringWithFormat:@"{\"version\":\"1.0.0\",\"datastreams\" : [ {\"id\" : \"desiredTemperature\",\"current_value\" : \"%.2f\"}]}",desiredTemp];
    NSData *data = [stringToPut dataUsingEncoding:NSASCIIStringEncoding];
    
    request.HTTPBody = data;
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    //NSData * requestData =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];

    //react to whatever the server told us, or ignore it since we are just putting data anyhow
    if(!response)
        NSLog(@"Error recieved:%@",error);
}


#pragma mark - getters and setters
-(NSMutableDictionary *)datastreamReadings
{
    if(!_datastreamReadings) _datastreamReadings = [[NSMutableDictionary alloc] init];
    
    return _datastreamReadings;
}

-(XivelyData *)temperature
{
    return self.datastreamReadings[@"Temperature"];
}

-(XivelyData *)humidity
{
    return self.datastreamReadings[@"Humidity"];
}

#pragma mark - singleton code
static XivelyManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (instancetype)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
    }
    
    return self;
}


// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
