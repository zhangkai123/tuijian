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
#import "TJChatMessage.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface TJDataController : NSObject
{
    BOOL sinaWeiboLogin;
}
@property(nonatomic,assign) BOOL sinaWeiboLogin;

+(id)sharedDataController;

-(void)saveUserEnterAppDate:(NSDate *)theDate;
-(NSDate *)getUserLastEnterAppDate;
-(BOOL)getUserLoginMask;
-(void)setUserLoginMask:(BOOL)hasLogin;
-(NSString *)getMyUserId;
-(void)saveSinaLoginInfo:(WBBaseResponse *)response;
-(void)getSinaUserInfo:(void(^)(TJUser *sinaUser))sinaUserInfo failure:(void (^)(NSError *error))failure;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure;
-(BOOL)checkIfUserInBlackList:(NSString *)userId;
-(void)addUserToLocalBlackList:(NSString *)userId;
-(void)removeUserFromLocalBlackList:(NSString *)userId;
-(void)getMyUserToken:(TJUser *)theUser userCate:(NSString *)uCate myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure;
-(TJUser *)getMyUserInfo;

-(void)saveItem:(NSString *)title category:(NSString *)category recommendMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getItems:(NSString *)category itemId:(NSString *)theItemId success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;
-(void)saveLike:(NSString *)itemId success:(void (^)(BOOL hasLiked))liked failure:(void (^)(NSError *error))failure;
-(void)saveComment:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(BOOL hasCommented))succeed failure:(void (^)(NSError *error))failure;
-(void)getLikesComments:(NSString *)itemId likes:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failure:(void (^)(NSError *error))failure;
-(void)getItemWholeInfo:(NSString *)itemId theItem:(void (^)(TJItem *theItem))item likesArray:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failed:(void (^)(NSError *error))failed;
-(TJComment *)getMyOwnCommentItem:(NSString *)commentInfo;
-(TJItemMessage *)getMyOwnMessageItem:(NSString *)replyMessage;
-(TJUser *)getMyWholeUserInfo;
-(void)getUserItems:(NSString *)userId success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;
-(void)uploadUserPhoto:(UIImage *)uPhoto progress:(void (^)(float uploadProgess))uploadPro success:(void (^)(NSString *uploadImageUrl))success failure:(void (^)(NSError *error))failure;
-(void)getUserInformationFromServer:(NSString *)theUserId success:(void (^)(TJUser *theUser))success failure:(void (^)(NSError *error))failure;
-(void)updateMoodInformation:(NSString *)moodInfor success:(void (^)(BOOL updated))success failure:(void (^)(NSError *error))failure;
-(void)removePhotoWithId:(NSString *)photoId success:(void (^)(BOOL updated))success failure:(void (^)(NSError *error))failure;
-(void)reportUser:(NSString *)reportedId reportedPhoto:(UIImage *)reportedPhoto reportText:(NSString *)reportText success:(void (^)(BOOL succeed))success failure:(void (^)(NSError *error))failure;
-(void)getUserStatus:(NSString *)usercpFlag success:(void (^)(BOOL reported))success failure:(void (^)(NSError *error))failure;

#pragma XMPP Server
-(void)connectToXMPPServer:(void (^)(BOOL hasOnline))success;
-(void)disConnectToXMPPServer;
-(void)sendHiMessageTo:(NSString *)toUserId messageContent:(NSString *)mContent;
-(void)sendChatMessageTo:(NSString *)toUserId chatMessage:(NSString *)chatMessage;
-(void)sendLike:(TJItem *)item;
-(void)sendComment:(TJItem *)item comment:(NSString *)commentInfo;
-(void)replyComment:(TJUser *)user theItem:(TJItem *)item comment:(NSString *)commentInfo;
-(void)replyMessage:(TJItemMessage *)itemMessage theMessage:(TJMessage *)theMessage comment:(NSString *)commentInfo;
#pragma database
-(NSArray *)featchMessageList;
-(void)deleteFromMessageList:(NSString *)mId messageType:(NSString *)mType;
-(NSArray *)featchItemMessage:(NSString *)mId;
-(NSArray *)featchHiMessage:(int)pageNum;
-(void)haveReadHiMessage:(NSString *)hiMessageLocalId;
-(NSArray *)featchChatMessage:(NSString *)mId byPage:(int)pageNum;
-(void)insertLocalChatMessage:(NSString *)mId myChatMessage:(TJChatMessage *)myChatMessage messageList:(TJMessage *)mes;
-(int)getTotalInfoMessageNum;
-(void)clearInfoMessageNum:(int)messageId messageType:(NSString *)mType;
@end
