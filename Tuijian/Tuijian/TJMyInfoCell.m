//
//  TJMyInfoCell.m
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMyInfoCell.h"

@implementation TJMyInfoCell
@synthesize profileImageView ,nameLabel ,genderImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        
        profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        profileImageView.clipsToBounds = YES;
        [self addSubview:profileImageView];
        profileImageView.layer.cornerRadius = 80 / 2.0;
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 200, 40)];
        nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nameLabel];
        
        genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 60, 20, 20)];
        [self addSubview:genderImageView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 1)];
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
