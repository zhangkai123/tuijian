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
{
    int alumNum;
}
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
    for (int i = 0; i < alumNum; i++) {
        UIView *subView = [self viewWithTag:1000 + i];
        [subView removeFromSuperview];
    }
    UIView *subLineView = [self viewWithTag:2000];
    if (subLineView != nil) {
        [subLineView removeFromSuperview];
    }
    
    photoUrlArray = pUrlArray;
    
    int photoNum = [photoUrlArray count];
    alumNum = 0;
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
        photoView.delegate = nil;
        [self addSubview:photoView];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, lineHeight, 320, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.tag = 2000;
    [self addSubview:lineView];

    for (int i = 0; i < [photoUrlArray count]; i++) {
        TJTouchablePhotoView *photoView = (TJTouchablePhotoView *)[self viewWithTag:1000 + i];
        photoView.alpha = 1.0;
        NSString *photoUrl = [photoUrlArray objectAtIndex:i];
        NSString *urlWithoutExtention = [photoUrl stringByDeletingPathExtension];
        NSString *thumbImageUrl = [NSString stringWithFormat:@"%@_thumb.png",urlWithoutExtention];
        [photoView setImageWithURL:[NSURL URLWithString:thumbImageUrl] placeholderImage:nil];
        photoView.delegate = self;
    }
}
#pragma TJTouchableImageViewDelegate
-(void)selectPhotoViewWithTag:(int)photoTag
{
    [self.delegate selectPhotoAtIndex:photoTag - 1000];
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
