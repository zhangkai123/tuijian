//
//  TJUserSignCell.m
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJUserSignCell.h"

@implementation TJUserSignCell
@synthesize signLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        
        UIImageView *signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 24, 24)];
        signImageView.image = [UIImage imageNamed:@"Pencil.png"];
        [self addSubview:signImageView];

        signLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 265, 30)];
        signLabel.backgroundColor = [UIColor clearColor];
        [signLabel setTextColor:UIColorFromRGB(0xADD8E6)];
        [signLabel setFont:[UIFont systemFontOfSize:15]];
        signLabel.textAlignment = NSTextAlignmentLeft;
        signLabel.alpha = 0.5;
        [self addSubview:signLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x121212);
        [self addSubview:lineView];
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
