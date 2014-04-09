//
//  TJParser.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJParser.h"
#import "TJItem.h"
#import "TJComment.h"

@implementation TJParser

+(BOOL)parseStatusJsonData:(id)json
{
    BOOL haveSucceed = NO;
    NSString *status = [json objectForKey:@"status"];
    if ([status isEqualToString:@"mySuccess"]) {
        haveSucceed = YES;
    }
    return haveSucceed;
}
+(NSArray *)parseItemsJsonData:(id)json
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    NSArray *jsonArray = [json objectForKey:@"items"];
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *itemDic = [jsonArray objectAtIndex:i];
        TJItem *item = [[TJItem alloc]init];
        item.itemId = [itemDic objectForKey:@"id"];
        item.uid = [itemDic objectForKey:@"uid"];
        item.userName = [itemDic objectForKey:@"userName"];
        item.userImg = [itemDic objectForKey:@"userImg"];
        item.userGender = [itemDic objectForKey:@"userGender"];
        item.title = [itemDic objectForKey:@"title"];
        item.imageUrl = [itemDic objectForKey:@"imageUrl"];
        item.recommendReason = [itemDic objectForKey:@"recommendReason"];
        item.commentNum = [itemDic objectForKey:@"commentNum"];
        item.likeNum = [itemDic objectForKey:@"likeNum"];
        
        id uid = [itemDic objectForKey:@"user_id"];
        if (uid != [NSNull null]) {
            item.hasLiked = YES;
        }else{
            item.hasLiked = NO;
        }
        [itemsArray addObject:item];
    }
    return itemsArray;
}
+(void)parseLikeJsonData:(id)json success:(void (^)(BOOL hasLiked))successed failed:(void (^)(NSError *error))failed
{
    NSString *sucess = [json objectForKey:@"status"];
    if ([sucess isEqualToString:@"success"]) {
        NSString *hasLiked = [json objectForKey:@"hasliked"];
        if ([hasLiked isEqualToString:@"YES"]) {
            successed(YES);
        }else{
            successed(NO);
        }
    }else{
        failed(nil);
    }
}
+(void)parseLikesCommentsData:(id)json likesArray:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failed:(void (^)(NSError *error))failed
{
    NSString *sucess = [json objectForKey:@"status"];
    if ([sucess isEqualToString:@"success"]) {
        NSArray *likesArray = [json objectForKey:@"theLikes"];
        NSMutableArray *likesA = [[NSMutableArray alloc]init];
        for (int i = 0; i < [likesArray count]; i++) {
            NSDictionary *userDic = [likesArray objectAtIndex:i];
            TJUser *user = [[TJUser alloc]init];
            user.accessToken = [userDic objectForKey:@"accessToken"];
            user.myUserId = [userDic objectForKey:@"id"];
            user.name = [userDic objectForKey:@"name"];
            user.gender = [userDic objectForKey:@"sex"];
            user.profile_image_url = [userDic objectForKey:@"img"];
            [likesA addObject:user];
        }
        lArray(likesA);
        
        NSArray *commentsArray = [json objectForKey:@"theComments"];
        NSMutableArray *commentsA = [[NSMutableArray alloc]init];
        for (int i = 0; i < [commentsArray count]; i++) {
            NSDictionary *commentDic = [commentsArray objectAtIndex:i];
            TJComment *comment = [[TJComment alloc]init];
            TJUser *user = [[TJUser alloc]init];
            user.accessToken = [commentDic objectForKey:@"accessToken"];
            user.myUserId = [commentDic objectForKey:@"id"];
            user.name = [commentDic objectForKey:@"name"];
            user.gender = [commentDic objectForKey:@"sex"];
            user.profile_image_url = [commentDic objectForKey:@"img"];
            
            comment.user = user;
            comment.info = [commentDic objectForKey:@"info"];
            [commentsA addObject:comment];
        }
        cArray(commentsA);
    }else{
        failed(nil);
    }
}
#pragma messages category list
+(void)parseMessage:(id)data parsedMessage:(void (^)(TJMessage *message))message
{
    TJMessage *theMessage = [[TJMessage alloc]init];
    NSString *messageId = [[data elementForName:@"messageId"] stringValue];
    NSString *type = [[data elementForName:@"messageType"] stringValue];
    NSString *imageUrl = [[data elementForName:@"imageUrl"] stringValue];
    NSString *title = [[data elementForName:@"title"] stringValue];
    NSString *messageName = [[data elementForName:@"messageName"] stringValue];
    NSString *messageContent = [[data elementForName:@"body"] stringValue];
    NSString *messageContentType = [[data elementForName:@"messageContentType"] stringValue];
    
    theMessage.messageId = messageId;
    theMessage.messageType = type;
    theMessage.imageUrl = imageUrl;
    theMessage.messageTitle = title;
    theMessage.messageName = messageName;
    theMessage.message = messageContent;
    theMessage.messageContentType = messageContentType;
    message(theMessage);
}

#pragma specific message type
+(void)parseItemMessage:(id)data parsedMessage:(void (^)(TJItemMessage *message))message
{
    TJItemMessage *theMessage = [[TJItemMessage alloc]init];
    NSString *uid = [[data attributeForName:@"from"] stringValue];
    NSArray *strArray = [uid componentsSeparatedByString:@"@"];
    if ([strArray count] > 0) {
        uid = [strArray objectAtIndex:0];
    }
    
    NSString *userProfileImage = [[data elementForName:@"userProfileImage"] stringValue];
    NSString *userName = [[data elementForName:@"messageName"] stringValue];
    NSString *userGender = [[data elementForName:@"userGender"] stringValue];
    NSString *messageContent = [[data elementForName:@"body"] stringValue];
    NSString *messageContentType = [[data elementForName:@"messageContentType"] stringValue];
    
    theMessage.uid = uid;
    theMessage.profileImageUrl = userProfileImage;
    theMessage.userName = userName;
    theMessage.userGender = userGender;
    theMessage.message = messageContent;
    theMessage.messageContentType = messageContentType;
    message(theMessage);
}

+(NSString *)getMessageFromUserId:(id)data
{
    NSString *uid = [[data attributeForName:@"from"] stringValue];
    NSArray *strArray = [uid componentsSeparatedByString:@"@"];
    if ([strArray count] > 0) {
        uid = [strArray objectAtIndex:0];
    }
    return uid;
}
@end
