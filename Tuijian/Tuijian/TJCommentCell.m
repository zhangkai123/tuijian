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
@synthesize commentHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
//        userImageView.layer.masksToBounds = YES;
//        userImageView.layer.cornerRadius = 40 / 2.0;
        [self addSubview:self.userImageView];
        
        nameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
        nameLable.textColor = [UIColor blackColor];
        [nameLable setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:nameLable];

        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 250, 0)];
        commentLable.textColor = [UIColor blackColor];
        [commentLable setFont:[UIFont systemFontOfSize:15]];
        commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        commentLable.numberOfLines = 0;
        [self addSubview:commentLable];
    }
    return self;
}
-(void)setCommentHeight:(float)commentH
{
    commentHeight =commentH;
    commentLable.frame = CGRectMake(60, 30, 250, commentH);
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
