//
//  TJHeadProtraitCell.m
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJHeadProtraitCell.h"

@implementation TJHeadProtraitCell
@synthesize headProtraitImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *headProtraitLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 50, 30)];
        headProtraitLabel.text = @"头像";
        headProtraitLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:headProtraitLabel];
        
        headProtraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 10, 80, 80)];
        headProtraitImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:headProtraitImageView];
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
