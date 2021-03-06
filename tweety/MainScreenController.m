//
//  MainScreenController.m
//  tweety
//
//  Created by Gaurav Menghani on 11/7/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "MainScreenController.h"
#import "HamburgerMenuController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

@interface MainScreenController ()
@property UIViewController* menuVC;
@property UIViewController* contentVC;
@property UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property CGSize menuSize;
@property BOOL menuExpanded;
@end

@implementation MainScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuExpanded = NO;
    CGRect frame = self.containerView.bounds;
    CGRect frame2 = frame;
    
    CGSize menuSize = self.containerView.frame.size;
    menuSize.width = menuSize.width - 75.0;
    self.menuSize = menuSize;
    
    frame.origin.x = self.menuSize.width;
    TweetsViewController* tvc = [[TweetsViewController alloc] init];
    tvc.delegate = self;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238.0/255.0 alpha:1.0];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    [nvc.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    self.contentVC = nvc;
    self.contentVC.view.frame = frame;
    
    frame2.origin.x = 0;
    frame2.size.width = menuSize.width;
    HamburgerMenuController* menuVC = [[HamburgerMenuController alloc] init];
    menuVC.delegate = self;
    self.menuVC = menuVC;
    self.menuVC.view.frame = frame2;
    self.menuVC.view.bounds = frame2;
    
    CGRect frame3 = self.containerView.bounds;
    frame3.origin.x = self.menuSize.width;
    self.containerView.bounds = frame3;
    
    [self.containerView addSubview:self.menuVC.view];
    [self.containerView addSubview:self.contentVC.view];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) foldMenu {
    self.menuExpanded = NO;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame1 = self.menuVC.view.frame;
        frame1.origin.x -= self.menuSize.width;
        self.menuVC.view.frame = frame1;
        
        CGRect frame2 = self.contentVC.view.frame;
        frame2.origin.x -= self.menuSize.width;
        self.contentVC.view.frame = frame2;
    }];
}

- (void) expandMenu {
    self.menuExpanded = YES;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame1 = self.menuVC.view.frame;
        frame1.origin.x += self.menuSize.width;
        self.menuVC.view.frame = frame1;
        
        CGRect frame2 = self.contentVC.view.frame;
        frame2.origin.x += self.menuSize.width;
        self.contentVC.view.frame = frame2;
        
    }];
}

- (void)toggleHamburgerMenu {
    if (self.menuExpanded) {
        [self foldMenu];
    } else {
        [self expandMenu];
    }
}

- (void)onMentions {
    NSLog(@"Mentions fired");
    [self foldMenu];
    TweetsViewController* mvc = [[TweetsViewController alloc] init];
    mvc.operation = @"mentions";
    UINavigationController* nvc = (UINavigationController*) self.contentVC;
    [nvc pushViewController:mvc animated:YES ];
}

- (void)onProfile {
    NSLog(@"Profile fired");
    [self foldMenu];
    ProfileViewController* pvc = [[ProfileViewController alloc] init];
    // mvc.operation = @"mentions";
    UINavigationController* nvc = (UINavigationController*) self.contentVC;
    [nvc pushViewController:pvc animated:YES ];
}

- (void)onLogout {
    [User logout];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)onPan:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [self.panGesture velocityInView:self.containerView];
        if (p.x > 100) {
            [self expandMenu];
        } else if (p.x < -100) {
            [self foldMenu];
        }
    }
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
