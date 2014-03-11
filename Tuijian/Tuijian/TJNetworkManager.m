//
//  ADNetworkManager.m
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJNetworkManager.h"
//#import "ADSinaAPIClient.h"
#import "TJMyServerClient.h"

@implementation TJNetworkManager
+(id)sharedNetworkManager
{
    static TJNetworkManager *networkManagerController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        networkManagerController = [[TJNetworkManager alloc]init];
    });
    return networkManagerController;
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}

//-(void)sendSinaUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
//{
//    ADSinaAPIClient *client = [ADSinaAPIClient sharedClient];
//    
//    NSString *userId = [sinaUserInfo objectForKey:AD_SINA_USER_ID];
//    NSString *accessToken = [sinaUserInfo objectForKey:AD_SINA_ACCESS_TOKEN];
//    
//    NSString *path = @"users/show.json";
//    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"uid",accessToken,@"access_token", nil];
//    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        
//        success(JSON);
//    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        
//        failure(error);
//    }];
//    [operation start];
//}
-(void)sendUserTokenToServerForLogin:(NSString *)access_token success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"Login/ThirdPartyUserLogin";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencent",@"user_category",access_token,@"access_token", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
@end
