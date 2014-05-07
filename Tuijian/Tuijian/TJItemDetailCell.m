//
//  TJItemDetailCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemDetailCell.h"

@implementation TJItemDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        likeImageView.hidden = YES;
        likeNumLabel.hidden = YES;
        commentImageView.hidden = YES;
        commentNumLabel.hidden =YES;
    }
    return self;
}
-(void)animateHeart
{
    likeButton.userInteractionEnabled = YES;
}
@end
