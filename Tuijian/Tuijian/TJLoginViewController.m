//
//  TJLoginViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/11/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJLoginViewController.h"
#import "TJAppDelegate.h"
#import "TJAcceptViewController.h"

@interface TJLoginViewController ()<TTTAttributedLabelDelegate>
{
    UIImageView *acceptImageView;
    BOOL haveAgreed;
    
    UIView *coverView;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation TJLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xA0BFFB);
    
    coverView = [[UIView alloc]initWithFrame:self.view.frame];
    coverView.backgroundColor = UIColorFromRGB(0xA0BFFB);
    [self.view addSubview:coverView];
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    [loginLabel setFont:[UIFont boldSystemFontOfSize:25]];
    loginLabel.numberOfLines = 1;
    [loginLabel setTextColor:[UIColor whiteColor]];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.text = @"登录";
    [coverView addSubview:loginLabel];
    loginLabel.center = CGPointMake(160, 60);
    
    UIButton *sinaloginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    UIImage *sinaloginImage = [UIImage imageNamed:@"weibo-icon.png"];
    [sinaloginButton setImage:sinaloginImage forState:UIControlStateNormal];
    [sinaloginButton addTarget:self action:@selector(sinalogin) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:sinaloginButton];
    sinaloginButton.center = CGPointMake(160, 180);
    
    UIButton *qqloginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    qqloginButton.backgroundColor = [UIColor darkGrayColor];
    [qqloginButton setAlpha:0.4];
    qqloginButton.clipsToBounds = YES;
    qqloginButton.layer.cornerRadius = 60;
    UIImage *qqloginImage = [UIImage imageNamed:@"Tencent_QQ.png"];
    [qqloginButton setImage:qqloginImage forState:UIControlStateNormal];
    [qqloginButton addTarget:self action:@selector(qqlogin) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:qqloginButton];
    qqloginButton.center = CGPointMake(160, 320);
    
    
    float scrrenHeight = [[UIScreen mainScreen]bounds].size.height;
    UIButton *acceptButton = [[UIButton alloc]initWithFrame:CGRectMake(60, scrrenHeight - 55, 20, 20)];
    [acceptButton addTarget:self action:@selector(acceptAgreement) forControlEvents:UIControlEventTouchUpInside];
    acceptButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:acceptButton];
    
    acceptImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    acceptImageView.image = [UIImage imageNamed:@"accept.png"];
    [acceptButton addSubview:acceptImageView];
    acceptImageView.center = CGPointMake(10, 10);
    
    NSString *acceptText = @"我已阅读并接受《用户协议》";
    TTTAttributedLabel *acceptLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(90, scrrenHeight - 60, 300, 30)];
    acceptLabel.delegate = self;
    [acceptLabel setFont:[UIFont boldSystemFontOfSize:14]];
    acceptLabel.numberOfLines = 1;
    [acceptLabel setTextColor:[UIColor lightTextColor]];
    [acceptLabel createNoLineLinkAttributes:[UIColor whiteColor]];
    acceptLabel.text = acceptText;
    [acceptLabel addLinkToURL:[NSURL URLWithString:@"action://gotoItemPage"] withRange:[acceptText rangeOfString:@"《用户协议》"]];
    [self.view addSubview:acceptLabel];
    
    haveAgreed = YES;
    
    _permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_SHARE,
                     nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:TJ_TENCENT_APP_ID andDelegate:self];
    
    [WeiboSDK registerApp:TJ_SINA_kAppKey];
}
-(void)sinalogin
{
    if (!haveAgreed) {
        return;
    }
    [[TJDataController sharedDataController] setSinaWeiboLogin:YES];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = TJ_SINA_kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"TJLoginViewController"};
    [WeiboSDK sendRequest:request];
}
-(void)qqlogin
{
    if (!haveAgreed) {
        return;
    }
    [[TJDataController sharedDataController] setSinaWeiboLogin:NO];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}
-(void)acceptAgreement
{
    if (haveAgreed) {
        haveAgreed = NO;
        acceptImageView.hidden = YES;
    }else{
        haveAgreed = YES;
        acceptImageView.hidden = NO;
    }
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"gotoItemPage"]) {
            TJAcceptViewController *acceptViewController = [[TJAcceptViewController alloc]init];
            UINavigationController *acceptNaviagtionController = [[UINavigationController alloc]initWithRootViewController:acceptViewController];
            [self presentViewController:acceptNaviagtionController animated:YES completion:nil];
        }
    }
}
-(void)loadingToLogin
{
    coverView.hidden = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    [loginLabel setFont:[UIFont boldSystemFontOfSize:25]];
    loginLabel.numberOfLines = 1;
    [loginLabel setTextColor:[UIColor whiteColor]];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.text = @"正在登录...";
    [self.view addSubview:loginLabel];
    loginLabel.center = CGPointMake(160, self.view.center.y - 60);
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}
#pragma sina weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        //        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
        //        [self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *userInfoStr = [response.requestUserInfo objectForKey:@"SSO_From"];
        if ([userInfoStr isEqualToString:@"TJLoginViewController"]) {
            
            if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
                [self loadingToLogin];
                [[TJDataController sharedDataController]saveSinaLoginInfo:response];
                [[TJDataController sharedDataController]getSinaUserInfo:^(TJUser *sinaUser){
                    [[TJDataController sharedDataController]getMyUserToken:sinaUser userCate:@"sina" myUserToken:^(NSString *myUserToken){
                        [[NSNotificationCenter defaultCenter]postNotificationName:TJ_CONNECT_XMPP_NOTIFICATION object:nil];
                        TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                        [appDelegate loginToShowTabViewController];
                        [activityIndicator stopAnimating];
                        [self dismissMyViewController:self];
                    }failure:^(NSError *error){
                        
                    }];
                }failure:^(NSError *error){
                    
                }];
            }
        }
    }
}
#pragma tencent delegate
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        [self loadingToLogin];
        // 记录登录用户的OpenID、Token以及过期时间
        [[TJDataController sharedDataController]saveTencentLoginInfo:_tencentOAuth];
        [[TJDataController sharedDataController]getTencentUserInfo:^(TJUser *tencentUser){
            [[TJDataController sharedDataController]getMyUserToken:tencentUser userCate:@"tencent" myUserToken:^(NSString *myUserToken){
                [[NSNotificationCenter defaultCenter]postNotificationName:TJ_CONNECT_XMPP_NOTIFICATION object:nil];
                TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                [appDelegate loginToShowTabViewController];
                [activityIndicator stopAnimating];
                [self dismissMyViewController:self];
            }failure:^(NSError *error){
                
            }];
        }failure:^(NSError *error){
            
        }];

    }
    else
    {
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
//		_labelTitle.text = @"用户取消登录";
	}
	else {
//		_labelTitle.text = @"登录失败";
	}
}
-(void)tencentDidNotNetWork
{
//    _labelTitle.text=@"无网络连接，请设置网络";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
