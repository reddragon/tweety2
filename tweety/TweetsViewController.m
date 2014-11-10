//
//  TweetsViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 10/28/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetDetailViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetViewCell.h"
#import "ComposeViewController.h"

@interface TweetsViewController ()
- (IBAction)onLogout:(id)sender;
- (IBAction)onCompose:(id)sender;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) TweetViewCell* prototypeCell;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.operation == nil) {
        self.operation = @"home";
    }
    self.tweets = [[NSMutableArray alloc] init];
    self.tweetList.delegate = self;
    self.tweetList.dataSource = self;
    [self.tweetList registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tweetList.estimatedRowHeight = 100;
    self.tweetList.rowHeight = UITableViewAutomaticDimension;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetList insertSubview:self.refreshControl atIndex:0];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    
    if ([self.operation isEqualToString:@"home"]) {
        self.tweetList.tableFooterView = tableFooterView;
        UIBarButtonItem* composeButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose:)];
        UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"≡" style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButton:)];
        
    
        self.navigationItem.leftBarButtonItem = menuButton;
        self.navigationItem.rightBarButtonItem = composeButton;
        self.navigationItem.title = @"Home";
    } else if ([self.operation isEqualToString:@"mentions"]) {
        self.navigationItem.title = @"Mentions";
    }
    
    [self loadDataToTop:YES];
}

- (void)loadDataToTop:(BOOL)refreshFromTop {
    NSDictionary* params = nil;
    if (self.tweets.count > 0) {
        if (refreshFromTop) {
            Tweet* t = self.tweets[0];
            params = [[NSDictionary alloc] initWithObjectsAndKeys:t.tId, @"since_id", nil];
        } else {
            Tweet* t = self.tweets[self.tweets.count - 1];
            params = [[NSDictionary alloc] initWithObjectsAndKeys:t.tId, @"max_id", nil];
        }
    }
    [[TwitterClient sharedInstance] getTweetsWithOperation:self.operation params:params completion:^(NSArray *tweets, NSError *error) {
        if (tweets != nil) {
            // Remove fake tweets
            NSMutableArray* fakeArray = [[NSMutableArray alloc] init];
            for (Tweet* t in self.tweets) {
                if (t.isFake) {
                    [fakeArray addObject:t];
                }
            }
            [self.tweets removeObjectsInArray:fakeArray];
            
            if (refreshFromTop) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                       NSMakeRange(0, tweets.count)];
                [self.tweets insertObjects:tweets atIndexes:indexes];
            } else {
                [self.tweets addObjectsFromArray:tweets];
            }
            [self.tweetList reloadData];
            [self.tweetList reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tweetList reloadData];
}

- (void)onRefresh {
    NSLog(@"Refresh called");
    [self loadDataToTop:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TweetViewCell *)prototypeBusinessCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.tweetList dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    }
    
    return _prototypeCell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet* t = self.tweets[indexPath.row];
    [self.prototypeCell initWithTweet:t parent:self];
    // self.prototypeCell.tweetText.text = t.text;
    CGSize size = [self.prototypeBusinessCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
} */


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewCell* cell = [self.tweetList dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    [cell initWithTweet:self.tweets[indexPath.row] parent:self];
    if (indexPath.row == self.tweets.count - 1) {
        [self loadDataToTop:NO];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController* tdvc = [[TweetDetailViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    tdvc.delegate = self;
    [self.navigationController pushViewController:tdvc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onMenuButton:(id)sender {
    if (self.delegate != nil) {
        [self.delegate toggleHamburgerMenu];
    }
}

- (IBAction)onCompose:(id)sender {
    NSLog(@"Hitting onCompose");
    ComposeViewController* cvc = [[ComposeViewController alloc] init];
    cvc.delegate = self;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self.navigationController pushViewController:cvc animated:YES];
    // [self.navigationController ]
}

- (void) onSendTweet:(Tweet *)tweet {
    NSLog(@"Received a tweet");
    [self.tweets insertObject:tweet atIndex:0];
}

- (void)replyToTweet:(Tweet *)tweet {
    NSLog(@"Received a call for a tweet %@", tweet.text);
    
    ComposeViewController* cvc = [[ComposeViewController alloc] initWithReplyToTweet:tweet];
    cvc.delegate = self;
    [self.navigationController pushViewController:cvc animated:YES];
    
}
@end
