//
//  TJItem.h
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJItem : NSObject

@property(nonatomic,strong) NSString *itemId;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userImg;
@property(nonatomic,strong) NSString *userGender;
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSString *recommendReason;
@property(nonatomic,strong) NSString *commentNum;
@property(nonatomic,strong) NSString *likeNum;
@property(nonatomic,assign) BOOL hasLiked;
@end
