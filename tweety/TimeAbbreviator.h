//
//  TimeAbbreviator.h
//  tweety
//
//  Created by Gaurav Menghani on 11/2/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeAbbreviator : NSObject
+ (NSString*) abbreviatedTime:(NSTimeInterval)timeElapsed;
@end
