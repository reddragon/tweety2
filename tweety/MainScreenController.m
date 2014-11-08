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

@interface MainScreenController ()
@property UIViewController* menuVC;
@property UIViewController* contentVC;
@property UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property CGSize menuSize;
@end

@implementation MainScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.containerView.bounds;
    CGRect frame2 = frame;
    
    CGSize menuSize = self.containerView.frame.size;
    menuSize.width = menuSize.width - 75.0;
    self.menuSize = menuSize;
    
    frame.origin.x = self.menuSize.width;
    TweetsViewController* tvc = [[TweetsViewController alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238.0/255.0 alpha:1.0];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    [nvc.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    self.contentVC = nvc;
    self.contentVC.view.frame = frame;
    
    frame2.origin.x = 0;
    frame2.size.width = menuSize.width;
    self.menuVC = [[HamburgerMenuController alloc] init];
    self.menuVC.view.frame = frame2;
    self.menuVC.view.bounds = frame2;
    
    // self.containerView.conte
    
    CGRect frame3 = self.containerView.bounds;
    frame3.origin.x = self.menuSize.width;
    self.containerView.bounds = frame3;
    
    [self.containerView addSubview:self.menuVC.view];
    [self.containerView addSubview:self.contentVC.view];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.containerView addGestureRecognizer:self.panGesture];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)onPan:(UIGestureRecognizer*)sender {
    NSLog(@"onPan");
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [self.panGesture velocityInView:self.containerView];
        if (p.x > 100) {
            
            [UIView animateWithDuration:0.4 animations:^{
                // CGRect frame = self.containerView.bounds;
                // frame.origin.x = -160;
                // self.containerView.bounds = frame;
                /*
                CGRect frame3 = self.containerView.bounds;
                frame3.origin.x = 0;
                self.containerView.bounds = frame3;
                */
                
                CGRect frame1 = self.menuVC.view.frame;
                frame1.origin.x += self.menuSize.width;
                self.menuVC.view.frame = frame1;
                
                CGRect frame2 = self.contentVC.view.frame;
                frame2.origin.x += self.menuSize.width;
                self.contentVC.view.frame = frame2;
                
            }];
            /*
            NSLog(@"Left");
            CGRect frame = self.containerView.bounds;
            frame.origin.x = -320;
            self.containerView.bounds = frame;
            */
        } else if (p.x < -100) {
            [UIView animateWithDuration:0.4 animations:^{
                /*
                CGRect frame3 = self.containerView.bounds;
                frame3.origin.x = 160;
                self.containerView.bounds = frame3;
                */
                CGRect frame1 = self.menuVC.view.frame;
                frame1.origin.x -= self.menuSize.width;
                self.menuVC.view.frame = frame1;
                
                CGRect frame2 = self.contentVC.view.frame;
                frame2.origin.x -= self.menuSize.width;
                self.contentVC.view.frame = frame2;
            }];
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
