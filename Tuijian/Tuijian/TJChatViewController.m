//
//  TJChatViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatViewController.h"

@interface TJChatViewController ()

@end

@implementation TJChatViewController

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
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [[backButton titleLabel]setFont:[UIFont systemFontOfSize:18]];
    [backButton setTitle:@"消息" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackToInfoPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}
-(void)goBackToInfoPage
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:NO];
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
