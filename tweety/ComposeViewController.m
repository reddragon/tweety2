//
//  ComposeViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

NSString* const kPlaceholderStr = @"Say something.";

@interface ComposeViewController ()
@property (weak, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) IBOutlet UITextView *tweetText;
@property (strong, nonatomic) Tweet* inReplyTo;
- (IBAction)onTweetSubmit:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    self.user = [User user];
    [self.userName setText:self.user.name];
    [self.screenName setText:[NSString stringWithFormat:@"@%@", self.user.screenName]];
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width / 2];
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
    self.tweetText.delegate = self;
    self.tweetText.textColor = [UIColor lightGrayColor];
    if (self.inReplyTo != nil) {
        self.tweetText.text = [NSString stringWithFormat:@"@%@ ", self.inReplyTo.user.screenName];
        self.tweetText.textColor = [UIColor blackColor];
    } else {
        self.tweetText.text = kPlaceholderStr;
    }
    [self changeNumChars];
    self.navigationItem.title = @"Compose";
    
    UIBarButtonItem* sendTweet = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetSubmit:)];
    self.navigationItem.rightBarButtonItem = sendTweet;
}

- (id) initWithReplyToTweet:(Tweet *)tweet {
    self.inReplyTo = tweet;
    return self;
}

- (void)changeNumChars {
    long remaining = 140;
    if (![self.tweetText.text isEqualToString:kPlaceholderStr]) {
        remaining = remaining - self.tweetText.text.length;
    }
    if (remaining > 0) {
        // Set blue color
        self.numChars.textColor = [UIColor blackColor];
    } else {
        // Set red color
        self.numChars.textColor = [UIColor redColor];
    }
    // Set text
    [self.numChars setText:[NSString stringWithFormat:@"%ld", remaining]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceholderStr]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"Called");
    if ([textView.text isEqualToString:@""]) {
        textView.text = kPlaceholderStr;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self changeNumChars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTweetSubmit:(id)sender {
    if (self.tweetText.text.length <= 140) {
        NSString* inReplyToId = nil;
        if (self.inReplyTo != nil) {
            inReplyToId = self.inReplyTo.tId;
        }
        NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.tweetText.text, @"status",inReplyToId, @"in_reply_to_status_id", nil];
        
        [[TwitterClient sharedInstance] updateStatusWithParams:dict completion:^(NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        id<TweetSenderDelegate> sdelegate = self.delegate;
        if (self.delegate != nil) {
            Tweet* t = [[Tweet alloc] initFakeTweetWithText:self.tweetText.text];
            if ([sdelegate respondsToSelector:@selector(onSendTweet:)]) {
                NSLog(@"It responds!");
                [sdelegate onSendTweet:t];
            } else {
                NSLog(@"No, it doesn't");
            }
            
        }
        
    } else {
        NSLog(@"Can't do. Too long tweet!");
    }
    
}
@end
