//
//  TJNameEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJNameEditViewController.h"

@interface TJNameEditViewController ()<UITextFieldDelegate>

@end

@implementation TJNameEditViewController
@synthesize originName;

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
    self.title = @"姓名";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];

    UITextField* nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10 + 64, 300, 50)];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.font = [UIFont systemFontOfSize:15];
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.delegate = self;
    nameTextField.text = self.originName;
    [self.view addSubview:nameTextField];
    [nameTextField becomeFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)save
{
    
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
