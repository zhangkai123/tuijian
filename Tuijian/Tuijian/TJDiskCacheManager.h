//
//  ADDiskManager.h
//  AiDaBan
//
//  Created by zhang kai on 9/7/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "TJUser.h"

@interface TJDiskCacheManager : NSObject


+(id)sharedDiskCacheManager;

-(BOOL)getUserLoginMask;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(NSDictionary *)getTencentLoginInfo;
-(void)saveUserInfo:(TJUser *)user;
-(void)saveUserLoginMask:(BOOL)logined;
-(NSDictionary *)getUserInfoFromDisk;
//-(void)saveCurrentEditCourse:(NSDictionary *)dic;
//-(NSDictionary *)getCurrentEditCourse;
@end
