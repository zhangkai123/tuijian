//
//  TJItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemCell.h"
#import <QuartzCore/QuartzCore.h>

@interface TJItemCell()
{
//    BOOL likeButtonRed;
    UIView *bottomLineView;
}
@end

@implementation TJItemCell
@synthesize itemId;
@synthesize titleLabel;
@synthesize itemImageView ,commentNumLabel ,likeNumLabel;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self addSubview:itemImageView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 325, 300, 30)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        titleLabel.numberOfLines = 1;
        [titleLabel setTextColor:UIColorFromRGB(0x3399CC)];
        [self addSubview:titleLabel];
        
        recommendInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TJ_RECOMMEND_WIDTH, 0)];
        [recommendInfoLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
        recommendInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        recommendInfoLabel.numberOfLines = 0;
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
                
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(0, 0, 70, 28)];
        likeButton.layer.cornerRadius = 3;
        [likeButton setClipsToBounds:YES];
        likeButton.backgroundColor = UIColorFromRGB(0xD4D4D4);
        [likeButton setImage:[UIImage imageNamed:@"favhighlight@2x.png"] forState:UIControlStateNormal];
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [likeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [likeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
        [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeButton];
        
        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        likeImageView.image = [UIImage imageNamed:@"like.png"];
//        likeImageView.alpha = 0.5;
        [self addSubview:likeImageView];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        [likeNumLabel setFont:[UIFont systemFontOfSize:8]];
        likeNumLabel.textAlignment = NSTextAlignmentCenter;
        likeNumLabel.textColor = [UIColor redColor];
        [likeImageView addSubview:likeNumLabel];
        
        commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        commentImageView.image = [UIImage imageNamed:@"comment.png"];
//        commentImageView.alpha = 0.5;
        [self addSubview:commentImageView];
        
        commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, 28, 28)];
        [commentNumLabel setFont:[UIFont systemFontOfSize:8]];
        commentNumLabel.textAlignment = NSTextAlignmentCenter;
        commentNumLabel.textColor = [UIColor redColor];
        [commentImageView addSubview:commentNumLabel];
        
        bottomLineView = [[UIView alloc]initWithFrame:CGRectZero];
        bottomLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:bottomLineView];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(10, 325 + 25, TJ_RECOMMEND_WIDTH, textH);
    
    likeButton.frame = CGRectMake(10, 330 + 30 + textH + 1, 70, 28);
    likeImageView.frame = CGRectMake(240, 330 + 30 + textH, 32, 32);
    commentImageView.frame = CGRectMake(240 + 32 + 5, 330 + 30 + textH + 2, 28, 28);
    
    bottomLineView.frame = CGRectMake(0, textH + 325 + 40 + 29, 320, 1);
}
-(void)like
{
//    int likeNum;
//    if (likeButtonRed) {
//        likeNum = [likeNumLabel.text intValue] - 1;
//    }else{
//        likeNum = [likeNumLabel.text intValue] + 1;
//    }
//    likeNumLabel.text = [NSString stringWithFormat:@"%d",likeNum];
    [self.delegate likeItem:self.itemId liked:^(BOOL hasLiked){
        [self setLikeButtonColor:hasLiked];
    }];
}
-(void)setLikeButtonColor:(BOOL)hasLiked
{
//    likeButtonRed = hasLiked;
    if (hasLiked) {
        [likeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"favSelectedHighlight@2x.png"] forState:UIControlStateNormal];
    }else{
        [likeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"favhighlight@2x.png"] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
