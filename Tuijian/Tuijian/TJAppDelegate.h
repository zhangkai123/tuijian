
//
//  TJAppDelegate.h
//  Tuijian
//
//  Created by zhang kai on 2/15/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJLoginViewController.h"

@interface TJAppDelegate : UIResponder <UIApplicationDelegate>
{
    TJLoginViewController *loginViewController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UITabBarController *tabBarController;

-(void)updateInfoTabbarBadge;
-(void)loginToShowTabViewController;
-(void)logoutToShowLoginPage;

-(void)changeToInfoTab;
@end
