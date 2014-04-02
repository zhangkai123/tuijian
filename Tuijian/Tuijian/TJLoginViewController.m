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
    self.view.backgroundColor = UIColorFromRGB(0xA0BFFB);
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    [loginLabel setFont:[UIFont boldSystemFontOfSize:25]];
    loginLabel.numberOfLines = 1;
    [loginLabel setTextColor:[UIColor whiteColor]];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.text = @"登录";
    [self.view addSubview:loginLabel];
    loginLabel.center = CGPointMake(160, 60);
    
    UIButton *sinaloginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    UIImage *sinaloginImage = [UIImage imageNamed:@"weibo-icon.png"];
    [sinaloginButton setImage:sinaloginImage forState:UIControlStateNormal];
    [sinaloginButton addTarget:self action:@selector(sinalogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaloginButton];
    sinaloginButton.center = CGPointMake(160, 180);
    
    UIButton *qqloginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    qqloginButton.backgroundColor = [UIColor whiteColor];
    qqloginButton.clipsToBounds = YES;
    qqloginButton.layer.cornerRadius = 60;
    UIImage *qqloginImage = [UIImage imageNamed:@"Tencent_QQ.png"];
    [qqloginButton setImage:qqloginImage forState:UIControlStateNormal];
    [qqloginButton addTarget:self action:@selector(qqlogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqloginButton];
    qqloginButton.center = CGPointMake(160, 320);
    
    _permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_SHARE,
                     nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101035345" andDelegate:self];
}
-(void)sinalogin
{
    
}
-(void)qqlogin
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
                [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPDATE_RECOMMEND_LIST_NOTIFICATION object:nil];
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
