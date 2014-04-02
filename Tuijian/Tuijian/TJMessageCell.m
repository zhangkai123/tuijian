//
//  TJMessageCell.m
//  Tuijian
//
//  Created by zhang kai on 3/24/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMessageCell.h"

@implementation TJMessageCell
@synthesize theImageView ,notificationView ,titleLabel ,messageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        theImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:theImageView];
        
        notificationView = [[UIView alloc]initWithFrame:CGRectMake(48, 5, 12, 12)];
        notificationView.clipsToBounds = YES;
        notificationView.layer.cornerRadius = 6;
        notificationView.backgroundColor = [UIColor redColor];
        [theImageView addSubview:notificationView];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 230, 30)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        titleLabel.numberOfLines = 1;
        [titleLabel setTextColor:UIColorFromRGB(0x3399CC)];
        [self addSubview:titleLabel];
        
        messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 230, 30)];
        [messageLabel setFont:[UIFont systemFontOfSize:15]];
        messageLabel.numberOfLines = 1;
        [messageLabel setTextColor:[UIColor blackColor]];
        [self addSubview:messageLabel];
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
