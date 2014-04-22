//
//  TJChatViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatViewController.h"
#import "TJAppDelegate.h"

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToInfoPage)];
}
-(void)goBackToInfoPage
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate changeToInfoTab];
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
