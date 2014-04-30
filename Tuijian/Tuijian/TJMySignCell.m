//
//  TJMoodCell.m
//  Tuijian
//
//  Created by zhang kai on 4/25/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMySignCell.h"

@implementation TJMySignCell
@synthesize delegate ,signLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        
        UIImageView *signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 24, 24)];
        signImageView.image = [UIImage imageNamed:@"Pencil.png"];
        [self addSubview:signImageView];
        
        UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 70, 30)];
        desLabel.backgroundColor = [UIColor clearColor];
        [desLabel setTextColor:[UIColor whiteColor]];
        [desLabel setFont:[UIFont systemFontOfSize:16]];
        desLabel.text = @"个性签名";
        [self addSubview:desLabel];
        
        signLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 130, 30)];
        signLabel.backgroundColor = [UIColor clearColor];
        [signLabel setTextColor:UIColorFromRGB(0xADD8E6)];
        [signLabel setFont:[UIFont systemFontOfSize:15]];
        signLabel.textAlignment = NSTextAlignmentRight;
        signLabel.alpha = 0.5;
        [self addSubview:signLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x121212);
        [self addSubview:lineView];
        
        UIButton *clickButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        [clickButton addTarget:self action:@selector(clickSignCell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickButton];
    }
    return self;
}
-(void)clickSignCell
{
    [self.delegate haveClickedSignCell];
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
