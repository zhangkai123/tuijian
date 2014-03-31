//
//  TJItemMessageCell.m
//  Tuijian
//
//  Created by zhang kai on 3/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemMessageCell.h"

@implementation TJItemMessageCell
@synthesize userImageView ,nameLable ,commentLable;
@synthesize commentHeight;
@synthesize delegate ,rowNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        self.userImageView.delegate = self;
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
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    [self.delegate selectCommentUserImage:self.rowNum];
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
