//
//  TweetViewCell.m
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TweetViewCell.h"
#import "TwitterClient.h"
#import "TimeAbbreviator.h"
#import "FormatterKit/TTTTimeIntervalFormatter.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewCell ()
@property (weak, nonatomic) UIViewController* parent;
@end


@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.tweetText setPreferredMaxLayoutWidth:self.tweetText.frame.size.width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.retweeted == false) {
        self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] + 1];
        
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.tId, @"id", nil];
        [[TwitterClient sharedInstance] retweetWithParams:dict completion:nil];
    } else {
        self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] - 1];
        // TODO
        // Remove the tweet.
    }
    self.tweet.retweeted = !self.tweet.retweeted;
    [self setButtonImages];
    [self.retweetCount setText:[self.tweet.retweetCount stringValue]];
}

- (IBAction)onFavorite:(id)sender {
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.tId, @"id", nil];
    [[TwitterClient sharedInstance] favoriteWithParams:dict completion:nil destroy:self.tweet.favorited];
    self.tweet.favorited = !self.tweet.favorited;
    
    if (self.tweet.favorited == true) {
        self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] + 1];
    } else {
        self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] - 1];
    }
    [self setButtonImages];
    [self.favoriteCount setText:[self.tweet.favoriteCount stringValue]];
    
}

- (IBAction)onReply:(id)sender {
    ComposeViewController* cvc = [[ComposeViewController alloc] initWithReplyToTweet:self.tweet];
    cvc.delegate = self.parent;
    [self.parent.navigationController pushViewController:cvc animated:YES];
}

- (void)initWithTweet:(Tweet *)tweet parent:(UIViewController*)parent {
    self.tweet = tweet;
    self.parent = parent;
    [self.tweetText setText:tweet.text];
    self.tweetText.numberOfLines = 10;
    [self.realName setText:tweet.realName];
    [self.handle setText:[NSString stringWithFormat:@"@%@", tweet.handle]];
    [self.retweetCount setText:[tweet.retweetCount stringValue]];
    [self.favoriteCount setText:[tweet.favoriteCount stringValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
    // [self.tweetTimestamp setText:[dateFormatter stringFromDate:tweet.createdAt]];
    NSDate* creationDate = tweet.createdAt;
    NSTimeInterval sinceThen = [creationDate timeIntervalSinceNow];
    
    // TODO
    // Fix the timestamp later
    [self.tweetTimestamp setText:[NSString stringWithFormat:@"%@", [TimeAbbreviator abbreviatedTime:sinceThen]]];
    
    [self.profileImage setImageWithURL:tweet.biggerImageURL];
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width / 2];
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
    
    [self setButtonImages];
}

- (void)setButtonImages {
    UIImage* retweetImage = [UIImage imageNamed:@"retweet"];
    UIImage* retweetGrayImage = [UIImage imageNamed:@"retweet_gray"];

    UIImage* favImage = [UIImage imageNamed:@"favorite"];
    UIImage* favGrayImage = [UIImage imageNamed:@"favorite_gray"];
    
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:retweetImage forState:UIControlStateNormal];
        [self.retweetButton setImage:retweetGrayImage forState:UIControlStateHighlighted];
        
    } else {
        [self.retweetButton setImage:retweetGrayImage forState:UIControlStateNormal];
        [self.retweetButton setImage:retweetImage forState:UIControlStateHighlighted];
    }
    
    if (self.tweet.favorited) {
        NSLog(@"Is favorited");
        [self.favoriteButton setImage:favImage forState:UIControlStateNormal];
        [self.favoriteButton setImage:favGrayImage forState:UIControlStateHighlighted];
    } else {
        NSLog(@"Is not favorited");
        [self.favoriteButton setImage:favGrayImage forState:UIControlStateNormal];
        [self.favoriteButton setImage:favImage forState:UIControlStateHighlighted];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.tweetText setPreferredMaxLayoutWidth:self.tweetText.frame.size.width];
}

@end
