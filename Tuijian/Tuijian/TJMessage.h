//
//  TJMessage.h
//  Tuijian
//
//  Created by zhang kai on 3/20/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJMessage : NSObject

@property(nonatomic,strong) NSString *messageId;
@property(nonatomic,strong) NSString *messageType;

@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,strong) NSString *messageTitle;
@property(nonatomic,strong) NSString *messageName;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,assign) int messageNum;
@end
