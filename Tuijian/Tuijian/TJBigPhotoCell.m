//
//  TJBigPhotoCell.m
//  Tuijian
//
//  Created by zhang kai on 5/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBigPhotoCell.h"

@implementation TJBigPhotoCell
@synthesize photoImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        float screenHeight = [[UIScreen mainScreen] bounds].size.height;
        photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (screenHeight - 320)/2, 320, 320)];
        photoImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:photoImageView];
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
