//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "MessageCell.h"
#import "TJChatMessage.h"
#import "MessageFrame.h"
#import "UIImage+additions.h"
#import "TJTouchableImageView.h"

@interface MessageCell ()<TJTouchableImageViewDelegate>
{
    UIButton     *_timeBtn;
    TJTouchableImageView *_iconView;
    UIButton    *_contentBtn;
}

@end

@implementation MessageCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[TJTouchableImageView alloc] init];
        _iconView.delegate = self;
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
    }
    return self;
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    TJChatMessage *message = _messageFrame.message;
    [self.delegate goToUserInfoPage:message.type];
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    TJChatMessage *message = _messageFrame.message;
    
    // 1、设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];

    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    __block UIImageView *weakImageView = _iconView;
    __block MessageFrame *weakMessageFrame = _messageFrame;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:message.icon]];
    [_iconView setImageWithURLRequest:urlRequest
                         placeholderImage:nil
                                  success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                      
                                      float radius = MAX(image.size.width, image.size.height);
                                      weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                      weakImageView.frame = weakMessageFrame.iconF;
                                  }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                      
                                  }];

    
    // 3、设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
    
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:normal forState:UIControlStateHighlighted];
//    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

@end
