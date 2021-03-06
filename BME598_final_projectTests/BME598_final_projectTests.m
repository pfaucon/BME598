//
//  BME598_final_projectTests.m
//  BME598_final_projectTests
//
//  Created by philippe faucon on 4/16/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XivelyTimepoint.h"

@interface BME598_final_projectTests : XCTestCase

@end

@implementation BME598_final_projectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testTimepointInitializer
{
    XivelyTimepoint *point = [[XivelyTimepoint alloc] initWithData:123.45 andDateString:@"2014-04-18T02:08:49.177774Z"];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = 2014;
    comps.month = 4;
    comps.day = 18;
    comps.hour = 2;
    comps.minute = 8;
    comps.second = 49;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    if(point.value != 123.45)
        XCTFail(@"XivelyTimepoint failed to initialize the value");
    if([point.timestamp isEqual:date])
        XCTFail(@"XivelyTimepoint failed to initalize the date");
}

@end
