//
//  ADLoginDataController.m
//  AiDaBan
//
//  Created by zhang kai on 8/27/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJDataController.h"

@implementation TJDataController
+(id)sharedDataController
{
    static TJDataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[TJDataController alloc]init];
    });
    return dataController;
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(BOOL)getUserLoginMask
{
    return [[TJDiskCacheManager sharedDiskCacheManager]getUserLoginMask];
}
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth
{
    [[TJDiskCacheManager sharedDiskCacheManager]saveTencentLoginInfo:tencentOAuth];
}

-(void)getMyUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure
{
    NSDictionary *tencentLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getTencentLoginInfo];
    NSString *tencentUserAccessToken = [tencentLoginInfo objectForKey:TJ_TENCENT_ACCESS_TOKEN];
    [[TJNetworkManager sharedNetworkManager]sendUserTokenToServerForLogin:tencentUserAccessToken success:^(id JSON){

        NSString *success = [JSON objectForKey:@"status"];
        if ([success isEqualToString:@"success"]) {
            NSString *myAccessToken = [JSON objectForKey:@"myAccessToken"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:myAccessToken forKey:TJ_MY_ACCESS_TOKEN];
            [userDefaults synchronize];
            myUserToken(myAccessToken);
        }
    }failure:^(NSError *error){

    }];
}
-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure
{
    NSDictionary *tencentLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getTencentLoginInfo];
    [[TJNetworkManager sharedNetworkManager] sendTencentUserInfoRequest:tencentLoginInfo success:^(id JSON){

        TJUser *userInfo = [[TJUser alloc]initWithJsonData:JSON];
        [[TJDiskCacheManager sharedDiskCacheManager]saveUserInfo:userInfo];
        tencentUserInfo(userInfo);
        [[TJDiskCacheManager sharedDiskCacheManager]saveUserLoginMask:YES];
    } failure:^(NSError *error){
        failure(error);
    }];
}

//-(void)saveCurrentEditCourse:(NSDictionary *)dic
//{
//    [[ADDiskCacheManager sharedDiskCacheManager]saveCurrentEditCourse:dic];
//}
//-(NSDictionary *)getCurrentEditCourse
//{
//    return [[ADDiskCacheManager sharedDiskCacheManager]getCurrentEditCourse];
//}
//-(ADUser *)getUserInfo
//{
//    NSDictionary *userInfoDic = [[ADDiskCacheManager sharedDiskCacheManager]getUserInfoFromDisk];
//    ADUser *userInfo = [[ADUser alloc]initWithDictionaryData:userInfoDic];
//    return userInfo;
//}
//
//
@end
