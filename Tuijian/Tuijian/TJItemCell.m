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
        recommendInfoLabel.text = @"太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了太牛逼了";
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(10, 355, 300, textH);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
