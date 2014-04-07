//
//  TJRadioButtonView.m
//  Tuijian
//
//  Created by zhang kai on 4/7/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJRadioButtonView.h"

@implementation TJRadioButtonView
@synthesize titleArray;
@synthesize selectedTag;

-(id)initWithTitleArray:(NSArray *)tArray theFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = [NSMutableArray arrayWithArray:tArray];
        for (int i = 0; i < [tArray count]; i++) {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                [button1 setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
                self.selectedTag = [tArray objectAtIndex:0];
            }else{
                [button1 setImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
            }
            [button1 addTarget:self action:@selector(selectTheButton:) forControlEvents:UIControlEventTouchUpInside];
            button1.frame = CGRectMake(60*i, (frame.size.height - 21)/2, 20, 21);
            button1.tag = i + 1000;
            [self addSubview:button1];
            
            NSString *title = [tArray objectAtIndex:i];
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(60*i + 22.0, (frame.size.height - 21)/2, 30, 21)];
            [label1 setText:title];
            [label1 setBackgroundColor:[UIColor clearColor]];
            [label1 setTextColor:[UIColor lightGrayColor]];
            [label1 setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
            [self addSubview:label1];

        }
    }
    return self;
}

-(void)selectTheButton:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [theButton setImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    for (int i = 0; i < [self.titleArray count]; i++) {
        if ((i + 1000) != theButton.tag) {
            UIButton *button = (UIButton *)[self viewWithTag:i + 1000];
            [button setImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        }
    }
    self.selectedTag = [self.titleArray objectAtIndex:theButton.tag - 1000];
}

@end
