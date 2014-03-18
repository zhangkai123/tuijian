//
//  TJCommentCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentCell.h"

@implementation TJCommentCell
@synthesize userImageView ,nameLable ,commentLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        userImageView.clipsToBounds = YES;
        userImageView.layer.cornerRadius = 40 / 2.0;
        [self addSubview:self.userImageView];
        
        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
        nameLable.textColor = [UIColor blueColor];
        [nameLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:nameLable];

        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 250, 20)];
        commentLable.textColor = [UIColor blackColor];
        [commentLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:commentLable];
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