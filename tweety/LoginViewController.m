//
//  LoginViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()
- (IBAction)onLoginButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)onLoginButtonPressed:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present something;
            NSLog(@"Welcome to %@", user.name);
            TweetsViewController* tvc = [[TweetsViewController alloc] init];
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:tvc];
            nc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238.0/255.0 alpha:1.0];
            nc.navigationBar.tintColor = [UIColor whiteColor];
            [nc.navigationBar setBarStyle:UIStatusBarStyleLightContent];
            
            [self presentViewController:nc animated:YES completion:nil];
        } else {
            // Error!
            NSLog(@"Uh oh! Error: %@", error);
        }
    }];
}
@end
