//
//  Tweet.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet
- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.isFake = false;
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString* createdAt = dictionary[@"created_at"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"EEE MMM dd hh:mm:ss Z yyyy";
        self.createdAt = [formatter dateFromString:createdAt];
        // NSLog(@"Created at: %@ %@", createdAt, self.createdAt);
        
        NSString* imageURLStr = dictionary[@"user"][@"profile_image_url"];
        self.imageURL = [NSURL URLWithString:imageURLStr];
        self.biggerImageURL = [NSURL URLWithString:[imageURLStr stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
        
        self.tId = dictionary[@"id"];
        self.retweetCount = dictionary[@"retweet_count"];
        if (self.retweetCount == nil) {
            self.retweetCount = [NSNumber numberWithInt:0];
        }
        self.favoriteCount = dictionary[@"favourites_count"];
        if (self.favoriteCount == nil) {
            self.favoriteCount = [NSNumber numberWithInt:0];
        }
        self.handle = dictionary[@"user"][@"screen_name"];
        self.realName = dictionary[@"user"][@"name"];
        
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        // NSLog(@"Dictionary: %@", dictionary);
    }
    return self;
}

- (id)initFakeTweetWithText:(NSString *)text {
    self = [super init];
    if (self) {
        User* user = [User user];
        self.handle = user.screenName;
        self.realName = user.name;
        self.retweeted = false;
        self.favorited = false;
        self.retweetCount = [NSNumber numberWithInt:0];
        self.favoriteCount = [NSNumber numberWithInt:0];
        self.imageURL = user.profileImageUrl;
        self.biggerImageURL = user.profileImageUrl;
        self.text = text;
        // NSLog(@"User name: %@, url: %@", self.realName, self.imageURL);
    }
    return self;
}

+ (NSArray*)tweetsWithArray:(NSArray *)array {
    NSMutableArray* tweets = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        Tweet* tweet = [[Tweet alloc] initWithDictionary:dict];
        [tweets addObject:tweet];
    }
    return tweets;
}
@end
