//
//  TJMyPhotoCell.m
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMyPhotoCell.h"
#import "TJTouchablePhotoView.h"

@interface TJMyPhotoCell()<TJTouchablePhotoViewDelegate>

@end

@implementation TJMyPhotoCell
@synthesize delegate;
@synthesize photoUrlArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0x242424);
        for (int i = 0; i < 8; i++) {
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
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 164, 320, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x121212);
        [self addSubview:lineView];
    }
    return self;
}
-(void)setPhotoUrlArray:(NSMutableArray *)pUrlArray
{
    photoUrlArray = pUrlArray;
    for (int i = 0; i < [photoUrlArray count]; i++) {
        TJTouchablePhotoView *photoView = (TJTouchablePhotoView *)[self viewWithTag:1000 + i];
        photoView.delegate = nil;
        photoView.alpha = 1.0;
        NSString *photoUrl = [photoUrlArray objectAtIndex:i];
        if ([photoUrl isEqualToString:@"uploading"]) {
            continue;
        }
        NSString *urlWithoutExtention = [photoUrl stringByDeletingPathExtension];
        NSString *thumbImageUrl = [NSString stringWithFormat:@"%@_thumb.png",urlWithoutExtention];
        [photoView setImageWithURL:[NSURL URLWithString:thumbImageUrl] placeholderImage:nil];
    }
    if ([photoUrlArray count] < 8) {
        TJTouchablePhotoView *addPhotoView = (TJTouchablePhotoView *)[self viewWithTag:1000 + [photoUrlArray count]];
        addPhotoView.image = [UIImage imageNamed:@"addPhoto.png"];
        [addPhotoView setAlpha:0.2];
        addPhotoView.delegate = self;
    }
}
-(void)setImageAtIndex:(int)whichImageView placeHolderImage:(UIImage *)placeHolderImage
{
    TJTouchablePhotoView *photoView = (TJTouchablePhotoView *)[self viewWithTag:1000 + whichImageView];
    photoView.image = placeHolderImage;
}
#pragma TJTouchableImageViewDelegate
-(void)selectPhotoView
{
    [self.delegate showPhotoActionSheet];
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
