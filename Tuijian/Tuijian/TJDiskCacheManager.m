//
//  ADDiskManager.m
//  AiDaBan
//
//  Created by zhang kai on 9/7/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJDiskCacheManager.h"

@implementation TJDiskCacheManager
+(id)sharedDiskCacheManager
{
    static TJDiskCacheManager *diskCacheManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        diskCacheManager = [[TJDiskCacheManager alloc]init];
    });
    return diskCacheManager;
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)saveUserEnterAppDate:(NSDate *)theDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theDate forKey:TJ_USER_STATUS_CHECK_DATE];
    [userDefaults synchronize];
}
-(NSDate *)getUserLastEnterAppDate
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastCheckDate = [userDefaults objectForKey:TJ_USER_STATUS_CHECK_DATE];
    return lastCheckDate;
}
-(BOOL)getUserLoginMask
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loginMask = [userDefaults boolForKey:TJ_USER_HAVE_LOGIN];
    return loginMask;
}
-(void)saveUserLoginMask:(BOOL)logined
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:logined forKey:TJ_USER_HAVE_LOGIN];
    [userDefaults synchronize];
}

-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth
{
    NSString *tencentUserID = tencentOAuth.openId;
    NSString *tencentUserAccessToken = tencentOAuth.accessToken;
    NSDate *tencentUserExpirationDate = tencentOAuth.expirationDate;
    NSDictionary *tencentUserLoginInfo = [NSDictionary dictionaryWithObjectsAndKeys:tencentUserID,TJ_TENCENT_USER_ID,
                                       tencentUserAccessToken,TJ_TENCENT_ACCESS_TOKEN,
                                       tencentUserExpirationDate,TJ_TENCENT_TOKEN_EXPIRATION_DATE,nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tencentUserLoginInfo forKey:TJ_TENCENT_USER_LOGIN_INFO];
    [userDefaults synchronize];
}
-(NSDictionary *)getTencentLoginInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tencentUserLoginInfo = [userDefaults objectForKey:TJ_TENCENT_USER_LOGIN_INFO];
    return tencentUserLoginInfo;
}
-(void)saveSinaLoginInfo:(WBBaseResponse *)response
{
    NSString *sinaUserID = [(WBAuthorizeResponse *)response userID];
    NSString *sinaUserAccessToken = [(WBAuthorizeResponse *)response accessToken];
    NSDate *sinaUserExpirationDate = [(WBAuthorizeResponse *)response expirationDate];
    NSDictionary *sinaUserLoginInfo = [NSDictionary dictionaryWithObjectsAndKeys:sinaUserID,TJ_SINA_USER_ID,
                                       sinaUserAccessToken,TJ_SINA_ACCESS_TOKEN,
                                       sinaUserExpirationDate,TJ_SINA_TOKEN_EXPIRATION_DATE,nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sinaUserLoginInfo forKey:TJ_SINA_USER_LOGIN_INFO];
    [userDefaults synchronize];
}
-(NSDictionary *)getSinaLoginInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaUserLoginInfo = [userDefaults objectForKey:TJ_SINA_USER_LOGIN_INFO];
    return sinaUserLoginInfo;
}

-(void)saveUserInfo:(TJUser *)user
{
    NSString *name = [user name];
    NSString *gender = [user gender];
    NSString *profile_image_url = [user profile_image_url];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:name,TJ_USER_NAME,
                              gender,TJ_USER_GENDER,
                              profile_image_url,TJ_USER_IMAGE_URL, nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userInfo forKey:TJ_USER_INFO];
    [userDefaults synchronize];
}

-(NSDictionary *)getUserInfoFromDisk
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefaults objectForKey:TJ_USER_INFO];
    return userInfo;
}
-(void)saveBlackList:(NSMutableArray *)blackListArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:blackListArray forKey:TJ_BLACK_LIST];
    [userDefaults synchronize];
}
-(NSArray *)getBlackList
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *userBlackList = [userDefaults objectForKey:TJ_BLACK_LIST];
    return userBlackList;
}
@end
