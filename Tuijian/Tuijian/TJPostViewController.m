//
//  TJPostViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/21/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJPostViewController.h"
#import "TJRadioButtonView.h"

@interface TJPostViewController ()<UITextFieldDelegate,UITextViewDelegate,TJRadioButtonViewDelegate>
{
    UITextField *titleTextField;
    UITextView *tuijianTextView;
    UILabel *placeHolderLabel;
    
    UIView *tagView;
    TJRadioButtonView *radioButtonView;
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
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
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
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 64 + 10, 50, 50)];
    imageView.image = self.cropedImage;
    [self.view addSubview:imageView];
    
    titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 64 + 10 + 15, 240, 20)];
    titleTextField.backgroundColor = [UIColor whiteColor];
    titleTextField.placeholder = @"标题";
    titleTextField.delegate = self;
    [titleTextField setFont:[UIFont boldSystemFontOfSize:16]];
    [titleTextField setTextColor:UIColorFromRGB(0x3399CC)];
    [titleTextField becomeFirstResponder];
    [self.view addSubview:titleTextField];
    
    UIView *seperateLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 50 + 9, 310, 1)];
    seperateLineView.backgroundColor = [UIColor grayColor];
    [seperateLineView setAlpha:0.1];
    [self.view addSubview:seperateLineView];
    
    tuijianTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 50 + 10, 310, 130)];
    [tuijianTextView setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    tuijianTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    tuijianTextView.keyboardType = UIKeyboardTypeDefault;
    tuijianTextView.returnKeyType = UIReturnKeyDefault;
    tuijianTextView.textAlignment = NSTextAlignmentLeft;
    tuijianTextView.scrollEnabled = YES;
    tuijianTextView.delegate = self;
    tuijianTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tuijianTextView];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,tuijianTextView.frame.size.width - 10.0, 34.0)];
    [placeHolderLabel setText:@"推荐理由"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    [placeHolderLabel setAlpha:0.6];
    [tuijianTextView addSubview:placeHolderLabel];
    
    tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 294, 320, 40)];
    tagView.backgroundColor = UIColorFromRGB(0xE0E0E0);
    [self.view addSubview:tagView];
    UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 5.0, 50, 30)];
    [tagLabel setText:@"标签:"];
    [tagLabel setBackgroundColor:[UIColor clearColor]];
    [tagLabel setTextColor:[UIColor darkGrayColor]];
    [tagLabel setFont:[UIFont boldSystemFontOfSize:TJ_RECOMMEND_SIZE]];
    [tagView addSubview:tagLabel];
    
    radioButtonView = [[TJRadioButtonView alloc]initWithTitleArray:[NSArray arrayWithObjects:@"美食",@"玩乐", nil] theFrame:CGRectMake(50, 5, 200, 30)];
    radioButtonView.delegate = self;
    radioButtonView.backgroundColor = [UIColor clearColor];
    [tagView addSubview:radioButtonView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldHaveBeenChanged) name:UITextFieldTextDidChangeNotification object:nil];
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
    NSString *title = [titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *tuijianText = [tuijianTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[TJDataController sharedDataController]saveItem:title category:radioButtonView.selectedTag recommendMes:tuijianText uploadImage:self.cropedImage success:^(id Json){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPLOADING_ITEM_SUCCESS object:nil];
    }failure:^(NSError *error){
        [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPLOADING_ITEM_FAIL object:nil];
    }];
}
#pragma text field delegate
-(void)textFieldHaveBeenChanged
{
    [self adjustRightButtonItem];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [tuijianTextView becomeFirstResponder];
    return NO;
}

#pragma text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    placeHolderLabel.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self adjustRightButtonItem];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
    }
}
#pragma TJRadioButtonViewDelegate
-(void)haveSelectedTag
{
    [self adjustRightButtonItem];
}

-(void)adjustRightButtonItem
{
    NSString * titleWithoutWhiteSpace = [titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * tuijianWithoutWhiteSpace = [tuijianTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((![titleWithoutWhiteSpace isEqualToString:@""]) && (![tuijianWithoutWhiteSpace isEqualToString:@""]) && (radioButtonView.selectedTag != nil)) {
        self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0x4876FF);
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
