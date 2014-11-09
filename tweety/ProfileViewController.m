//
//  ProfileViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 11/8/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetViewCell.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UITableView *tweetList;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UILabel *followersCount;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) NSMutableArray* tweets;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.user == nil) {
        self.user = [User user];
    }
    self.tweets = [[NSMutableArray alloc] init];
    [self.followersCount setText:[@(self.user.numFollowers) stringValue]];
    [self.followingCount setText:[@(self.user.numFollowing) stringValue]];
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    [self.bgImage setImageWithURL:self.user.bgImageUrl];
    
    [self.tweetList registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tweetList.delegate = self;
    self.tweetList.dataSource = self;
    [self.userName setText:self.user.name];
    [self.screenName setText:self.user.screenName];
    // Do any additional setup after loading the view from its nib.
    [self loadData:NO];
}

- (void)loadData:(BOOL)refreshFromTop {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"user_id"] = self.user;
    [[TwitterClient sharedInstance] getTweetsWithOperation:@"user_timeline" params:params completion:^(NSArray *tweets, NSError *error) {
        if (tweets != nil) {
            // Remove fake tweets
            NSMutableArray* fakeArray = [[NSMutableArray alloc] init];
            for (Tweet* t in self.tweets) {
                if (t.isFake) {
                    [fakeArray addObject:t];
                }
            }
            [self.tweets removeObjectsInArray:fakeArray];
            
            NSLog(@"Number of tweets received: %lu, size before: %lu", tweets.count, self.tweets.count);
            
            if (refreshFromTop) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                       NSMakeRange(0, tweets.count)];
                [self.tweets insertObjects:tweets atIndexes:indexes];
            } else {
                [self.tweets addObjectsFromArray:tweets];
            }
            NSLog(@"Tweet list final size: %ld", self.tweets.count);
            [self.tweetList reloadData];
            [self.tweetList reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
        // [self.refreshControl endRefreshing];
    }];
    
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewCell* cell = [self.tweetList dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    [cell initWithTweet:self.tweets[indexPath.row] parent:self];
    if (indexPath.row == self.tweets.count - 1) {
        [self loadData:NO];
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
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
