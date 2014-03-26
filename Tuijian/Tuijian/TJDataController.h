//
//  ADLoginDataController.h
//  AiDaBan
//
//  Created by zhang kai on 8/27/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJNetworkManager.h"
#import "TJDiskCacheManager.h"
#import "TJDBManager.h"
#import "TJXMPPServerMananger.h"
#import "TJUser.h"
#import "TJComment.h"
#import "TJItem.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface TJDataController : NSObject


+(id)sharedDataController;

-(BOOL)getUserLoginMask;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(void)getMyUserToken:(TJUser *)theUser myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure;
-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure;
-(TJUser *)getMyUserInfo;
-(void)saveItem:(NSString *)title recommendMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getItems:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;
-(void)saveLike:(NSString *)itemId success:(void (^)(BOOL hasLiked))liked failure:(void (^)(NSError *error))failure;
-(void)saveComment:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(BOOL hasCommented))succeed failure:(void (^)(NSError *error))failure;
-(void)getLikesComments:(NSString *)itemId likes:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failure:(void (^)(NSError *error))failure;
-(TJComment *)getMyOwnCommentItem:(NSString *)commentInfo;

#pragma XMPP Server
-(void)connectToXMPPServer:(void (^)(BOOL hasOnline))success;
-(void)disConnectToXMPPServer;
-(void)sendLike:(TJItem *)item;
-(void)sendComment:(TJItem *)item comment:(NSString *)commentInfo;

#pragma database
-(NSArray *)featchMessageList;
@end
