//
//  TweetsViewController.h
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"

@protocol TweetsMenuButtonDelegate
- (void)toggleHamburgerMenu;
@end

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetSenderDelegate, TweetReplyDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tweetList;
@property (strong, nonatomic) NSString* operation;
@property (strong, nonatomic) id<TweetsMenuButtonDelegate> delegate;
@end
