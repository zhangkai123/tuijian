//
//  TJItemCell.m
//  Tuijian
//
//  Created by zhang kai on 3/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemCell.h"

@implementation TJItemCell
@synthesize userImageView ,nameLabel ,genderImageView ,itemImageView ,recommendInfo ,commentNum ,likeNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        backView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:backView];
        
        self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.userImageView.clipsToBounds = YES;
        [backView addSubview:self.userImageView];
        self.userImageView.layer.cornerRadius = 80 / 2.0;
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 40)];
        nameLabel.textColor = [UIColor blackColor];
        [backView addSubview:nameLabel];
        
        genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 60, 20, 20)];
        [backView addSubview:genderImageView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
