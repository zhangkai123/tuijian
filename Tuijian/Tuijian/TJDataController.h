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
#import "TJUser.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface TJDataController : NSObject


+(id)sharedDataController;

-(BOOL)getUserLoginMask;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(void)getMyUserToken:(TJUser *)theUser myUserToken:(void (^)(NSString *userToken))myUserToken failure:(void (^)(NSError *error))failure;
-(void)getTencentUserInfo:(void(^)(TJUser *tencentUser))tencentUserInfo failure:(void (^)(NSError *error))failure;
-(TJUser *)getMyUserInfo;
-(void)saveItem:(NSString *)recommendMes uploadImage:(UIImage *)ulImage success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;
-(void)getItems:(void (^)(NSArray *itemsArray))success failure:(void (^)(NSError *error))failure;
//-(void)saveCurrentEditCourse:(NSDictionary *)dic;
//-(NSDictionary *)getCurrentEditCourse;
@end
