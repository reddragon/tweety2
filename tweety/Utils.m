//
//  Utils.m
//  tweety
//
//  Created by Gaurav Menghani on 11/9/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString*)humaninzeInt:(NSInteger)val {
    if (val < 1000) {
        return [@(val) stringValue];
    } else {
        return [NSString stringWithFormat:@"%.1fK", (val/1000.0)];
    }
}

@end
