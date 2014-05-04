//
//  TJWatermarkLabel.m
//  Tuijian
//
//  Created by zhang kai on 5/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJWatermarkLabel.h"

@implementation TJWatermarkLabel
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate selectLabel];
}

@end
