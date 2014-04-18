//
//  TJMyPhotoCell.m
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMyPhotoCell.h"

@implementation TJMyPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        for (int i = 0; i < 8; i++) {
            int colomeNum = i/4;
            int rowNum = i%4;
            UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(5 + rowNum*(74 + 5), 5 + colomeNum*(74 + 5), 74, 74)];
            photoView.backgroundColor = [UIColor blueColor];
            [self addSubview:photoView];
        }
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
