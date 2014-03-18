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

+(NSArray *)parseItemsJsonData:(id)json
{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    NSArray *jsonArray = json;
    for (int i = 0; i < [jsonArray count]; i++) {
        NSDictionary *itemDic = [jsonArray objectAtIndex:i];
        TJItem *item = [[TJItem alloc]init];
        item.itemId = [itemDic objectForKey:@"id"];
        item.accessToken = [itemDic objectForKey:@"accessToken"];
        item.userName = [itemDic objectForKey:@"userName"];
        item.userImg = [itemDic objectForKey:@"userImg"];
        item.userGender = [itemDic objectForKey:@"userGender"];
        item.imageUrl = [itemDic objectForKey:@"imageUrl"];
        item.recommendReason = [itemDic objectForKey:@"recommendReason"];
        item.commentNum = [itemDic objectForKey:@"commentNum"];
        item.likeNum = [itemDic objectForKey:@"likeNum"];
        
        id uid = [itemDic objectForKey:@"uid"];
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
        successed(NO);
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
@end
