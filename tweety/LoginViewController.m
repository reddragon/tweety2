//
//  LoginViewController.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "MainScreenController.h"

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
            MainScreenController* msc = [[MainScreenController alloc] init];
            [self presentViewController:msc animated:YES completion:nil];
        } else {
            // Error!
            NSLog(@"Uh oh! Error: %@", error);
        }
    }];
}
@end
