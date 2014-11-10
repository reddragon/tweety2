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
#import "FriendsViewController.h"
#import "TweetCountViewController.h"
#import "MiscellaneousViewCounter.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UITableView *tweetList;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) IBOutlet UIScrollView *paginatedInfoView;

@property (strong, nonatomic) FriendsViewController* fvc;
@property (strong, nonatomic) TweetCountViewController* tvc;
@property (strong, nonatomic) MiscellaneousViewCounter* mvc;
@end

@implementation ProfileViewController

- (id)initWithUser:(User*)user {
    self.user = user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.user == nil) {
        NSLog(@"User is nil!");
        self.user = [User user];
    }
    self.tweets = [[NSMutableArray alloc] init];
    /*
    [self.followersCount setText:[@(self.user.numFollowers) stringValue]];
    [self.followingCount setText:[@(self.user.numFollowing) stringValue]];
    */
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width / 2];
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
    
    NSLog(@"Trying to get bg image from: %@", self.user.bgImageUrl);
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.user.bgImageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            NSLog(@"Finished handling. Data size: %lu", (unsigned long)data.length);
            UIImage* img = [[UIImage alloc] initWithData:data];
            self.bgImage.image = img;
            // self.profileImage.image = img;
        } else {
            NSLog(@"Seems like some error: %@", connectionError);
        }
    }];
    
    /*
    [self.bgImage setImageWithURL:self.user.bgImageUrl];
    [self.bgImage setImageWithURLRequest:[NSURLRequest requestWithURL:self.user.bgImageUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"Request finished!");
    } failure:];
    */
    
    // [self.bgImage set]
    
    [self.tweetList registerNib:[UINib nibWithNibName:@"TweetViewCell" bundle:nil] forCellReuseIdentifier:@"TweetViewCell"];
    self.tweetList.delegate = self;
    self.tweetList.dataSource = self;
    self.tweetList.rowHeight = UITableViewAutomaticDimension;
    [self.userName setText:self.user.name];
    [self.screenName setText:[NSString stringWithFormat:@"@%@", self.user.screenName]];
    // Do any additional setup after loading the view from its nib.
    
    self.fvc = [[FriendsViewController alloc] initWithUser:self.user];
    self.tvc = [[TweetCountViewController alloc] initWithUser:self.user];
    self.mvc = [[MiscellaneousViewCounter alloc] initWithUser:self.user];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect frame = self.paginatedInfoView.bounds;
    
    self.fvc.view.frame = frame;
    [self.paginatedInfoView addSubview:self.fvc.view];
    
    frame.origin.x += screenWidth;
    self.tvc.view.frame = frame;
    [self.paginatedInfoView addSubview:self.tvc.view];
    
    frame.origin.x += screenWidth;
    self.mvc.view.frame = frame;
    [self.paginatedInfoView addSubview:self.mvc.view];
    
    self.paginatedInfoView.contentSize = CGSizeMake(3 * screenWidth, self.paginatedInfoView.frame.size.height);
    
    [self loadData:NO];
    // NSLog(@"Dict: %@", [self.user getDictionary]);
}

- (void)loadData:(BOOL)refreshFromTop {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"user_id"] = self.user.userId;
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
