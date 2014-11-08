//
//  AppDelegate.m
//  tweety
//
//  Created by Gaurav Menghani on 10/27/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetsViewController.h"
#import "MainScreenController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    
    User* currentUser = [User user];
    MainScreenController* msc = [[MainScreenController alloc] init];
    self.window.rootViewController = msc;
    /*
    if (currentUser != nil) {
        NSLog(@"Welcome %@", currentUser.name);
        TweetsViewController* tvc = [[TweetsViewController alloc] init];
        UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:tvc];
        nc.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238.0/255.0 alpha:1.0];
        nc.navigationBar.tintColor = [UIColor whiteColor];
        [nc.navigationBar setBarStyle:UIStatusBarStyleLightContent];
        self.window.rootViewController = nc;
    } else {
        NSLog(@"Not logged in");
        LoginViewController* lvc = [[LoginViewController alloc] init];
        self.window.rootViewController = lvc;
    } */
    
    return YES;
}

- (void)userDidLogout {
    LoginViewController* lvc = [[LoginViewController alloc] init];
    self.window.rootViewController = lvc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] openURL:url];
    return YES;
}

@end
