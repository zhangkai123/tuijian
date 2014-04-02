//
//  TJMessageCell.h
//  Tuijian
//
//  Created by zhang kai on 3/24/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMessageCell : UITableViewCell
{
    UIImageView *theImageView;
    UIView *notificationView;
    UILabel *titleLabel;
    UILabel *messageLabel;
}

@property(nonatomic,strong) UIImageView *theImageView;
@property(nonatomic,strong) UIView *notificationView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *messageLabel;
@end
