//
//  TJHiMessage.h
//  Tuijian
//
//  Created by zhang kai on 5/12/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJHiMessage : NSObject

@property(nonatomic,strong) NSString *theId;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *profileImageUrl;
@property(nonatomic,strong) NSString *gender;
@property(nonatomic,strong) NSString *messageContent;
@property(nonatomic,strong) NSString *messageContentType;
@end
