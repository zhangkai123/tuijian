//
//  TJMyItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMyItemCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TJMyItemCell
@synthesize itemId ,titleLabel ,itemImageView;

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
        
        recommendInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
        [recommendInfoLabel setFont:[UIFont systemFontOfSize:15]];
        recommendInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        recommendInfoLabel.numberOfLines = 0;
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(10, 325 + 25, 300, textH);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
