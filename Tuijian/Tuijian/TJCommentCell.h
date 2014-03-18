//
//  TJCommentCell.h
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJCommentCell : UITableViewCell
{
    UIImageView *userImageView;
    UILabel *nameLable;
    UILabel *commentLable;
}
@property(nonatomic,strong) UIImageView *userImageView;
@property(nonatomic,strong) UILabel *nameLable;
@property(nonatomic,strong) UILabel *commentLable;
@property(nonatomic,assign) float commentHeight;
@end
