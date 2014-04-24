//
//  TJChatView.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatView.h"

@implementation TJChatView
@synthesize delegate;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
//        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height - 40)];
//        [coverButton addTarget:self action:@selector(exitInputMode) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:coverButton];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        containerView.backgroundColor = UIColorFromRGB(0xDDDDDD);
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
        textView.isScrollable = NO;
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        textView.returnKeyType = UIReturnKeyGo; //just as an example
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor whiteColor];
        textView.layer.cornerRadius = 3;
        textView.layer.masksToBounds = YES;

        [self addSubview:containerView];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [containerView addSubview:textView];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(containerView.frame.size.width - 69, 8, 63, 27)];
        [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.layer.cornerRadius = 5;
        sendButton.layer.masksToBounds = YES;
        sendButton.backgroundColor = UIColorFromRGB(0x3399CC);
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [containerView addSubview:sendButton];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
//-(void)exitInputMode
//{
//    [self.delegate exitInputMode];
//}
-(void)showKeyboard:(BOOL)showK
{
    if (showK) {
        [textView becomeFirstResponder];
    }else{
        [textView resignFirstResponder];
    }
}
-(void)sendMessage
{
    NSString * textWithoutWhiteSpace = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([textWithoutWhiteSpace isEqualToString:@""]) {
        return;
    }
    NSString *resultStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[self.delegate sendMessage:resultStr];
    textView.text = nil;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

@end
