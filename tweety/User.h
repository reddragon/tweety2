//
//  User.h
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const UserDidLoginNotification;
extern NSString* const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSURL* profileImageUrl;
@property (nonatomic, strong) NSString* tagline;

- (id)initWithDictionary:(NSDictionary*)dictionary;
+ (User*)user;
+ (void)setUser:(User*)user;
+ (void)logout;


@end
