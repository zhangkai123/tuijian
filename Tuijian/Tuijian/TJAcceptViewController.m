//
//  TJAcceptViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJAcceptViewController.h"

@interface TJAcceptViewController ()

@end

@implementation TJAcceptViewController

-(id)init
{
    if (self = [super init]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
        self.title = @"用户协议";
    }
    return self;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    float scrrenHeight = [[UIScreen mainScreen]bounds].size.height;
    UITextView *agreementView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, scrrenHeight)];
    [agreementView setFont:[UIFont systemFontOfSize:15]];
    [agreementView setTextColor:[UIColor blackColor]];
    [self.view addSubview:agreementView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"txt"];
    if (filePath) {
        NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (myText) {
            agreementView.text= myText;
        }
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
