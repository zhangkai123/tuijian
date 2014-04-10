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
    self.textColor = [UIColor lightGrayColor];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.textColor = _initTextColor;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.textColor = _initTextColor;
    [self.delegate selectLabel];
}

@end
