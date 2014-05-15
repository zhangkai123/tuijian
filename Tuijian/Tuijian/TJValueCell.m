//
//  TJValueCell.m
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJValueCell.h"

@implementation TJValueCell
@synthesize likeNumLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
         
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 16, 16)];
        likeImageView.image = [UIImage imageNamed:@"likeNum.png"];
        [self addSubview:likeImageView];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 35, 20)];
        [likeNumLabel setFont:[UIFont systemFontOfSize:11]];
        [likeNumLabel setTextColor:[UIColor whiteColor]];
        likeNumLabel.text = @"10000";
        [self addSubview:likeNumLabel];
        
        UILabel *charmLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 30, 20)];
        [charmLabel setFont:[UIFont systemFontOfSize:13]];
        [charmLabel setTextColor:[UIColor whiteColor]];
        charmLabel.text = @"魅力";
        [self addSubview:charmLabel];
        
        for (int i = 0; i < 5; i++) {
            UIImageView *charmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210 + 20*i, 11, 18, 18)];
            charmImageView.image = [UIImage imageNamed:@"Diamond.png"];
            [self addSubview:charmImageView];
        }
    }
    return self;
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
