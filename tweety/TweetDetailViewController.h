//
//  TweetDetailViewController.h
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetReplyDelegate <NSObject>
- (void)replyToTweet:(Tweet*)tweet;
@end

@interface TweetDetailViewController : UIViewController

- (id) initWithTweet:(Tweet*)tweet;
@property (weak, nonatomic) id<TweetReplyDelegate> delegate;

@end
