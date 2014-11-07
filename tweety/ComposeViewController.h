//
//  ComposeViewController.h
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetSenderDelegate <NSObject>
- (void)onSendTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *numChars;
- (id)initWithReplyToTweet:(Tweet*)tweet;
@property (weak, nonatomic) id<TweetSenderDelegate> delegate;
@end
