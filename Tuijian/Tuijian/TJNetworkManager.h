//
//  ADNetworkManager.h
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJNetworkManager : NSObject

+(id)sharedNetworkManager;
-(void)sendTencentUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendUserTokenToServerForLogin:(NSString *)access_token userInfo:(NSDictionary *)userInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)uploadItem:(NSString *)accessT recMes:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendFeatchItemsRequest:(NSString *)accessT success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendLikeRequest:(NSString *)accessT itemId:(NSString *)itemId success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendComment:(NSString *)accessT itemId:(NSString *)itemId commentInfo:(NSString *)commentInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
@end
