//
//  ADDiskManager.h
//  AiDaBan
//
//  Created by zhang kai on 9/7/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface TJDiskCacheManager : NSObject


+(id)sharedDiskCacheManager;

-(BOOL)getUserLoginMask;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(NSDictionary *)getTencentLoginInfo;
//-(void)saveUserInfo:(ADUser *)user;
//-(NSDictionary *)getUserInfoFromDisk;
//-(void)saveUserLoginMask:(BOOL)logined;
//-(void)saveCurrentEditCourse:(NSDictionary *)dic;
//-(NSDictionary *)getCurrentEditCourse;
@end
