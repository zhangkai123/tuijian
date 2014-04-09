//
//  TJMessageCell.h
//  Tuijian
//
//  Created by zhang kai on 3/24/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMessageCellDelegate <NSObject>

-(void)goToMessageParent:(NSString *)messageId;

@end

@interface TJMessageCell : UITableViewCell
{
    __unsafe_unretained id<TJMessageCellDelegate> delegate;
    
    UIImageView *theImageView;
    UIView *notificationView;
    UILabel *messageLabel;
}
@property(nonatomic,strong) NSString *messageId;
@property(nonatomic,unsafe_unretained) id<TJMessageCellDelegate> delegate;

@property(nonatomic,strong) UIImageView *theImageView;
@property(nonatomic,strong) UIView *notificationView;
@property(nonatomic,strong) UILabel *messageLabel;

-(void)setMessageTitle:(NSString *)messageTitle;
@end
