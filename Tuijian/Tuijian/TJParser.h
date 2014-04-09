//
//  TJParser.h
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJMessage.h"
#import "TJItemMessage.h"

@interface TJParser : NSObject

+(BOOL)parseStatusJsonData:(id)json;
+(NSArray *)parseItemsJsonData:(id)json;
+(void)parseLikeJsonData:(id)json success:(void (^)(BOOL hasLiked))success failed:(void (^)(NSError *error))failed;
+(void)parseLikesCommentsData:(id)json likesArray:(void (^)(NSArray *likesArray))lArray comments:(void (^)(NSArray *commentsArray))cArray failed:(void (^)(NSError *error))failed;

+(void)parseMessage:(id)data parsedMessage:(void (^)(TJMessage *message))message;
+(void)parseItemMessage:(id)data parsedMessage:(void (^)(TJItemMessage *message))message;

+(NSString *)getMessageFromUserId:(id)data;
@end
