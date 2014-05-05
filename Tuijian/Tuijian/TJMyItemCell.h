//
//  TJMyItemCell.h
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJMyItemCell : UITableViewCell
{
    NSString *itemId;
    
    UIView *coverView;
    UIImageView *itemImageView;
    UILabel *recommendInfoLabel;
}
@property(nonatomic,strong) NSString *itemId;

@property(nonatomic,strong) UIImageView *itemImageView;

-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH;
@end
