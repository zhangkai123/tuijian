//
//  TJItemCell.h
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TJTouchableImageView.h"
#import "TJSelectableLabel.h"

@protocol TJItemCellDelegate <NSObject>

-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL;
-(void)goToUserInformationPgae:(int)rowNum;

@end

@interface TJItemCell : UITableViewCell<TJTouchableImageViewDelegate,TJSelectableLabelDelegate>
{
    NSString *itemId;
    int theRowNum;
    
    UIView *coverView;
    
    TJTouchableImageView *userImageView;
    TJSelectableLabel *nameLabel;
    UIImageView *genderImageView;
    
    UIImageView *itemImageView;
    UILabel *recommendInfoLabel;
    
    UIButton *shareButton;
    UIButton *likeButton;
    
    CALayer *heartLayer;
    
    UIImageView *commentImageView;
    UILabel *commentNumLabel;
    
    UIImageView *likeImageView;
    UILabel *likeNumLabel;
    
    __unsafe_unretained id<TJItemCellDelegate> delegate;
}
@property(nonatomic,strong) NSString *itemId;
@property(nonatomic,assign) int theRowNum;

@property(nonatomic,strong) TJTouchableImageView *userImageView;
@property(nonatomic,strong) TJSelectableLabel *nameLabel;
@property(nonatomic,strong) UIImageView *genderImageView;

@property(nonatomic,strong) UIImageView *itemImageView;
@property(nonatomic,strong) UILabel *commentNumLabel;
@property(nonatomic,strong) UILabel *likeNumLabel;

@property(nonatomic,unsafe_unretained) id<TJItemCellDelegate> delegate;

-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH;
-(void)setLikeButtonColor:(BOOL)hasLiked;
-(void)animateHeart;
@end
