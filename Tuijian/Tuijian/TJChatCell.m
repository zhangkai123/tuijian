//
//  TJChatCell.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatCell.h"

@implementation TJChatCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIButton *messageButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 280, 45)];
        [messageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [messageButton setTitle:@"发消息" forState:UIControlStateNormal];
        messageButton.layer.cornerRadius = 5;
        messageButton.layer.masksToBounds = YES;
        messageButton.backgroundColor = UIColorFromRGB(0x3399CC);
        [self addSubview:messageButton];
    }
    return self;
}
-(void)sendMessage
{
    [self.delegate sendMessageTo];
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
