//
//  TJChatCell.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatCell.h"

@implementation TJChatCell
@synthesize delegate ,chatCellStatus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        messageButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 280, 45)];
//        [messageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//        [messageButton setTitle:@"打招呼" forState:UIControlStateNormal];
        messageButton.layer.cornerRadius = 5;
        messageButton.layer.masksToBounds = YES;
//        messageButton.backgroundColor = UIColorFromRGB(0x3399CC);
        [self addSubview:messageButton];
    }
    return self;
}
-(void)setChatCellStatus:(TJChatCellStatus)theStatus
{
    chatCellStatus = theStatus;
    
    if (chatCellStatus == TJChatCellStatusSayHi) {
        [messageButton setTitle:@"传纸条" forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(sendHi) forControlEvents:UIControlEventTouchUpInside];
        messageButton.backgroundColor = UIColorFromRGB(0x3399CC);
        messageButton.enabled = YES;
    }else if(chatCellStatus == TJChatCellStatusAccept){
        [messageButton setTitle:@"接受" forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(acceptChat) forControlEvents:UIControlEventTouchUpInside];
        messageButton.backgroundColor = UIColorFromRGB(0x3399CC);
        messageButton.enabled = YES;
    }else if(chatCellStatus == TJChatCellStatusHaveAccepted){
        [messageButton setTitle:@"已接受" forState:UIControlStateNormal];
        messageButton.backgroundColor = [UIColor lightGrayColor];
        messageButton.enabled = NO;
    }
}
-(void)acceptChat
{
    [self.delegate acceptChat];
}
-(void)sendHi
{
    [self.delegate sendHiTo];
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
