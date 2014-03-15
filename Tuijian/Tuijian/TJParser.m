//
//  TJParser.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJParser.h"
#import "TJItem.h"

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
        
    }
}
@end
