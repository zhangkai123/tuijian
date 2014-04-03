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
    UITextField *titleTextField;
    UITextView *tuijianTextView;
    UILabel *placeHolderLabel;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    tuijianTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 50 + 10, 310, 160)];
    [tuijianTextView setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    tuijianTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    tuijianTextView.keyboardType = UIKeyboardTypeDefault;
    tuijianTextView.returnKeyType = UIReturnKeyDefault;
    tuijianTextView.textAlignment = NSTextAlignmentLeft;
    tuijianTextView.scrollEnabled = NO;
    tuijianTextView.delegate = self;
    [self.view addSubview:tuijianTextView];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,tuijianTextView.frame.size.width - 10.0, 34.0)];
    [placeHolderLabel setText:@"推荐理由"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]];
    [placeHolderLabel setAlpha:0.6];
    [tuijianTextView addSubview:placeHolderLabel];
    
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
    NSString *title = titleTextField.text;
    NSString *tuijianText = tuijianTextView.text;
    [[TJDataController sharedDataController]saveItem:title recommendMes:tuijianText uploadImage:self.cropedImage success:^(id Json){
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

-(void)adjustRightButtonItem
{
    if ((![titleTextField.text isEqualToString:@""]) && (![tuijianTextView.text isEqualToString:@""])) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
