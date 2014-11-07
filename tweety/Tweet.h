//
//  Tweet.h
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSURL* imageURL;
@property (nonatomic, strong) NSURL* biggerImageURL;
@property (nonatomic, strong) NSString* tId;
@property (nonatomic, strong) NSNumber* retweetCount;
@property (nonatomic, strong) NSNumber* favoriteCount;
@property (nonatomic, strong) NSString* realName;
@property (nonatomic, strong) NSString* handle;
@property BOOL retweeted;
@property BOOL favorited;
@property BOOL isFake;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)initFakeTweetWithText:(NSString*)text;
+ (NSArray *)tweetsWithArray:(NSArray*)array;
@end
