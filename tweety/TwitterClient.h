//
//  TwitterClient.h
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*) sharedInstance;
- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion;
- (void)openURL:(NSURL*)url;
- (void)homeTimelineWithParams:(NSDictionary*)params completion:(void(^)(NSArray* tweets, NSError* error))completion;
- (void)updateStatusWithParams:(NSDictionary*)params completion:(void(^)(NSError* error))completion;
- (void)retweetWithParams:(NSDictionary*)params completion:(void(^)(NSError* error))completion;
- (void)favoriteWithParams:(NSDictionary*)params completion:(void(^)(NSError* error))completion destroy:(BOOL)destroy;


@end
