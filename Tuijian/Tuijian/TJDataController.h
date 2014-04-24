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
#import "TJItemMessage.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface TJDataController : NSObject
{
    BOOL sinaWeiboLogin;
}
@property(nonatomic,assign) BOOL sinaWeiboLogin;

+(id)sharedDataController;

-(BOOL)getUserLoginMask;
-(void)setUserLoginMask:(BOOL)hasLogin;
-(NSString *)getMyUserId;
-(void)saveSinaLoginInfo:(WBBaseResponse *)response;
-(void)getSinaUserInfo:(void(^)(TJUser *sinaUser))sinaUserInfo failure:(void (^)(NSError *error))failure;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure;
-(void)getMyUserToken:(TJUser *)theUser userCate:(NSString *)uCate myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure;
-(TJUser *)getMyUserInfo;

-(void)saveItem:(NSString *)title category:(NSString *)category recommendMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getItems:(NSString *)category success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;
-(void)saveLike:(NSString *)itemId success:(void (^)(BOOL hasLiked))liked failure:(void (^)(NSError *error))failure;
-(void)saveComment:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(BOOL hasCommented))succeed failure:(void (^)(NSError *error))failure;
-(void)getLikesComments:(NSString *)itemId likes:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failure:(void (^)(NSError *error))failure;
-(void)getItemWholeInfo:(NSString *)itemId theItem:(void (^)(TJItem *theItem))item likesArray:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failed:(void (^)(NSError *error))failed;
-(TJComment *)getMyOwnCommentItem:(NSString *)commentInfo;
-(TJItemMessage *)getMyOwnMessageItem:(NSString *)replyMessage;
-(TJUser *)getMyWholeUserInfo;
-(void)getUserItems:(NSString *)userId success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;

#pragma XMPP Server
-(void)connectToXMPPServer:(void (^)(BOOL hasOnline))success;
-(void)disConnectToXMPPServer;
-(void)sendChatMessageTo:(NSString *)toUserId chatMessage:(NSString *)chatMessage;
-(void)sendLike:(TJItem *)item;
-(void)sendComment:(TJItem *)item comment:(NSString *)commentInfo;
-(void)replyComment:(TJUser *)user theItem:(TJItem *)item comment:(NSString *)commentInfo;
-(void)replyMessage:(TJItemMessage *)itemMessage theMessage:(TJMessage *)theMessage comment:(NSString *)commentInfo;
#pragma database
-(NSArray *)featchMessageList;
-(void)deleteFromMessageList:(NSString *)mId messageType:(NSString *)mType;
-(NSArray *)featchItemMessage:(NSString *)mId;
-(NSArray *)featchChatMessage:(NSString *)mId;
-(int)getTotalInfoMessageNum;
-(void)clearInfoMessageNum:(int)messageId messageType:(NSString *)mType;
@end
