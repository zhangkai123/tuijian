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
//        coverButton.backgroundColor = [UIColor blackColor];
//        [coverButton setAlpha:0.1];
        [coverButton addTarget:self action:@selector(exitInputMode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverButton];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, 320, 40)];
        
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
        
        [self addSubview:containerView];
        
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // view hierachy
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
        
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [doneBtn setTitle:@"发送" forState:UIControlStateNormal];
        
        [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
        [containerView addSubview:doneBtn];
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
