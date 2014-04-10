//
//  TJSelectableLabel.m
//  Tuijian
//
//  Created by zhang kai on 4/10/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJSelectableLabel.h"

@interface TJSelectableLabel()
{
    UIColor *_initTextColor;
    UIView *coverView;
}
@end

@implementation TJSelectableLabel
@synthesize delegate;

- (id)initWithFrameAndTextColor:(CGRect)frame andTextColor:(UIColor *)initTextColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.textColor = initTextColor;
        _initTextColor = initTextColor;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addCoverView];
    self.textColor = [UIColor lightGrayColor];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(removeCoverView) withObject:nil afterDelay:0.5];
    self.textColor = _initTextColor;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(removeCoverView) withObject:nil afterDelay:0.5];
    self.textColor = _initTextColor;
    [self.delegate selectLabel];
}

-(void)addCoverView
{
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    coverView.backgroundColor = [UIColor grayColor];
    [coverView setAlpha:0.3];
    [self addSubview:coverView];
}
-(void)removeCoverView
{
    [coverView removeFromSuperview];
    coverView = nil;
}
@end
