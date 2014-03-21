//
//  ADLoginDataController.m
//  AiDaBan
//
//  Created by zhang kai on 8/27/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import "TJDataController.h"
#import "TJParser.h"

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

-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure
{
    NSDictionary *tencentLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getTencentLoginInfo];
    [[TJNetworkManager sharedNetworkManager] sendTencentUserInfoRequest:tencentLoginInfo success:^(id JSON){
        
        TJUser *userInfo = [[TJUser alloc]initWithJsonData:JSON];
        [[TJDiskCacheManager sharedDiskCacheManager]saveUserInfo:userInfo];
        tencentUserInfo(userInfo);
    } failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getMyUserToken:(TJUser *)theUser myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure
{
    NSDictionary *tencentLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getTencentLoginInfo];
    NSString *tencentUserAccessToken = [tencentLoginInfo objectForKey:TJ_TENCENT_ACCESS_TOKEN];
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:theUser.name,@"userName",theUser.profile_image_url,@"profileUrl",theUser.gender,@"gender",nil];
    [[TJNetworkManager sharedNetworkManager]sendUserTokenToServerForLogin:tencentUserAccessToken userInfo:userInfoDic success:^(id JSON){

        NSString *success = [JSON objectForKey:@"status"];
        if ([success isEqualToString:@"success"]) {
            NSString *myAccessToken = [JSON objectForKey:@"myAccessToken"];
            NSString *myUserId = [JSON objectForKey:@"myUserId"];
            NSString *myUserPassword = [JSON objectForKey:@"myPassword"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:myAccessToken forKey:TJ_MY_ACCESS_TOKEN];
            [userDefaults setObject:[NSString stringWithFormat:@"%@",myUserId] forKey:TJ_MY_USER_ID];
            [userDefaults setObject:myUserPassword forKey:TJ_MY_USER_PASSWORD];
            [userDefaults synchronize];
            myUserToken(myAccessToken);
            [[TJDiskCacheManager sharedDiskCacheManager]saveUserLoginMask:YES];
        }
    }failure:^(NSError *error){

    }];
}
-(TJUser *)getMyUserInfo
{
    NSDictionary *userInfoDic = [[TJDiskCacheManager sharedDiskCacheManager]getUserInfoFromDisk];
    TJUser *userInfo = [[TJUser alloc]initWithDictionaryData:userInfoDic];
    return userInfo;
}
-(NSString *)getMyUserToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myAccessToken = [userDefaults objectForKey:TJ_MY_ACCESS_TOKEN];
    return myAccessToken;
}
-(NSString *)getMyUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myUserId = [userDefaults objectForKey:TJ_MY_USER_ID];
    return myUserId;
}
-(NSString *)getMyUserPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *myUserPassword = [userDefaults objectForKey:TJ_MY_USER_PASSWORD];
    return myUserPassword;
}

-(void)saveItem:(NSString *)title recommendMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *uid = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]uploadItem:myAccessToken uid:uid title:title recMes:recommendMes uploadImage:ulImage success:^(id Json){
        
        success(Json);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getItems:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendFeatchItemsRequest:myAccessToken uid:myUserId success:^(id Json){
        
        NSArray *itemsArray = [TJParser parseItemsJsonData:Json];
        success(itemsArray);
    }failure:^(NSError *error){
        
        failure(error);
    }];
}
-(void)saveLike:(NSString *)itemId success:(void (^)(BOOL hasLiked))liked failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendLikeRequest:myAccessToken uid:myUserId itemId:itemId success:^(id Json){
        [TJParser parseLikeJsonData:Json success:^(BOOL hasLiked){
            liked(hasLiked);
        }failed:^(NSError *error){
            failure(error);
        }];
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)saveComment:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(BOOL hasCommented))succeed failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendComment:myAccessToken uid:myUserId itemId:itemId commentInfo:commentInfo success:^(id Json){
        BOOL success = [TJParser parseStatusJsonData:Json];
        succeed(success);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getLikesComments:(NSString *)itemId likes:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failure:(void (^)(NSError *error))failure
{
    [[TJNetworkManager sharedNetworkManager]getLikesAndComments:itemId success:^(id Json){
        [TJParser parseLikesCommentsData:Json likesArray:^(NSArray *likesArray){
            lArray(likesArray);
        }comments:^(NSArray *commentsArray){
            cArray(commentsArray);
        }failed:^(NSError *error){
            failure(error);
        }];
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(TJComment *)getMyOwnCommentItem:(NSString *)commentInfo
{
    TJComment *comment = [[TJComment alloc]init];
    TJUser *user = [self getMyUserInfo];
    NSString *accessToken = [self getMyUserToken];
    user.accessToken = accessToken;
    comment.user = user;
    comment.info = commentInfo;
    return comment;
}

#pragma XMPP Server
-(void)connectToXMPPServer:(void (^)(BOOL hasOnline))success
{
    NSString *myUserId = [self getMyUserId];
    NSString *myUserPassword = [self getMyUserPassword];
    [[TJXMPPServerMananger sharedXMPPServerMananger]userConnectToXMPPServer:myUserId password:myUserPassword success:^(BOOL hasOnline){
        success(hasOnline);
    }];
}
-(void)disConnectToXMPPServer
{
    [[TJXMPPServerMananger sharedXMPPServerMananger]disconnect];
}
-(void)sendLike:(NSString *)userId itemId:(NSString *)itemId
{
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendLike:userId itemId:itemId];
}
-(void)sendMessage:(NSString *)msgContent toUser:(NSString *)userId
{
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendMessage:msgContent toUser:userId];
}
@end
