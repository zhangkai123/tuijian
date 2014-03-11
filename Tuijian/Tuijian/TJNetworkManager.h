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
//-(void)sendSinaUserInfoRequest:(NSDictionary *)sinaUserInfo success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)sendUserTokenToServerForLogin:(NSString *)access_token success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
@end
