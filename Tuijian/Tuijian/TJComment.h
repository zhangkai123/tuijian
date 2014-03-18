//
//  TJComment.h
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJUser.h"

@interface TJComment : NSObject

@property(nonatomic,strong) TJUser *user;
@property(nonatomic,strong) NSString *info;
@end
