//
//  HamburgerMenuController.m
//  tweety
//
//  Created by Gaurav Menghani on 11/7/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "HamburgerMenuController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface HamburgerMenuController ()
@property User* user;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *handle;
- (IBAction)onMentions:(id)sender;
- (IBAction)onProfile:(id)sender;
- (IBAction)onLogout:(id)sender;


@end

@implementation HamburgerMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.user = [User user];
    [self.userName setText:self.user.name];
    [self.handle setText:[NSString stringWithFormat:@"@%@", self.user.screenName]];
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    [self.profileImage.layer setCornerRadius:self.profileImage.frame.size.width / 2];
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:220/255.0 green:235/255.0 blue:252.0/255.0 alpha:1.0].CGColor;
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

- (IBAction)onMentions:(id)sender {
    if (self.delegate != nil) {
        [self.delegate onMentions];
    }
}

- (IBAction)onProfile:(id)sender {
    if (self.delegate != nil) {
        [self.delegate onProfile];
    }
}

- (IBAction)onLogout:(id)sender {
    if (self.delegate != nil) {
        [self.delegate onLogout];
    }
}
@end
