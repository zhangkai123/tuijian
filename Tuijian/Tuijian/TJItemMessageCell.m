//
//  TJItemMessageCell.m
//  Tuijian
//
//  Created by zhang kai on 3/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemMessageCell.h"

@implementation TJItemMessageCell
@synthesize userImageView ,commentLable ,itemImageView;
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
        
        nameLable = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(60, 10, 100, 20) andTextColor:UIColorFromRGB(0x336699)];
        nameLable.delegate = self;
        [nameLable setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:nameLable];
        
        commentLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, TJ_ITEM_MESSAGE_WIDTH, 0)];
        commentLable.textColor = [UIColor blackColor];
        [commentLable setFont:[UIFont systemFontOfSize:TJ_ITEM_MESSAGE_SIZE]];
        commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        commentLable.numberOfLines = 0;
        [self addSubview:commentLable];
        
        self.itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 40, 5, 40, 40)];
        [self addSubview:self.itemImageView];
    }
    return self;
}
-(void)setUserName:(NSString *)theUserName
{
    nameLable.text = theUserName;
    CGRect expectedLabelRect = [theUserName boundingRectWithSize:CGSizeMake(0, 20)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    nameLable.frame = CGRectMake(60, 10, expectedLabelRect.size.width, 20);
}
-(void)setCommentHeight:(float)commentH
{
    commentHeight =commentH;
    commentLable.frame = CGRectMake(60, 35, TJ_ITEM_MESSAGE_WIDTH, commentH);
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
