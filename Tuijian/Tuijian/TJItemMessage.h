//
//  TJItemMessage.h
//  Tuijian
//
//  Created by zhang kai on 3/26/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJItemMessage : NSObject


@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *profileImageUrl;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userGender;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *messageContentType;
@end
