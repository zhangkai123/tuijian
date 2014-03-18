//
//  TJLikeUserCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJLikeUserCell.h"

@implementation TJLikeUserCell
@synthesize userImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xD4D4D4);
        
        self.userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        userImageView.clipsToBounds = YES;
        userImageView.layer.cornerRadius = 40 / 2.0;
        [self addSubview:self.userImageView];
        
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 40, 30)];
        likeImageView.image = [UIImage imageNamed:@"favSelectedHighlight@2x.png"];
        [self addSubview:likeImageView];

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
