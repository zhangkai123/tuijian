//
//  TJChatCell.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJChatCellDelegate <NSObject>

@optional
-(void)sendHiTo;
-(void)acceptChat;

@end

@interface TJChatCell : UITableViewCell
{
    TJChatCellStatus chatCellStatus;
    __unsafe_unretained id<TJChatCellDelegate> delegate;
    
    UIButton *messageButton;
}
@property(nonatomic,assign) TJChatCellStatus chatCellStatus;
@property(nonatomic,unsafe_unretained) id<TJChatCellDelegate> delegate;
@end
