//
//  TJLikeUserCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJLikeUserCell.h"

@implementation TJLikeUserCell
@synthesize delegate ,theRowNum;
@synthesize userImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundColor = UIColorFromRGB(0x242424);
        
        self.userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        userImageView.delegate = self;
        userImageView.clipsToBounds = YES;
        userImageView.layer.cornerRadius = 40 / 2.0;
        [self addSubview:self.userImageView];        
    }
    return self;
}
-(void)selectUserImageView:(int)sectionNum
{
    [self.delegate clickImageViewAtRow:self.theRowNum];
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
