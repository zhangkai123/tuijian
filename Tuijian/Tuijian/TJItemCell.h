//
//  TJItemCell.h
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJItemCellDelegate <NSObject>

-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL;

@end

@interface TJItemCell : UITableViewCell
{
    NSString *itemId;
    
    UIView *coverView;
    
    UIImageView *itemImageView;
    UILabel *titleLabel;
    UILabel *recommendInfoLabel;
    
    UIButton *shareButton;
    UIButton *likeButton;
    
    UIImageView *commentImageView;
    UILabel *commentNumLabel;
    
    UIImageView *likeImageView;
    UILabel *likeNumLabel;
    
//    UIView *bottomLineView;
    
    __unsafe_unretained id<TJItemCellDelegate> delegate;
}
@property(nonatomic,strong) NSString *itemId;

@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UIImageView *itemImageView;
@property(nonatomic,strong) UILabel *commentNumLabel;
@property(nonatomic,strong) UILabel *likeNumLabel;

@property(nonatomic,unsafe_unretained) id<TJItemCellDelegate> delegate;

-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH;
-(void)setLikeButtonColor:(BOOL)hasLiked;
@end
