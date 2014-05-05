//
//  TJChatViewController.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJMessage.h"

@interface TJChatViewController : TJBaseViewController
{
    NSString *chatToUserId;
    NSString *chatToUserImageUrl;
}
@property(nonatomic,strong) NSString *chatToUserId;
@property(nonatomic,strong) NSString *chatToUserImageUrl;

-(id)initWithTitle:(NSString *)navTitle;
@end
