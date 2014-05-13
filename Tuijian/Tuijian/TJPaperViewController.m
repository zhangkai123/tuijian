//
//  TJPaperViewController.m
//  Tuijian
//
//  Created by zhang kai on 5/13/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJPaperViewController.h"

@interface TJPaperViewController ()<UITextFieldDelegate>
{
    UITextField* paperTextField;
}
@end

@implementation TJPaperViewController
@synthesize userId;

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
    self.title = @"小纸条";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
    
    paperTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + 64, 300, 50)];
    paperTextField.borderStyle = UITextBorderStyleRoundedRect;
    paperTextField.font = [UIFont systemFontOfSize:15];
    paperTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    paperTextField.keyboardType = UIKeyboardTypeDefault;
    paperTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    paperTextField.delegate = self;
    paperTextField.placeholder = @"说点什么吧";
    [self.view addSubview:paperTextField];
    [paperTextField becomeFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 30) ? NO : YES;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendMessage
{
    [[TJDataController sharedDataController]sendHiMessageTo:self.userId messageContent:paperTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
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
