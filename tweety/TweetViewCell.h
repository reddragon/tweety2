//
//  TweetViewCell.h
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) Tweet* tweet;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *tweetTimestamp;
@property (strong, nonatomic) IBOutlet UILabel *realName;
@property (strong, nonatomic) IBOutlet UILabel *handle;
@property (strong, nonatomic) IBOutlet UILabel *retweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;
- (IBAction)onReply:(id)sender;

- (void)initWithTweet:(Tweet*)tweet parent:(UIViewController*)parent;
@end
