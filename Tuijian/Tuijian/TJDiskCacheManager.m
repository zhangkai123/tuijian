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
-(BOOL)getUserLoginMask
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loginMask = [userDefaults boolForKey:TJ_USER_HAVE_LOGIN];
    return loginMask;
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
-(void)saveUserLoginMask:(BOOL)logined
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:logined forKey:TJ_USER_HAVE_LOGIN];
    [userDefaults synchronize];
}

-(NSDictionary *)getUserInfoFromDisk
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefaults objectForKey:TJ_USER_INFO];
    return userInfo;
}
//-(void)saveCurrentEditCourse:(NSDictionary *)dic
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:dic forKey:AD_CURRENT_EDIT_COURSE];
//    [userDefaults synchronize];
//}
//-(NSDictionary *)getCurrentEditCourse
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *currentEditCourseDic = [userDefaults objectForKey:AD_CURRENT_EDIT_COURSE];
//    return currentEditCourseDic;
//}

@end