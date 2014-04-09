//
//  TJCommentView.h
//  Tuijian
//
//  Created by zhang kai on 4/3/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@protocol TJCommentViewDelegate <NSObject>

-(void)exitInputMode;
-(void)sendComment:(NSString *)theComment;

@end

@interface TJCommentView : UIView<HPGrowingTextViewDelegate>
{
    __unsafe_unretained id<TJCommentViewDelegate> delegate;
    
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property(nonatomic,unsafe_unretained) id<TJCommentViewDelegate> delegate;

-(void)showKeyboard:(BOOL)showK;
-(void)showCommentPlaceHolder;
-(void)showReplyCommentPlaceHolder:(NSString *)userName;
@end
