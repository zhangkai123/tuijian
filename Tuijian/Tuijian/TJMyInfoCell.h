//
//  TJMyInfoCell.h
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMyInfoCell : UITableViewCell
{
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UIImageView *genderImageView;
}
@property(nonatomic,strong) UIImageView *profileImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *genderImageView;
@end
