//
//  TJItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemCell.h"

@implementation TJItemCell
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
        
        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        likeImageView.image = [UIImage imageNamed:@"like.png"];
        likeImageView.alpha = 0.5;
        [self addSubview:likeImageView];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        [likeNumLabel setFont:[UIFont systemFontOfSize:8]];
        likeNumLabel.textAlignment = NSTextAlignmentCenter;
        likeNumLabel.textColor = [UIColor redColor];
        likeNumLabel.text = @"1000";
        [likeImageView addSubview:likeNumLabel];
        
        commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        commentImageView.image = [UIImage imageNamed:@"comment.png"];
        commentImageView.alpha = 0.5;
        [self addSubview:commentImageView];
        
        commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
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
    
    likeImageView.frame = CGRectMake(240, 360 + textH, 32, 32);
    commentImageView.frame = CGRectMake(240 + 32 + 5, 360 + textH + 2, 28, 28);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
