//
//  TJWirteMoodViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJPersonalSignViewController.h"

@interface TJPersonalSignViewController ()<UITextViewDelegate>
{
    UITextView *personalSignTextView;
}
@end

@implementation TJPersonalSignViewController

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
    self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    
    UINavigationBar *theNavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UINavigationItem *navItem = [UINavigationItem alloc];
    navItem.title = @"个性签名";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    [navItem setLeftBarButtonItem:leftBarButtonItem];
    [theNavigationBar pushNavigationItem:navItem animated:false];
    [self.view addSubview:theNavigationBar];
    
    personalSignTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 64 + 10, 300, 100)];
    [personalSignTextView setFont:[UIFont systemFontOfSize:20]];
    personalSignTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    personalSignTextView.keyboardType = UIKeyboardTypeDefault;
    personalSignTextView.returnKeyType = UIReturnKeyDefault;
    personalSignTextView.textAlignment = NSTextAlignmentLeft;
    personalSignTextView.scrollEnabled = YES;
    personalSignTextView.delegate = self;
    personalSignTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:personalSignTextView];
    [personalSignTextView becomeFirstResponder];
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma text view delegate
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
