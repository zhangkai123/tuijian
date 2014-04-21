//
//  TJAppDelegate.m
//  Tuijian
//
//  Created by zhang kai on 2/15/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJAppDelegate.h"
#import "TJRootShowController.h"
#import "TJInfoViewController.h"
#import "TJMineViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "MobClick.h"

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
    //友盟
    [MobClick startWithAppkey:@"534634c556240b06ff0fd099"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    NSMutableArray *controllersArray = [[NSMutableArray alloc]initWithCapacity:3];
    TJRootShowController *rootShowController = [[TJRootShowController alloc]init];
    UINavigationController *rootShowNavController = [[UINavigationController alloc]initWithRootViewController:rootShowController];
    
    TJInfoViewController *infoViewController = [[TJInfoViewController alloc]init];
    UINavigationController *infoNavController = [[UINavigationController alloc]initWithRootViewController:infoViewController];

    TJMineViewController *mineViewController = [[TJMineViewController alloc]init];
    UINavigationController *mineNavController = [[UINavigationController alloc]initWithRootViewController:mineViewController];

    rootShowNavController.tabBarItem.image = [UIImage imageNamed:@"star-outline"];
    infoNavController.tabBarItem.image = [UIImage imageNamed:@"message"];
    mineNavController.tabBarItem.image = [UIImage imageNamed:@"user-outline"];
    
    [controllersArray addObject:rootShowNavController];
    [controllersArray addObject:infoNavController];
    [controllersArray addObject:mineNavController];
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = controllersArray;
    
    BOOL haveLogin = [[TJDataController sharedDataController]getUserLoginMask];    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if (haveLogin) {
        self.window.rootViewController = self.tabBarController;
    }else{
        loginViewController = [[TJLoginViewController alloc]init];
        self.window.rootViewController = loginViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)loginToShowTabViewController
{
    loginViewController = nil;
    self.window.rootViewController = self.tabBarController;
}
-(void)logoutToShowLoginPage
{
    if (loginViewController == nil) {
        loginViewController = [[TJLoginViewController alloc]init];
    }
    self.window.rootViewController = loginViewController;
}
-(void)updateInfoTabbarBadge
{
    UITabBarItem *infoItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    int infoNum = [[TJDataController sharedDataController]getTotalInfoMessageNum];
    if (infoNum == 0) {
        [infoItem setBadgeValue:nil];
    }else{
        [infoItem setBadgeValue:[NSString stringWithFormat:@"%d",infoNum]];
    }
}
-(void)recieveMessage
{
    [self updateInfoTabbarBadge];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL openUrl = NO;
    if ([[TJDataController sharedDataController]sinaWeiboLogin]) {
        openUrl = [WeiboSDK handleOpenURL:url delegate:(id)loginViewController];
    }else{
        openUrl = [TencentOAuth HandleOpenURL:url];
    }
    return openUrl;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveMessage) name:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
    [self updateInfoTabbarBadge];
    if ([[TJDataController sharedDataController]getUserLoginMask]) {
        [self connectToXMPPServer];
    }else{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectToXMPPServer) name:TJ_CONNECT_XMPP_NOTIFICATION object:nil];
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:TJ_APP_ACTIVE_UPDATE_ALL_DATA object:nil];
}
-(void)connectToXMPPServer
{
    [[TJDataController sharedDataController]connectToXMPPServer:^(BOOL hasOnline){
        
    }];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
