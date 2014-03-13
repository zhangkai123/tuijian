//
//  TJLoginViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/11/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJLoginViewController.h"

@interface TJLoginViewController ()

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
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 92, 120)];
    UIImage *loginImage = [UIImage imageNamed:@"bt_92X120.png"];
    [loginButton setImage:loginImage forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    loginButton.center = self.view.center;
    
    _permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_SHARE,
                     nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101035345" andDelegate:self];
}
-(void)login
{
    [_tencentOAuth authorize:_permissions inSafari:NO];
}
#pragma tencent delegate
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        [[TJDataController sharedDataController]saveTencentLoginInfo:_tencentOAuth];
        
        [[TJDataController sharedDataController]getTencentUserInfo:^(TJUser *tencentUser){
            [[TJDataController sharedDataController]getMyUserToken:tencentUser myUserToken:^(NSString *myUserToken){
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
