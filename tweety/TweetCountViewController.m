//
//  TweetCountViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 11/9/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TweetCountViewController.h"
#import "Utils.h"

@interface TweetCountViewController ()
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UILabel *tweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@end

@implementation TweetCountViewController

- (id)initWithUser:(User *)user {
    self.user = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tweetCount.text = [Utils humaninzeInt:self.user.numTweets];
    self.favoriteCount.text = [Utils humaninzeInt:self.user.numFavorites];
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

@end
