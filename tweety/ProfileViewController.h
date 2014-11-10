//
//  ProfileViewController.h
//  tweety
//
//  Created by Gaurav Menghani on 11/8/14.
//  Copyright (c) 2014 Gaurav Menghani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithUser:(User*)user;
@end
