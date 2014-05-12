//
//  TJHiMessageCell.m
//  Tuijian
//
//  Created by zhang kai on 5/12/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJHiMessageCell.h"

@implementation TJHiMessageCell
@synthesize delegate;
@synthesize userImageView ,rowNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.userImageView.delegate = self;
        [self addSubview:self.userImageView];

        nameLable = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(60, 10, 100, 40) andTextColor:UIColorFromRGB(0x336699)];
        nameLable.delegate = self;
        [nameLable setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:nameLable];
        
        acceptButton = [[UIButton alloc]initWithFrame:CGRectMake(230, 15, 80, 30)];
        [acceptButton addTarget:self action:@selector(acceptChat) forControlEvents:UIControlEventTouchUpInside];
        [acceptButton setTitle:@"同意聊天" forState:UIControlStateNormal];
        [acceptButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        acceptButton.layer.cornerRadius = 5;
        acceptButton.layer.masksToBounds = YES;
        acceptButton.backgroundColor = UIColorFromRGB(0x3399CC);
        [self addSubview:acceptButton];
    }
    return self;
}
-(void)acceptChat
{
    [self.delegate acceptChat:self.rowNum];
}
-(void)setUserName:(NSString *)theUserName
{
    nameLable.text = theUserName;
    CGRect expectedLabelRect = [theUserName boundingRectWithSize:CGSizeMake(0, 40)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    nameLable.frame = CGRectMake(60, 10, expectedLabelRect.size.width, 40);
}
-(void)setButtonType:(NSString *)contentType
{
    if ([contentType intValue] == 1) {
        acceptButton.backgroundColor = UIColorFromRGB(0x3399CC);
        [acceptButton setTitle:@"同意聊天" forState:UIControlStateNormal];
        acceptButton.enabled = YES;
    }else{
        acceptButton.backgroundColor = [UIColor lightGrayColor];
        [acceptButton setTitle:@"已接受" forState:UIControlStateNormal];
        acceptButton.enabled = NO;
    }
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
//    [self.delegate selectCommentUserImage:self.rowNum];
}
#pragma TJSelectableLabelDelegate
-(void)selectLabel:(int)rowNum
{
//    [self.delegate selectCommentUserImage:self.rowNum];
}

@end
