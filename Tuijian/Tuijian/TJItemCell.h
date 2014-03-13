//
//  TJItemCell.h
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJItemCell : UITableViewCell
{
    UIImageView *userImageView;
    UILabel *nameLabel;
    UIImageView *genderImageView;
    
    UIImageView *itemImageView;
    NSString *recommendInfo;
    NSString *commentNum;
    NSString *likeNum;
}

@property(nonatomic,strong) UIImageView *userImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIImageView *genderImageView;

@property(nonatomic,strong) UIImageView *itemImageView;
@property(nonatomic,strong) NSString *recommendInfo;
@property(nonatomic,strong) NSString *commentNum;
@property(nonatomic,strong) NSString *likeNum;

@end
