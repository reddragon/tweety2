//
//  HamburgerMenuController.h
//  tweety
//
//  Created by Gaurav Menghani on 11/7/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HamburgerMenuDelegate <NSObject>

- (void)onMentions;
- (void)onProfile;
- (void)onLogout;

@end


@interface HamburgerMenuController : UIViewController
@property (strong, nonatomic) id<HamburgerMenuDelegate> delegate;
@end
