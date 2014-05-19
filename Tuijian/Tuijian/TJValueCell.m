//
//  TJValueCell.m
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJValueCell.h"

@implementation TJValueCell
@synthesize likeNumLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
         
        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 12, 16, 16)];
        likeImageView.image = [UIImage imageNamed:@"likeNum.png"];
        [self addSubview:likeImageView];
        
        likeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, 35, 20)];
        [likeNumLabel setFont:[UIFont systemFontOfSize:11]];
        [likeNumLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:likeNumLabel];
        
        charmLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 30, 20)];
        [charmLabel setFont:[UIFont systemFontOfSize:13]];
        [charmLabel setTextColor:[UIColor whiteColor]];
        charmLabel.text = @"魅力";
        [self addSubview:charmLabel];        
    }
    return self;
}
-(void)setTheUserStar:(int)theUserStar
{
    int wholeStarNum = theUserStar/2;
    int halfStar = theUserStar%2;
    
    float charmStarOffest = 10 + 20 * (wholeStarNum + halfStar);
    if (halfStar != 0) {
        charmStarOffest = charmStarOffest - 10;
    }
    float charmLabelOffset = charmStarOffest + 30;
    for (int i = 0; i < wholeStarNum; i++) {
        UIImageView *charmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(likeImageView.frame.origin.x - charmStarOffest + 20*i, 11, 18, 18)];
        charmImageView.image = [UIImage imageNamed:@"Diamond.png"];
        [self addSubview:charmImageView];
    }
    if (halfStar != 0) {
        UIImageView *charmImageView = [[UIImageView alloc]initWithFrame:CGRectMake(likeImageView.frame.origin.x - charmStarOffest + 20*wholeStarNum, 11, 18, 18)];
        charmImageView.image = [UIImage imageNamed:@"halfDiamond.png"];
        [self addSubview:charmImageView];
    }
    charmLabel.frame = CGRectMake(likeImageView.frame.origin.x - charmLabelOffset, 10, 30, 20);
}
-(void)setLikeNumber:(int)likeNum
{
    likeNumLabel.text = [NSString stringWithFormat:@"%d",likeNum];
    CGRect expectedLabelRect = [likeNumLabel.text boundingRectWithSize:CGSizeMake(0, 20)
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    likeNumLabel.frame = CGRectMake(320 - 10 - expectedLabelRect.size.width, 10, expectedLabelRect.size.width, 20);
    
    likeImageView.frame = CGRectMake(likeNumLabel.frame.origin.x - 20, 12, 16, 16);
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
