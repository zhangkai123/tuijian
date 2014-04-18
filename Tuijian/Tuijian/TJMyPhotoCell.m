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
        lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:lineView];
    }
    return self;
}
-(void)setPhotoUrlArray:(NSMutableArray *)pUrlArray
{
    photoUrlArray = pUrlArray;
    for (int i = 0; i < [photoUrlArray count]; i++) {
        UIImageView *photoView = (UIImageView *)[self viewWithTag:1000 + i];
        photoView.alpha = 1.0;
        NSString *photoUrl = [photoUrlArray objectAtIndex:i];
        [photoView setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:nil];
    }
    if ([photoUrlArray count] < 8) {
        TJTouchablePhotoView *addPhotoView = (TJTouchablePhotoView *)[self viewWithTag:1000 + [photoUrlArray count]];
        addPhotoView.image = [UIImage imageNamed:@"addPhoto.png"];
        [addPhotoView setAlpha:0.2];
        addPhotoView.delegate = self;
    }
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
