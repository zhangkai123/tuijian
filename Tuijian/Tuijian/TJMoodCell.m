//
//  TJMoodCell.m
//  Tuijian
//
//  Created by zhang kai on 4/25/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMoodCell.h"

@implementation TJMoodCell
@synthesize moodLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        moodLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
        moodLabel.backgroundColor = [UIColor clearColor];
        [moodLabel setTextColor:UIColorFromRGB(0xADD8E6)];
        [moodLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:moodLabel];
        
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
