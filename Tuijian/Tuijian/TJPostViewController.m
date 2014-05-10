//
//  TJPostViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/21/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJPostViewController.h"

@interface TJPostViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextView *tuijianTextView;
    UILabel *placeHolderLabel;
    
    UIView *tagView;
}
@end

@implementation TJPostViewController
@synthesize cropedImage;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(id)init
{
    if (self = [super init]) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPost)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(postItem)];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    tagView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 40, 320, 40);
}
- (void)keyboardFrameChange:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    tagView.frame = CGRectMake(0, self.view.frame.size.height - keyboardSize.height - 40, 320, 40);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChange:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 64 + 10, 100, 100)];
    imageView.image = self.cropedImage;
    [self.view addSubview:imageView];
    
    tuijianTextView = [[UITextView alloc]initWithFrame:CGRectMake(120, 64 + 10, 190, 100)];
    [tuijianTextView setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    tuijianTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    tuijianTextView.keyboardType = UIKeyboardTypeDefault;
    tuijianTextView.returnKeyType = UIReturnKeyDefault;
    tuijianTextView.textAlignment = NSTextAlignmentLeft;
    tuijianTextView.scrollEnabled = YES;
    tuijianTextView.delegate = self;
    tuijianTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tuijianTextView];
    [tuijianTextView becomeFirstResponder];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 0.0,tuijianTextView.frame.size.width - 10.0, 34.0)];
    [placeHolderLabel setText:@"介绍美食(可选)"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    [placeHolderLabel setAlpha:0.6];
    [tuijianTextView addSubview:placeHolderLabel];
}
-(void)cancelPost
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)postItem
{
    [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPLOADING_ITEM_NOTIFICATION object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *tuijianText = [tuijianTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tuijianText isEqualToString:@""]) {
        tuijianText = @"分享美食";
    }
    [[TJDataController sharedDataController]saveItem:@"" category:@"美食" recommendMes:tuijianText uploadImage:self.cropedImage success:^(id Json){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPLOADING_ITEM_SUCCESS object:nil];
    }failure:^(NSError *error){
        [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPLOADING_ITEM_FAIL object:nil];
    }];
}

#pragma text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
//    placeHolderLabel.hidden = YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
    }else{
        placeHolderLabel.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
