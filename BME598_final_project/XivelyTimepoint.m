//
//  XivelyTimepoint.m
//  BME598_final_project
//
//  Created by philippe faucon on 4/17/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import "XivelyTimepoint.h"

@implementation XivelyTimepoint


-(instancetype)initWithData:(double)val andDateString:(NSString *)rfc3339DateTimeString
{
    self = [self init];
    
    self.value = val;
    
    // Xively follows ISO8001, which apparently matches Apple's rfc3339, works for me
    // following code lifted from https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    self.timestamp = date;
    return  self;
}

-(instancetype)initWithData:(double)val atTimePoint:(NSDate *)date
{
    self = [self init];
    
    self.value = val;
    self.timestamp = date;
    return  self;
}

#pragma mark - methods to help with comparisons

// two timepoints are equal if their occurence time is equal
-(BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[XivelyTimepoint class]])
        return [self.timestamp isEqual:((XivelyTimepoint *)object).timestamp];
    
    //if it's not a timepoint we don't care about it
    return NO;
}

- (NSComparisonResult)compare:(XivelyTimepoint *)object {
    return [self.timestamp compare:object.timestamp];
}

@end
