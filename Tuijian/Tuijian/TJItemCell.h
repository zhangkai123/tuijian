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
    UIImageView *itemImageView;
    UILabel *recommendInfoLabel;
    
    UIImageView *commentImageView;
    UILabel *commentNumLabel;
    
    UIImageView *likeImageView;
    UILabel *likeNumLabel;
}
@property(nonatomic,strong) UIImageView *itemImageView;
@property(nonatomic,strong) UILabel *commentNumLabel;
@property(nonatomic,strong) UILabel *likeNumLabel;

-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH;
@end
