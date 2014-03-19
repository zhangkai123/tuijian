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

-(id)initWithJsonData:(id)json;
-(id)initWithDictionaryData:(NSDictionary *)dic;
@end
