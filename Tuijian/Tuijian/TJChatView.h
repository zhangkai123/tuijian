//
//  TJChatView.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@protocol TJChatViewDelegate <NSObject>

-(void)exitInputMode;
-(void)sendMessage:(NSString *)theMessage;

@end

@interface TJChatView : UIView<HPGrowingTextViewDelegate>
{
    __unsafe_unretained id<TJChatViewDelegate> delegate;
    
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property(nonatomic,unsafe_unretained) id<TJChatViewDelegate> delegate;

-(void)showKeyboard:(BOOL)showK;

@end
