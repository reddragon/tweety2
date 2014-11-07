//
//  TweetDetailViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *tweetTimestamp;
@property (strong, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) Tweet* tweet;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) IBOutlet UILabel *numRetweets;
- (IBAction)onReply:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numFavorites;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tweet) {
        [self.tweetText setText:self.tweet.text];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
        [self.tweetTimestamp setText:[dateFormatter stringFromDate:self.tweet.createdAt]];
        
        [self.profileImage setImageWithURL:self.tweet.biggerImageURL];
        [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width / 2];
        self.profileImage.clipsToBounds = YES;
        self.profileImage.layer.borderWidth = 3.0f;
        self.profileImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
        [self.userName setText:self.tweet.realName];
        [self.screenName setText:self.tweet.handle];
        [self.numRetweets setText:[self.tweet.retweetCount stringValue]];
        [self.numFavorites setText:[self.tweet.favoriteCount stringValue]];
        [self setButtonImages];
        // NSLog(@"Tweet Dict: %@", self.tweet)
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithTweet:(Tweet*)tweet {
    if (tweet) {
        self.tweet = tweet;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onFavorite:(id)sender {
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweet.tId, @"id", nil];
    [[TwitterClient sharedInstance] favoriteWithParams:dict completion:^(NSError *error) {
        if (error == nil) {
            NSLog(@"Error is nil");
            if (self.tweet.favorited) {
                self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] - 1];
            } else {
                self.tweet.favoriteCount = [NSNumber numberWithInt:[self.tweet.favoriteCount intValue] + 1];
            }
            self.tweet.favorited = !self.tweet.favorited;
            [self setButtonImages];
        }
    } destroy:self.tweet.favorited];
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
    [self.numRetweets setText:[self.tweet.retweetCount stringValue]];
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
        [self.favoriteButton setImage:favImage forState:UIControlStateNormal];
        [self.favoriteButton setImage:favGrayImage forState:UIControlStateHighlighted];
    } else {
        [self.favoriteButton setImage:favGrayImage forState:UIControlStateNormal];
        [self.favoriteButton setImage:favImage forState:UIControlStateHighlighted];
    }
    [self.numFavorites setText:[self.tweet.favoriteCount stringValue]];
    [self.numRetweets setText:[self.tweet.retweetCount stringValue]];
}

- (IBAction)onReply:(id)sender {
    if (self.delegate != nil) {
        id<TweetReplyDelegate> delegate = self.delegate;
        if ([delegate respondsToSelector:@selector(replyToTweet:)]) {
            NSLog(@"Replies to delegate");
            [delegate replyToTweet:self.tweet];
        }
    }
}
@end
