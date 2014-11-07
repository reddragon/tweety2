//
//  TimeAbbreviator.m
//  tweety
//
//  Created by Gaurav Menghani on 11/2/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TimeAbbreviator.h"

@implementation TimeAbbreviator

+ (NSString*) abbreviatedTime:(NSTimeInterval)timeElapsed {
    NSString* unit;
    NSString* value;
    timeElapsed *= -1;
    if (timeElapsed < 60) {
        unit = @"s ago";
        int val = (int)timeElapsed;
        value = [NSString stringWithFormat:@"%d", val];
    } else {
        timeElapsed /= 60.0;
        if (timeElapsed < 60) {
            unit = @"m ago";
            int val = (int)timeElapsed;
            value = [NSString stringWithFormat:@"%d", val];
        } else {
            timeElapsed /= 60.0;
            if (timeElapsed < 24) {
                unit = @"h ago";
                int val = (int)timeElapsed;
                value = [NSString stringWithFormat:@"%d", val];
            } else {
                unit = @"d ago";
                timeElapsed /= 24.0;
                int val = (int)timeElapsed;
                value = [NSString stringWithFormat:@"%d", val];
            }
        }
    }
    return [NSString stringWithFormat:@"%@%@", value, unit];
}

@end
