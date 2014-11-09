//
//  User.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString* const UserDidLoginNotification = @"UserDidLoginNotification";
NSString* const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()
@property (nonatomic, strong) NSDictionary* dictionary;
@end

@implementation User

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.tagline = dictionary[@"description"];
        self.screenName = dictionary[@"screen_name"];
        NSString* profileImageUrlStr = dictionary[@"profile_image_url"];
        self.profileImageUrl = [NSURL URLWithString:[profileImageUrlStr stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"]];
        NSString* bgImageUrlStr = dictionary[@"profile_background_image_url_https"];
        // NSLog(@"user: %@ bgImage: %@ dict: %@", self.name, bgImageUrlStr, dictionary);
        self.bgImageUrl = [NSURL URLWithString:bgImageUrlStr];
        self.numFollowers = [dictionary[@"followers_count"] integerValue];
        self.numFollowing = [dictionary[@"friends_count"] integerValue];
        self.bgImageUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.userId = [dictionary[@"user_id"] stringValue];
        NSLog(@"Name: %@, UserId: %@", self.name, self.userId);
    }
    
    return self;
}


static User* _currentUser = nil;
NSString* const kCurrentUserKey = @"kCurrentUserKey";
+ (User*)user {
    if (_currentUser == nil) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setUser:(User *)user {
    _currentUser = user;
    if (_currentUser != nil) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
