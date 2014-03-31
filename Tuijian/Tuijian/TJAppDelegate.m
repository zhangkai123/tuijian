//
//  TJAppDelegate.m
//  Tuijian
//
//  Created by zhang kai on 2/15/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJAppDelegate.h"
#import "TJLoginViewController.h"
#import "TJShowViewController.h"
#import "TJInfoViewController.h"
#import "TJMineViewController.h"

#import "GTScrollNavigationBar.h"

#import <TencentOpenAPI/TencentOAuth.h>

@implementation TJAppDelegate
@synthesize tabBarController = _tabBarController;

- (void) displayContentControllerOnController: (UIViewController*) contentController onController:(UIViewController *)controller
{
    [controller addChildViewController:contentController];
    contentController.view.frame = controller.view.frame;
    [controller.view addSubview:contentController.view];
    [contentController didMoveToParentViewController:controller];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableArray *controllersArray = [[NSMutableArray alloc]initWithCapacity:3];
    TJShowViewController *showViewController = [[TJShowViewController alloc]init];
//    UINavigationController *showNavController = [[UINavigationController alloc]initWithRootViewController:showViewController];
    UINavigationController *showNavController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    [showNavController setViewControllers:@[showViewController] animated:NO];
    
    TJInfoViewController *infoViewController = [[TJInfoViewController alloc]init];
    UINavigationController *infoNavController = [[UINavigationController alloc]initWithRootViewController:infoViewController];

    TJMineViewController *mineViewController = [[TJMineViewController alloc]init];
    UINavigationController *mineNavController = [[UINavigationController alloc]initWithRootViewController:mineViewController];

    showNavController.tabBarItem.image = [UIImage imageNamed:@"star-outline"];
    infoNavController.tabBarItem.image = [UIImage imageNamed:@"message"];
    mineNavController.tabBarItem.image = [UIImage imageNamed:@"user-outline"];
    
    [controllersArray addObject:showNavController];
    [controllersArray addObject:infoNavController];
    [controllersArray addObject:mineNavController];
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = controllersArray;
    
    [self updateInfoTabbarBadge];
    
    BOOL haveLogin = [[TJDataController sharedDataController]getUserLoginMask];
    if (!haveLogin) {
        TJLoginViewController *loginViewController = [[TJLoginViewController alloc]init];
        [self displayContentControllerOnController:loginViewController onController:self.tabBarController];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)updateInfoTabbarBadge
{
    UITabBarItem *infoItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    [infoItem setBadgeValue:@"10"];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[TJDataController sharedDataController]disConnectToXMPPServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[TJDataController sharedDataController]getUserLoginMask]) {
        [[TJDataController sharedDataController]connectToXMPPServer:^(BOOL hasOnline){
            
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
