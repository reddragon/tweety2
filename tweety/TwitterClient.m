//
//  TwitterClient.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString* const kConsumerKey = @"SaiX61TJtjH3mb8vLsmfDMm3F";
NSString* const kConsumerSecret = @"lAq2rHsboPue2LpWaXx8yUEfyf2zUXmcVW0yPb8iVedsOhvB3q";
NSString* const kBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion) (User* user, NSError* error);
@end

@implementation TwitterClient

+ (TwitterClient*) sharedInstance {
    static TwitterClient* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] consumerKey:kConsumerKey consumerSecret:kConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"tweety://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the token!");
        NSURL* authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Got an error! %@", error);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"Got the access token! %@", accessToken.token);
        [self.requestSerializer saveAccessToken:accessToken];
        
        // Trying to get a user's credentials
        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User* user = [[User alloc] initWithDictionary:responseObject];
            [User setUser:user];
            NSLog(@"User name: %@", user.name);
            if (self.loginCompletion != nil) {
                self.loginCompletion(user, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
            if (self.loginCompletion != nil) {
                self.loginCompletion(nil, error);
            }
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token! %@", error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray* tweets, NSError* error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error while fetching tweets: %@", error);
        completion(nil, error);
    }];
}

- (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Looks like it succeeded: %@", responseObject);
        if (completion != nil) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh, oh. It failed: %@", error);
        if (completion != nil) {
            completion(error);
        }
    }];
}

- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion {
    
    NSString* url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", params[@"id"]];
    
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Looks like it succeeded: %@", responseObject);
        if (completion != nil) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh, oh. It failed: %@", error);
        if (completion != nil) {
            completion(error);
        }
    }];
}

- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(NSError *))completion destroy:(BOOL)destroy {
    
    NSString* endpoint;
    if (destroy == true) {
        endpoint = @"1.1/favorites/destroy.json";
    } else {
        endpoint = @"1.1/favorites/create.json";
    }
    
   [self POST:endpoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"Looks like it succeeded: %@", responseObject);
        if (completion != nil) {
            completion(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Uh, oh. It failed: %@", error);
        if (completion != nil) {
            completion(error);
        }
    }];
}

@end
