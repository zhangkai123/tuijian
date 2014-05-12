//
//  TJUserInfoViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJChatCell.h"

@interface TJUserInfoViewController : TJBaseViewController
{
    NSString *userImageUrl;
    NSString *userName;
    NSString *userGender;
    NSString *uid;
}
@property(nonatomic,assign) TJChatCellStatus chatCellStatus;
@property(nonatomic,strong) NSString *hiMessageLocalId;
@property(nonatomic,strong) NSString *userImageUrl;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userGender;
@property(nonatomic,strong) NSString *uid;
@end
