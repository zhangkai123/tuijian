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
@synthesize sinaWeiboLogin;

+(id)sharedDataController
{
    static TJDataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[TJDataController alloc]init];
    });
    return dataController;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveMessage:) name:TJ_RECIEVE_MESSAGE_NOTIFICATION object:nil];
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
        
        TJUser *userInfo = [[TJUser alloc]initWithTencentJsonData:JSON];
        [[TJDiskCacheManager sharedDiskCacheManager]saveUserInfo:userInfo];
        tencentUserInfo(userInfo);
    } failure:^(NSError *error){
        failure(error);
    }];
}

-(void)saveSinaLoginInfo:(WBBaseResponse *)response
{
    [[TJDiskCacheManager sharedDiskCacheManager]saveSinaLoginInfo:response];
}
-(void)getSinaUserInfo:(void(^)(TJUser *sinaUser))sinaUserInfo failure:(void (^)(NSError *error))failure
{
    NSDictionary *sinaLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getSinaLoginInfo];
    [[TJNetworkManager sharedNetworkManager]sendSinaUserInfoRequest:sinaLoginInfo success:^(id JSON){
        
        TJUser *userInfo = [[TJUser alloc]initWithSinaJsonData:JSON];
        [[TJDiskCacheManager sharedDiskCacheManager]saveUserInfo:userInfo];
        sinaUserInfo(userInfo);
    }failure:^(NSError *error){
        failure(error);
    }];
}

-(void)getMyUserToken:(TJUser *)theUser userCate:(NSString *)uCate myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure
{
    NSString *thirdPartAccessToken = nil;
    if ([uCate isEqualToString:@"tencent"]) {
        NSDictionary *tencentLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getTencentLoginInfo];
        thirdPartAccessToken = [tencentLoginInfo objectForKey:TJ_TENCENT_ACCESS_TOKEN];
    }else{
        NSDictionary *sinaLoginInfo = [[TJDiskCacheManager sharedDiskCacheManager]getSinaLoginInfo];
        thirdPartAccessToken = [sinaLoginInfo objectForKey:TJ_SINA_ACCESS_TOKEN];
    }
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:theUser.name,@"userName",theUser.profile_image_url,@"profileUrl",theUser.gender,@"gender",nil];
    [[TJNetworkManager sharedNetworkManager]sendUserTokenToServerForLogin:thirdPartAccessToken userCate:uCate userInfo:userInfoDic success:^(id JSON){

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

-(void)saveItem:(NSString *)title category:(NSString *)category recommendMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *uid = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]uploadItem:myAccessToken uid:uid title:title category:category recMes:recommendMes uploadImage:ulImage success:^(id Json){
        
        success(Json);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getItems:(NSString *)category success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendFeatchItemsRequest:myAccessToken uid:myUserId category:category success:^(id Json){
        
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
    NSString *userId = [self getMyUserId];
    user.accessToken = accessToken;
    user.myUserId = userId;
    comment.user = user;
    comment.info = commentInfo;
    return comment;
}
-(TJItemMessage *)getMyOwnMessageItem:(NSString *)replyMessage
{
    TJItemMessage *itemMessage = [[TJItemMessage alloc]init];
    TJUser *user = [self getMyUserInfo];
    NSString *userId = [self getMyUserId];
    itemMessage.uid = userId;
    itemMessage.profileImageUrl = user.profile_image_url;
    itemMessage.userName = user.name;
    itemMessage.userGender = user.gender;
    itemMessage.message = replyMessage;
    itemMessage.messageContentType = @"replyComment";
    return itemMessage;
}

-(TJUser *)getMyWholeUserInfo
{
    TJUser *user = [self getMyUserInfo];
    NSString *userId = [self getMyUserId];
    NSString *userAccessToken = [self getMyUserToken];
    user.myUserId = userId;
    user.accessToken = userAccessToken;
    return user;
}
-(void)getUserItems:(NSString *)userId success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    [[TJNetworkManager sharedNetworkManager]sendFeatchUserItemsRequest:myAccessToken uid:userId success:^(id Json){
        
        NSArray *itemsArray = [TJParser parseItemsJsonData:Json];
        success(itemsArray);
    }failure:^(NSError *error){
        
        failure(error);
    }];
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
-(void)sendLike:(TJItem *)item
{
    TJUser *myUserInfo = [self getMyUserInfo];
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = item.itemId;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = item.title;
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = @"赞";
    basicMessage.messageContentType = @"like";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:item.uid basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender];
}
-(void)sendComment:(TJItem *)item comment:(NSString *)commentInfo
{
    TJUser *myUserInfo = [self getMyUserInfo];
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = item.itemId;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = item.title;
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"comment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:item.uid basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender];
}
-(void)replyComment:(TJUser *)user theItem:(TJItem *)item comment:(NSString *)commentInfo
{
    TJUser *myUserInfo = [self getMyUserInfo];
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = item.itemId;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = item.title;
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"replyComment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:user.myUserId basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender];
}
-(void)replyMessage:(TJItemMessage *)itemMessage theMessage:(TJMessage *)theMessage comment:(NSString *)commentInfo
{
    TJUser *userInfo = [self getMyUserInfo];
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = theMessage.messageId;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = theMessage.imageUrl;
    basicMessage.messageTitle = theMessage.messageTitle;
    basicMessage.messageName = userInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"replyComment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:itemMessage.uid basicMessage:basicMessage userProfileImage:userInfo.profile_image_url userGender:userInfo.gender];
}
- (void) recieveMessage:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:TJ_RECIEVE_MESSAGE_NOTIFICATION]){
        id message = notification.object;
        __block id weakMessage = message;
        [TJParser parseMessage:message parsedMessage:^(TJMessage *mes){
            [[TJDBManager sharedDBManager]insertMessageList:mes.messageId type:mes.messageType url:mes.imageUrl title:mes.messageTitle name:mes.messageName message:mes.message messageContentType:mes.messageContentType];
            [[TJDBManager sharedDBManager]insertMessage:weakMessage messageType:mes.messageType messageId:mes.messageId messageContentType:mes.messageContentType];
            [[NSNotificationCenter defaultCenter]postNotificationName:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
        }];
    }
}

#pragma database
-(NSArray *)featchMessageList
{
    NSArray *messageListArray = [[TJDBManager sharedDBManager]getMessageList];
    return messageListArray;
}
-(void)deleteFromMessageList:(NSString *)mId messageType:(NSString *)mType
{
    [[TJDBManager sharedDBManager]deleteFromMeslist:mType messageId:mId];
}
-(NSArray *)featchItemMessage:(NSString *)mId
{
    NSArray *messageArray = [[TJDBManager sharedDBManager]getMessages:@"itemMessage" messageId:mId];
    NSMutableArray *itemsMessageArray = [[NSMutableArray alloc]init];
    __block NSMutableArray *weakItemsMessageArray = itemsMessageArray;
    for (int i = 0; i < [messageArray count]; i++) {
        NSString *itemMessage = [messageArray objectAtIndex:i];
        NSError *error = nil;
        NSXMLElement *itemMessageXML = [[NSXMLElement alloc] initWithXMLString:itemMessage error:&error];
        [TJParser parseItemMessage:itemMessageXML parsedMessage:^(TJItemMessage *itemMessage){
            [weakItemsMessageArray addObject:itemMessage];
        }];
    }
    return itemsMessageArray;
}
-(int)getTotalInfoMessageNum
{
    return [[TJDBManager sharedDBManager]getInfoMessageNum];
}
-(void)clearInfoMessageNum:(int)messageId
{
    [[TJDBManager sharedDBManager] clearInfoMessageNum:messageId];
}
@end
