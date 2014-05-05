//
//  MessageCell.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrame;

@protocol MessageCellDelegate <NSObject>

-(void)goToUserInfoPage:(MessageType)messageType;

@end
@interface MessageCell : UITableViewCell

@property(nonatomic,unsafe_unretained) id<MessageCellDelegate> delegate;
@property (nonatomic, strong) MessageFrame *messageFrame;

@end
