//
//  TJTouchableImageView.m
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJTouchableImageView.h"

@interface TJTouchableImageView()
{
    UIView *coverView;
}
@end

@implementation TJTouchableImageView
@synthesize delegate;
@synthesize sectionNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addCoverView];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self performSelector:@selector(removeCoverView) withObject:nil afterDelay:0.5];
    [self removeCoverView];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
 //   [self performSelector:@selector(removeCoverView) withObject:nil afterDelay:0.5];
    [self removeCoverView];
    [self.delegate selectUserImageView:self.sectionNum];
}
-(void)addCoverView
{
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    coverView.layer.cornerRadius = self.frame.size.width/2;
    coverView.layer.masksToBounds = YES;
    coverView.backgroundColor = [UIColor whiteColor];
    [coverView setAlpha:0.9];
    [self addSubview:coverView];
}
-(void)removeCoverView
{
    [coverView removeFromSuperview];
    coverView = nil;
}

@end
