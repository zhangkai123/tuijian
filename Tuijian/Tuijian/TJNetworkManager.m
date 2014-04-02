//
//  ADNetworkManager.m
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJNetworkManager.h"
#import "TJTencentAPIClient.h"
#import "TJSinaAPIClient.h"
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
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"openid",accessToken,@"access_token",TJ_TENCENT_APP_ID,@"oauth_consumer_key", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendSinaUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJSinaAPIClient *client = [TJSinaAPIClient sharedClient];
    
    NSString *userId = [sinaUserInfo objectForKey:TJ_SINA_USER_ID];
    NSString *accessToken = [sinaUserInfo objectForKey:TJ_SINA_ACCESS_TOKEN];
    
    NSString *path = @"users/show.json";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"uid",accessToken,@"access_token", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendUserTokenToServerForLogin:(NSString *)access_token userCate:(NSString *)uCate userInfo:(NSDictionary *)userInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"Login/ThirdPartyUserLogin";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:uCate,@"user_category",access_token,@"access_token",userInfo,@"userInfomation", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)uploadItem:(NSString *)accessT uid:(NSString *)uid title:(NSString *)title recMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"uploadItem";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",uid,@"uid",title,@"title",recommendMes,@"recommendMessage", nil];
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
-(void)sendFeatchItemsRequest:(NSString *)accessT uid:(NSString *)uid success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"featchItems";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",uid,@"uid", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendLikeRequest:(NSString *)accessT uid:(NSString *)uid itemId:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"likeRequest";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",uid,@"uid",itemId,@"itemId", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendComment:(NSString *)accessT uid:(NSString *)uid itemId:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"commentRequest";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",uid,@"uid",itemId,@"itemId",commentInfo ,@"CommentInfo" ,nil];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)getLikesAndComments:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"featchLikesAndComments";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:itemId,@"itemId", nil];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paraDic];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        success(JSON);
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        failure(error);
    }];
    [operation start];
}
-(void)sendFeatchUserItemsRequest:(NSString *)accessT uid:(NSString *)uid success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    TJMyServerClient *client = [TJMyServerClient sharedClient];
    NSString *path = @"featchUserItems";
    NSDictionary *paraDic = [NSDictionary dictionaryWithObjectsAndKeys:accessT,@"accessToken",uid,@"uid", nil];
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
