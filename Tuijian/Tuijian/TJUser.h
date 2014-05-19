//
//  ADUser.h
//  AiDaBan
//
//  Created by zhang kai on 8/28/13.
//  Copyright (c) 2013 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJUser : NSObject

@property(nonatomic,retain) NSString *myUserId;
@property(nonatomic,retain) NSString *accessToken;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *gender;
@property(nonatomic,retain) NSString *profile_image_url;

@property(nonatomic,strong) NSString *mood;
@property(nonatomic,strong) NSMutableArray *photosArray;
@property(nonatomic,strong) NSMutableArray *photosIdArray;
@property(nonatomic,assign) int heartNum;
@property(nonatomic,assign) int charmValue;
@property(nonatomic,assign) int userStar;

-(id)initWithTencentJsonData:(id)json;
-(id)initWithSinaJsonData:(id)json;
-(id)initWithDictionaryData:(NSDictionary *)dic;
@end
