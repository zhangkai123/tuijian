//
//  TJCommentCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentCell.h"

@interface TJCommentCell()
{
    UIView *bottomLine;
}
@end

@implementation TJCommentCell
@synthesize userImageView ,commentLable;
@synthesize commentHeight;
@synthesize delegate ,rowNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xF2F2F2);
                
        self.userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 17, 17)];
        self.userImageView.delegate = self;
        [self addSubview:self.userImageView];
        
        nameLable = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(35, 5, 100, 17) andTextColor:UIColorFromRGB(0x336699)];
        nameLable.delegate = self;
        [nameLable setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:nameLable];

        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(35, 25, TJ_COMMENT_LABEL_WIDTH, 0)];
        commentLable.textColor = [UIColor darkGrayColor];
        [commentLable setFont:[UIFont systemFontOfSize:TJ_COMMENT_SIZE]];
        commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        commentLable.numberOfLines = 0;
        [self addSubview:commentLable];
        
        bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        bottomLine.backgroundColor = UIColorFromRGB(0xE0E0E0);
        [self addSubview:bottomLine];
    }
    return self;
}
-(void)setUserName:(NSString *)theName
{
    nameLable.text = theName;
    CGRect expectedLabelRect = [theName boundingRectWithSize:CGSizeMake(0, 17)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    nameLable.frame = CGRectMake(35, 5, expectedLabelRect.size.width, 17);

}
-(void)setCommentHeight:(float)commentH
{
    commentHeight =commentH;
    commentLable.frame = CGRectMake(35, 25, TJ_COMMENT_LABEL_WIDTH, commentH);
    
    bottomLine.frame = CGRectMake(0, 25 + commentH + 5, 320, 1);
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    [self.delegate selectCommentUserImage:self.rowNum];
}
#pragma TJSelectableLabelDelegate
-(void)selectLabel:(int)rowNum
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
