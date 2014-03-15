//
//  TJItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TJItemCell
@synthesize itemId;
@synthesize itemImageView ,commentNumLabel ,likeNumLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 350)];
        [self addSubview:itemImageView];
        
        recommendInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
        [recommendInfoLabel setFont:[UIFont systemFontOfSize:15]];
        recommendInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        recommendInfoLabel.numberOfLines = 0;
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
        
//        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [shareButton setFrame:CGRectMake(0, 0, 70, 28)];
//        shareButton.layer.cornerRadius = 3;
//        [shareButton setClipsToBounds:YES];
//        shareButton.backgroundColor = UIColorFromRGB(0xD4D4D4);
//        [shareButton setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
//        [shareButton setTitle:@"分享" forState:UIControlStateNormal];
//        [shareButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//        [shareButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [shareButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
//        [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
////        [shareButton addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:shareButton];
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setFrame:CGRectMake(0, 0, 70, 28)];
        likeButton.layer.cornerRadius = 3;
        [likeButton setClipsToBounds:YES];
        likeButton.backgroundColor = UIColorFromRGB(0xD4D4D4);
        [likeButton setImage:[UIImage imageNamed:@"favhighlight@2x.png"] forState:UIControlStateNormal];
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [likeButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [likeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [likeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
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
        likeNumLabel.text = @"1000";
        [likeImageView addSubview:likeNumLabel];
        
        commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        commentImageView.image = [UIImage imageNamed:@"comment.png"];
//        commentImageView.alpha = 0.5;
        [self addSubview:commentImageView];
        
        commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, 28, 28)];
        [commentNumLabel setFont:[UIFont systemFontOfSize:8]];
        commentNumLabel.textAlignment = NSTextAlignmentCenter;
        commentNumLabel.textColor = [UIColor redColor];
        commentNumLabel.text = @"1000";
        [commentImageView addSubview:commentNumLabel];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(10, 355, 300, textH);
    
//    shareButton.frame = CGRectMake(10, 360 + textH + 2, 70, 28);
    likeButton.frame = CGRectMake(10, 360 + textH + 1, 70, 28);
    likeImageView.frame = CGRectMake(240, 360 + textH, 32, 32);
    commentImageView.frame = CGRectMake(240 + 32 + 5, 360 + textH + 2, 28, 28);
}
-(void)like
{
    [[TJDataController sharedDataController]saveLike:self.itemId success:^(id Json){
        
    }failure:^(NSError *error){
        
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
