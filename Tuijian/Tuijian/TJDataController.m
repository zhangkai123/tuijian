
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
-(void)setUserLoginMask:(BOOL)hasLogin
{
    [[TJDiskCacheManager sharedDiskCacheManager]saveUserLoginMask:hasLogin];
}
-(BOOL)getUserLoginMask
{
    return [[TJDiskCacheManager sharedDiskCacheManager]getUserLoginMask];
}
-(void)saveUserEnterAppDate:(NSDate *)theDate
{
    [[TJDiskCacheManager sharedDiskCacheManager]saveUserEnterAppDate:theDate];
}
-(NSDate *)getUserLastEnterAppDate
{
    return [[TJDiskCacheManager sharedDiskCacheManager]getUserLastEnterAppDate];
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
-(BOOL)checkIfUserInBlackList:(NSString *)userId
{
    NSArray *blackListArray = [[TJDiskCacheManager sharedDiskCacheManager]getBlackList];
    return [blackListArray containsObject:userId];
}
-(void)addUserToLocalBlackList:(NSString *)userId
{
    NSArray *blackListArray = [[TJDiskCacheManager sharedDiskCacheManager]getBlackList];
    NSMutableArray *newBlackListArray = nil;
    if (blackListArray == nil) {
        newBlackListArray = [[NSMutableArray alloc]init];
        [newBlackListArray addObject:userId];
    }else{
        newBlackListArray = [NSMutableArray arrayWithArray:blackListArray];
        [newBlackListArray addObject:userId];
    }
    [[TJDiskCacheManager sharedDiskCacheManager]saveBlackList:newBlackListArray];
}
-(void)removeUserFromLocalBlackList:(NSString *)userId
{
    NSArray *blackListArray = [[TJDiskCacheManager sharedDiskCacheManager]getBlackList];
    NSMutableArray *newBlackListArray = [NSMutableArray arrayWithArray:blackListArray];
    if ([newBlackListArray containsObject:userId]) {
         [newBlackListArray removeObject:userId];
    }
    [[TJDiskCacheManager sharedDiskCacheManager]saveBlackList:newBlackListArray];
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
            [[TJDiskCacheManager sharedDiskCacheManager]saveUserLoginMask:YES];
            myUserToken(myAccessToken);
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
-(void)getItems:(NSString *)category itemId:(NSString *)theItemId success:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure
{
    NSString *myAccessToken = [self getMyUserToken];
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendFeatchItemsRequest:myAccessToken uid:myUserId category:category itemId:theItemId success:^(id Json){
        
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
-(void)getItemWholeInfo:(NSString *)itemId theItem:(void (^)(TJItem *theItem))item likesArray:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failed:(void (^)(NSError *error))failed
{
    NSString *myUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]getItemWholeInfo:itemId myUserId:myUserId success:^(id Json){
        [TJParser parseItemWholeInfoData:Json theItem:^(TJItem *theItem){
            item(theItem);
        }likesArray:^(NSArray *likesArray){
            lArray(likesArray);
        }comments:^(NSArray *commentsArray){
            cArray(commentsArray);
        }failed:^(NSError *error){
            
        }];
    }failure:^(NSError *error){
        failed(error);
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
//    NSString *myAccessToken = [self getMyUserToken];
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]sendFeatchUserItemsRequest:myOwnUserId uid:userId success:^(id Json){
        
        NSArray *itemsArray = [TJParser parseItemsJsonData:Json];
        success(itemsArray);
    }failure:^(NSError *error){
        
        failure(error);
    }];
}
-(void)uploadUserPhoto:(UIImage *)uPhoto progress:(void (^)(float uploadProgess))uploadPro success:(void (^)(NSString *uploadImageUrl))success failure:(void (^)(NSError *error))failure
{
    NSString *uid = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]uploadUserPhoto:uPhoto userId:uid progress:^(float uploadProgress){
        uploadPro(uploadProgress);
    }success:^(id Json){
        if ([[Json objectForKey:@"status"] isEqualToString:@"success"]) {
            NSString *uploadImageUrl = [Json objectForKey:@"uploadImageUrl"];
            success(uploadImageUrl);
        }else{
            failure(nil);
        }
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getUserInformationFromServer:(NSString *)theUserId success:(void (^)(TJUser *theUser))success failure:(void (^)(NSError *error))failure
{
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]getWholeUserInfo:myOwnUserId theUserId:theUserId success:^(id json){
        [TJParser parseUserInfoJsonData:json success:^(TJUser *theUser){
            success(theUser);
        }failed:^(NSError *error){
            failure(error);
        }];
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)updateMoodInformation:(NSString *)moodInfor success:(void (^)(BOOL updated))success failure:(void (^)(NSError *error))failure
{
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]updateMoodInformation:myOwnUserId moodInfo:moodInfor success:^(id json){
        NSString *updated = [json objectForKey:@"status"];
        if ([updated isEqualToString:@"mySuccess"]) {
            success(YES);
        }else{
            failure(nil);
        }
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)removePhotoWithId:(NSString *)photoId success:(void (^)(BOOL updated))success failure:(void (^)(NSError *error))failure
{
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]removePhotoWithId:myOwnUserId photoId:photoId success:^(id json){
        NSString *deleted = [json objectForKey:@"status"];
        if ([deleted isEqualToString:@"mySuccess"]) {
            success(YES);
        }else{
            failure(nil);
        }
    }failure:^(NSError *error){
        failure(nil);
    }];
}
-(void)reportUser:(NSString *)reportedId reportedPhoto:(UIImage *)reportedPhoto reportText:(NSString *)reportText success:(void (^)(BOOL succeed))success failure:(void (^)(NSError *error))failure
{
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]reportUser:reportedPhoto userId:myOwnUserId reportedId:reportedId reportText:reportText success:^(id json){
        
        NSString *reportSuccess = [json objectForKey:@"status"];
        if ([reportSuccess isEqualToString:@"success"]) {
            success(YES);
        }
        else{
            failure(nil);
        }
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getUserStatus:(NSString *)usercpFlag success:(void (^)(BOOL reported))success failure:(void (^)(NSError *error))failure
{
    NSString *myOwnUserId = [self getMyUserId];
    [[TJNetworkManager sharedNetworkManager]getUserStatus:myOwnUserId usercpFlag:usercpFlag success:^(id json){
        NSString *userStatus = [json objectForKey:@"status"];
        if ([userStatus intValue] == 1) {
            success(YES);
        }else{
            success(NO);
        }
    }failure:^(NSError *error){
        
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
-(void)sendHiMessageTo:(NSString *)toUserId messageContent:(NSString *)mContent
{
    TJUser *myUserInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([toUserId isEqualToString:myUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = TJ_HI_MESSAGE_ID;
    basicMessage.messageType = @"hiMessage";
    basicMessage.imageUrl = myUserInfo.profile_image_url;
    basicMessage.messageTitle = @"纸条";
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = mContent;
    basicMessage.messageContentType = @"1";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendHiMessage:toUserId basicMessage:basicMessage userGender:myUserInfo.gender];
}
-(void)sendChatMessageTo:(NSString *)toUserId chatMessage:(NSString *)chatMessage
{
    TJUser *myUserInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([myUserId isEqualToString:toUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = myUserId;
    basicMessage.messageType = @"chatMessage";
    basicMessage.imageUrl = myUserInfo.profile_image_url;
    basicMessage.messageTitle = myUserInfo.name;
//    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = chatMessage;
    basicMessage.messageContentType = @"other";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendChatMessage:toUserId basicMessage:basicMessage userGender:myUserInfo.gender];
}
-(void)sendLike:(TJItem *)item
{
    TJUser *myUserInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([item.uid isEqualToString:myUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = TJ_ITEM_MESSAGE_ID;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = @"赞和评论";
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = @"赞";
    basicMessage.messageContentType = @"like";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:item.uid basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender theItemId:item.itemId];
}
-(void)sendComment:(TJItem *)item comment:(NSString *)commentInfo
{
    TJUser *myUserInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([item.uid isEqualToString:myUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = TJ_ITEM_MESSAGE_ID;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = @"赞和评论";
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"comment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:item.uid basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender theItemId:item.itemId];
}
-(void)replyComment:(TJUser *)user theItem:(TJItem *)item comment:(NSString *)commentInfo
{
    TJUser *myUserInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([user.myUserId isEqualToString:myUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = TJ_ITEM_MESSAGE_ID;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = item.imageUrl;
    basicMessage.messageTitle = @"赞和评论";
    basicMessage.messageName = myUserInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"replyComment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:user.myUserId basicMessage:basicMessage userProfileImage:myUserInfo.profile_image_url userGender:myUserInfo.gender theItemId:item.itemId];
}
-(void)replyMessage:(TJItemMessage *)itemMessage theMessage:(TJMessage *)theMessage comment:(NSString *)commentInfo
{
    TJUser *userInfo = [self getMyUserInfo];
    NSString *myUserId = [self getMyUserId];
    if ([itemMessage.uid isEqualToString:myUserId]) {
        return;
    }
    TJMessage *basicMessage = [[TJMessage alloc]init];
    basicMessage.messageId = TJ_ITEM_MESSAGE_ID;
    basicMessage.messageType = @"itemMessage";
    basicMessage.imageUrl = itemMessage.itemUrl;
    basicMessage.messageTitle = @"赞和评论";
    basicMessage.messageName = userInfo.name;
    basicMessage.message = commentInfo;
    basicMessage.messageContentType = @"replyComment";
    [[TJXMPPServerMananger sharedXMPPServerMananger]sendItemMessage:itemMessage.uid basicMessage:basicMessage userProfileImage:userInfo.profile_image_url userGender:userInfo.gender theItemId:itemMessage.itemId];
}
- (void) recieveMessage:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:TJ_RECIEVE_MESSAGE_NOTIFICATION]){
        id message = notification.object;
        __block id weakMessage = message;
        [TJParser parseMessage:message parsedMessage:^(TJMessage *mes){
            NSString *fromUserId = [TJParser getMessageFromUserId:weakMessage];
            if ([self checkIfUserInBlackList:fromUserId]) {
                return;
            }
            if ([mes.messageContentType isEqualToString:@"like"]) {
                NSString *itemId = [TJParser getMessageItemId:weakMessage];
                if ([self checkIfUserLikedInItemMessages:fromUserId theItemId:itemId]) {
                    return;
                }
            }
            [[TJDBManager sharedDBManager]insertMessageList:mes.messageId type:mes.messageType url:mes.imageUrl title:mes.messageTitle name:mes.messageName message:mes.message messageContentType:mes.messageContentType updateMesNum:YES];
            [[TJDBManager sharedDBManager]insertMessage:weakMessage messageType:mes.messageType messageId:mes.messageId messageContentType:mes.messageContentType];
            if ([mes.messageType isEqualToString:@"chatMessage"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:TJ_CHAT_VIEWCONTROLLER_NOTIFICATION object:nil];
            }else if ([mes.messageType isEqualToString:@"itemMessage"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:TJ_ITEM_MESSAGE_VIEWCONTROLLER_NOTIFICATION object:nil];
            }else if ([mes.messageType isEqualToString:@"hiMessage"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:TJ_HI_MESSAGE_VIEWCONTROLLER_NOTIFICATION object:nil];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
        }];
    }
}

-(BOOL)checkIfUserLikedInItemMessages:(NSString *)userId theItemId:(NSString *)theItemId
{
    NSArray *itemMessagesArray = [self featchItemMessage:TJ_ITEM_MESSAGE_ID];
    for (int i = 0; i < [itemMessagesArray count]; i++) {
        TJItemMessage *itemMessage = [itemMessagesArray objectAtIndex:i];
        if ([itemMessage.uid isEqualToString:userId] && [itemMessage.messageContentType isEqualToString:@"like"] && [itemMessage.itemId isEqualToString:theItemId]) {
            return YES;
        }
    }
    return NO;
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
    NSArray *messageArray = [[TJDBManager sharedDBManager]getMessagesByOrder:@"itemMessage" messageId:mId idOrder:@"DESC" withPage:0];
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
-(NSArray *)featchHiMessage:(int)pageNum
{
    NSArray *messageArray = [[TJDBManager sharedDBManager]getHiMessagesByOrder:@"hiMessage" messageId:TJ_HI_MESSAGE_ID idOrder:@"DESC" withPage:pageNum];
    NSMutableArray *hiMessageArray = [[NSMutableArray alloc]init];
    __block NSMutableArray *weakHiMessageArray = hiMessageArray;
    for (int i = 0; i < [messageArray count]; i++) {
        NSDictionary *hiMessage = [messageArray objectAtIndex:i];
        NSError *error = nil;
        NSXMLElement *hiMessageXML = [[NSXMLElement alloc] initWithXMLString:[hiMessage objectForKey:@"hiMessageXml"] error:&error];
        [TJParser parseHiMessage:hiMessageXML hiMessageLocalId:[hiMessage objectForKey:@"hiMessageLocalId"] contentType:[hiMessage objectForKey:@"hiMessageContentType"] parsedMessage:^(TJHiMessage *hiMessage){
            [weakHiMessageArray addObject:hiMessage];
        }];
    }
    return hiMessageArray;
}
-(void)haveReadHiMessage:(NSString *)hiMessageLocalId
{
    [[TJDBManager sharedDBManager]updateHiMessageById:hiMessageLocalId];
}
-(NSArray *)featchChatMessage:(NSString *)mId byPage:(int)pageNum
{
    NSArray *messageArray = [[TJDBManager sharedDBManager]getMessagesByOrder:@"chatMessage" messageId:mId idOrder:@"DESC" withPage:pageNum];
    NSMutableArray *chatMessageArray = [[NSMutableArray alloc]init];
    __block NSMutableArray *weakChatMessageArray = chatMessageArray;
    for (int i = 0; i < [messageArray count]; i++) {
        NSString *chatMessage = [messageArray objectAtIndex:i];
        NSError *error = nil;
        NSXMLElement *itemMessageXML = [[NSXMLElement alloc] initWithXMLString:chatMessage error:&error];
        [TJParser parseChatMessage:itemMessageXML parsedMessage:^(TJChatMessage *chatMessage){
            [weakChatMessageArray addObject:chatMessage];
        }];
    }
    NSArray *reversedArray = [NSMutableArray arrayWithArray:[[chatMessageArray reverseObjectEnumerator]allObjects]];
    return reversedArray;
}
-(void)insertLocalChatMessage:(NSString *)mId myChatMessage:(TJChatMessage *)myChatMessage messageList:(TJMessage *)mes
{
    NSString *messageType = nil;
    if (myChatMessage.type == MessageTypeMe) {
        messageType = @"me";
    }else{
        messageType = @"other";
    }
    [[TJDBManager sharedDBManager]insertMessageList:mId type:@"chatMessage" url:mes.imageUrl
                                              title:mes.messageTitle name:mes.messageName message:mes.message messageContentType:messageType updateMesNum:NO];
    NSString *userImageUrl = nil;
    if ([messageType isEqualToString:@"me"]) {
        TJUser *myUser = [self getMyUserInfo];
        userImageUrl = myUser.profile_image_url;
    }else{
        userImageUrl = mes.imageUrl;
    }
    NSXMLElement *localMessage = [self constructLocalChatMessage:messageType localMessage:myChatMessage.content userImageUrl:userImageUrl];
    [[TJDBManager sharedDBManager]insertMessage:(id)localMessage messageType:@"chatMessage" messageId:mId messageContentType:messageType];
    [[NSNotificationCenter defaultCenter]postNotificationName:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
}
-(NSXMLElement *)constructLocalChatMessage:(NSString *)mContentType localMessage:(NSString *)lMessage userImageUrl:(NSString *)uImageUrl
{
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *messageContentType = [NSXMLElement elementWithName:@"messageContentType"];
    [messageContentType setStringValue:mContentType];
    [message addChild:messageContentType];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:lMessage];
    [message addChild:body];

    NSXMLElement *imageUrl = [NSXMLElement elementWithName:@"imageUrl"];
    [imageUrl setStringValue:uImageUrl];
    [message addChild:imageUrl];

    return message;
}
-(int)getTotalInfoMessageNum
{
    return [[TJDBManager sharedDBManager]getInfoMessageNum];
}
-(void)clearInfoMessageNum:(int)messageId messageType:(NSString *)mType
{
    [[TJDBManager sharedDBManager] clearInfoMessageNum:messageId messageType:mType];
}
@end
