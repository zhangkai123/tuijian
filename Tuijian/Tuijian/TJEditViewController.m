//
//  TJEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/23/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJEditViewController.h"

@interface TJEditViewController ()<UITextViewDelegate>
{
    UITextView *tuijianTextView;
    UILabel *placeHolderLabel;
}
@end

@implementation TJEditViewController
@synthesize cropedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [tuijianTextView becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *backToCropButton = [[UIButton alloc]initWithFrame:CGRectMake(5 , 25, 60, 30)];
    [backToCropButton setTitle:@"剪切" forState:UIControlStateNormal];
    [backToCropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backToCropButton.backgroundColor = [UIColor clearColor];
    [backToCropButton addTarget:self action:@selector(backToCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToCropButton];
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(320 - 60 - 5 , 25, 60, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor clearColor];
    [sendButton addTarget:self action:@selector(sendToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 350)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.userInteractionEnabled = YES;
    imageView.layer.cornerRadius = 2;
    imageView.layer.masksToBounds = YES;
    imageView.image = self.cropedImage;
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 50);

    tuijianTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 160)];
    tuijianTextView.backgroundColor = [UIColor whiteColor];
    [tuijianTextView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    tuijianTextView.font = [UIFont systemFontOfSize:15];
    tuijianTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    tuijianTextView.keyboardType = UIKeyboardTypeDefault;
    tuijianTextView.returnKeyType = UIReturnKeyDone;
    tuijianTextView.textAlignment = NSTextAlignmentLeft;
    tuijianTextView.scrollEnabled = NO;
    tuijianTextView.delegate = self;
    [imageView addSubview:tuijianTextView];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0.0,tuijianTextView.frame.size.width - 10.0, 34.0)];
    [placeHolderLabel setText:@"推荐理由 :"];
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [tuijianTextView addSubview:placeHolderLabel];
}
-(void)backToCrop
{
    [self dismissMyViewController:self];
}
-(void)sendToServer
{
    NSString *tuijianText = tuijianTextView.text;
    [[TJDataController sharedDataController]saveItem:tuijianText uploadImage:self.cropedImage success:^(id Json){
        [self dismissViewControllerAnimated:YES completion:nil];
    }failure:^(NSError *error){
        
    }];
}
#pragma text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
//    textView.backgroundColor = [UIColor greenColor];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if(tuijianTextView.text.length == 0){
        placeHolderLabel.hidden = NO;
    }else{
        placeHolderLabel.hidden = YES;
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
