//
//  ADNetworkManager.m
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJNetworkManager.h"
#import "TJTencentAPIClient.h"
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

-(void)sendTencentUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJTencentAPIClient *client = [TJTencentAPIClient sharedClient];
    
    NSString *userId = [sinaUserInfo objectForKey:TJ_TENCENT_USER_ID];
    NSString *accessToken = [sinaUserInfo objectForKey:TJ_TENCENT_ACCESS_TOKEN];
    
    NSString *path = @"user/get_user_info";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"openid",accessToken,@"access_token",@"101035345",@"oauth_consumer_key", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendUserTokenToServerForLogin:(NSString *)access_token userInfo:(NSDictionary *)userInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"Login/ThirdPartyUserLogin";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:@"tencent",@"user_category",access_token,@"access_token",userInfo,@"userInfomation", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)uploadItem:(NSString *)accessT recMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"uploadItem";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",recommendMes,@"recommendMessage", nil];
    NSData *imgData = UIImagePNGRepresentation(ulImage);
    NSMutableURLRequest *myRequest = [client multipartFormRequestWithMethod:@"POST" path:path
                                                                 parameters:paraDic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                                     [formData appendPartWithFileData:imgData name:@"uploadedfile" fileName:@"myDynamicFile.png" mimeType:@"images/png"];
                                                                 }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:myRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendFeatchItemsRequest:(NSString *)accessT success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"featchItems";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendLikeRequest:(NSString *)accessT itemId:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"likeRequest";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"userId",itemId,@"itemId", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}

@end
