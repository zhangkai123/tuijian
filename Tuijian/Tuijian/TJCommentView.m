//
//  TJCommentView.m
//  Tuijian
//
//  Created by zhang kai on 4/3/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentView.h"

@implementation TJCommentView
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
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        
        self.backgroundColor = [UIColor clearColor];
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height - 40)];
        [coverButton addTarget:self action:@selector(exitInputMode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverButton];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, 320, 40)];
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
        [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
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
-(void)showCommentPlaceHolder
{
    textView.placeholder = @"发表评论";
}
-(void)showReplyCommentPlaceHolder:(NSString *)userName
{
    textView.placeholder = [NSString stringWithFormat:@"回复%@",userName];
}
-(void)exitInputMode
{
    [self.delegate exitInputMode];
}
-(void)showKeyboard:(BOOL)showK
{
    if (showK) {
        [textView becomeFirstResponder];
    }else{
        [textView resignFirstResponder];
    }
}
-(void)sendComment
{
    NSString * textWithoutWhiteSpace = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([textWithoutWhiteSpace isEqualToString:@""]) {
        return;
    }
    NSString *resultStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[self.delegate sendComment:resultStr];
    textView.text = nil;
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
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
