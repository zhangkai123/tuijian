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
@synthesize itemId ,itemImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xF0F0F0);
        
        coverView = [[UIView alloc]initWithFrame:CGRectZero];
        coverView.backgroundColor = [UIColor whiteColor];
        [self addSubview:coverView];

        recommendInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 0)];
        [recommendInfoLabel setFont:[UIFont systemFontOfSize:15]];
        recommendInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        recommendInfoLabel.numberOfLines = 0;
        [recommendInfoLabel setTextColor:[UIColor blackColor]];
        [self addSubview:recommendInfoLabel];
        
        itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
        itemImageView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self addSubview:itemImageView];
    }
    return self;
}
-(void)setRecommendInfoAndHeight:(NSString *)recommendInfo textHeight:(float)textH
{
    recommendInfoLabel.text = recommendInfo;
    recommendInfoLabel.frame = CGRectMake(10, 10, 300, textH);
    
    itemImageView.frame = CGRectMake(10, 20 + textH, 150, 150);
    
    if (textH == 0) {
        coverView.frame = CGRectMake(0, 0, 320, 180);
    }else{
        coverView.frame = CGRectMake(0, 0, 320, textH + 180);
    }
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
