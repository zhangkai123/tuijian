//
//  ADDiskManager.h
//  AiDaBan
//
//  Created by zhang kai on 9/7/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "TJUser.h"

@interface TJDiskCacheManager : NSObject


+(id)sharedDiskCacheManager;

-(void)saveUserEnterAppDate:(NSDate *)theDate;
-(NSDate *)getUserLastEnterAppDate;
-(BOOL)getUserLoginMask;
-(void)saveTencentLoginInfo:(TencentOAuth *)tencentOAuth;
-(NSDictionary *)getTencentLoginInfo;
-(void)saveSinaLoginInfo:(WBBaseResponse *)response;
-(NSDictionary *)getSinaLoginInfo;
-(void)saveUserInfo:(TJUser *)user;
-(void)saveUserLoginMask:(BOOL)logined;
-(NSDictionary *)getUserInfoFromDisk;
//-(void)saveCurrentEditCourse:(NSDictionary *)dic;
//-(NSDictionary *)getCurrentEditCourse;
-(void)saveBlackList:(NSMutableArray *)blackListArray;
-(NSArray *)getBlackList;
@end
