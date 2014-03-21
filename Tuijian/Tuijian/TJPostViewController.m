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
    [titleTextField becomeFirstResponder];
    [self.view addSubview:titleTextField];
    
    tuijianTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 64 + 10 + 50 + 10, 300, 160)];
//    tuijianTextView.backgroundColor = [UIColor blueColor];
//    [tuijianTextView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    tuijianTextView.font = [UIFont systemFontOfSize:15];
    tuijianTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    tuijianTextView.keyboardType = UIKeyboardTypeDefault;
    tuijianTextView.returnKeyType = UIReturnKeyDone;
    tuijianTextView.textAlignment = NSTextAlignmentLeft;
    tuijianTextView.scrollEnabled = NO;
    tuijianTextView.delegate = self;
    [self.view addSubview:tuijianTextView];
    
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0,tuijianTextView.frame.size.width - 10.0, 34.0)];
    [placeHolderLabel setText:@"推荐理由"];
    placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    [tuijianTextView addSubview:placeHolderLabel];
}
-(void)cancelPost
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)postItem
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
    placeHolderLabel.hidden = YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
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
