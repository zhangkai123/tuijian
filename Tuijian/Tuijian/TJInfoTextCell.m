//
//  TJInfoTextCell.m
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJInfoTextCell.h"

@implementation TJInfoTextCell
@synthesize titleLabel ,infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 50, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];

        infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 140, 30)];
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:infoLabel];
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
