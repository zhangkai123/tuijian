//
//  TJUserPhotoCell.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJUserPhotoCell.h"
#import "TJTouchablePhotoView.h"

@interface TJUserPhotoCell()<TJTouchablePhotoViewDelegate>

@end

@implementation TJUserPhotoCell
@synthesize delegate;
@synthesize photoUrlArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
    }
    return self;
}
-(void)setPhotoUrlArray:(NSMutableArray *)pUrlArray
{
    photoUrlArray = pUrlArray;
    
    int photoNum = [photoUrlArray count];
    int alumNum = 0;
    float lineHeight = 0;
    if (photoNum <= 4) {
        alumNum = 4;
        lineHeight = 86;
    }else{
        alumNum = 8;
        lineHeight = 164;
    }
    for (int i = 0; i < alumNum; i++) {
        int colomeNum = i/4;
        int rowNum = i%4;
        TJTouchablePhotoView *photoView = [[TJTouchablePhotoView alloc]initWithFrame:CGRectMake(8 + rowNum*(70 + 8), 8 + colomeNum*(70 + 8), 70, 70)];
        photoView.layer.cornerRadius = 5;
        photoView.layer.masksToBounds = YES;
        photoView.backgroundColor = [UIColor darkGrayColor];
        photoView.tag = 1000 + i;
        photoView.alpha = 0.5;
        [self addSubview:photoView];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight, 320, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];

    for (int i = 0; i < [photoUrlArray count]; i++) {
        UIImageView *photoView = (UIImageView *)[self viewWithTag:1000 + i];
        photoView.alpha = 1.0;
        NSString *photoUrl = [photoUrlArray objectAtIndex:i];
        [photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil];
    }
}
#pragma TJTouchableImageViewDelegate
-(void)selectPhotoView
{
//    [self.delegate selectPhotoAtIndex:0];
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
