//
//  TJChatCell.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJChatCellDelegate <NSObject>

-(void)sendMessageTo;

@end

@interface TJChatCell : UITableViewCell
{
    __unsafe_unretained id<TJChatCellDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<TJChatCellDelegate> delegate;
@end
