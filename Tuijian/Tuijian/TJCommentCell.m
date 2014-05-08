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
    UIView *topLineView;
    UIView *leftLineView;
    UIView *rightLineView;
    UIView *bottomLineView;
    
    UIView *selectedCoverView;
}
@end

@implementation TJCommentCell
@synthesize commentImageView;
@synthesize userImageView ,commentLable;
@synthesize commentHeight;
@synthesize delegate ,rowNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xF2F2F2);
        
        self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        [self addSubview:commentImageView];
        
        self.userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(40, 5, 40, 40)];
        self.userImageView.delegate = self;
        [self addSubview:self.userImageView];
        
        nameLable = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(90, 10, 100, 20) andTextColor:UIColorFromRGB(0x336699)];
        nameLable.delegate = self;
        [nameLable setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:nameLable];

        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, TJ_COMMENT_LABEL_WIDTH, 0)];
        commentLable.textColor = [UIColor blackColor];
        [commentLable setFont:[UIFont systemFontOfSize:TJ_COMMENT_SIZE]];
        commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        commentLable.numberOfLines = 0;
        [self addSubview:commentLable];
        
        topLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 1)];
        topLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:topLineView];
        leftLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 1, 50)];
        leftLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:leftLineView];
        rightLineView = [[UIView alloc]initWithFrame:CGRectMake(309, 0, 1, 50)];
        rightLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:rightLineView];
        bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49, 300, 1)];
        bottomLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:bottomLineView];
        bottomLineView.hidden = YES;
        
        selectedCoverView = [[UIView alloc]initWithFrame:CGRectZero];
        selectedCoverView.backgroundColor = [UIColor lightGrayColor];
        [selectedCoverView setAlpha:0.3];
        [self addSubview:selectedCoverView];
        selectedCoverView.hidden = YES;
    }
    return self;
}
-(void)setUserName:(NSString *)theName
{
    nameLable.text = theName;
    CGRect expectedLabelRect = [theName boundingRectWithSize:CGSizeMake(0, 20)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    nameLable.frame = CGRectMake(90, 10, expectedLabelRect.size.width, 20);

}
-(void)setCommentHeight:(float)commentH
{
    commentHeight =commentH;
    commentLable.frame = CGRectMake(90, 35, TJ_COMMENT_LABEL_WIDTH, commentH);
}
-(void)setLineWidthAndHeight:(float)topLineWidth sideLineHeight:(float)sideLineHeight
{
    if (topLineWidth == 300) {
       topLineView.frame = CGRectMake(10, 0, topLineWidth, 1);
    }else{
        topLineView.frame = CGRectMake(45, 0, topLineWidth, 1);
    }
    leftLineView.frame = CGRectMake(10, 0, 1, sideLineHeight);
    rightLineView.frame = CGRectMake(309, 0, 1, sideLineHeight);
    bottomLineView.frame = CGRectMake(10, sideLineHeight, 300, 1);
    selectedCoverView.frame = CGRectMake(40, 0, 270, sideLineHeight);
}
-(void)setBottomLineViewHidden:(BOOL)hidden
{
    bottomLineView.hidden = hidden;
}
-(void)showSelectedAnimation
{
    selectedCoverView.hidden = NO;
    [self performSelector:@selector(hideSelectedCoverView) withObject:nil afterDelay:0.2];
}
-(void)hideSelectedCoverView
{
    selectedCoverView.hidden = YES;
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
