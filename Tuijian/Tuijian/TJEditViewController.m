//
//  TJEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/23/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJEditViewController.h"

@interface TJEditViewController ()

@end

@implementation TJEditViewController
@synthesize cropedImage;

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
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *backToCropButton = [[UIButton alloc]initWithFrame:CGRectMake(5 , 25, 60, 30)];
    [backToCropButton setTitle:@"剪切" forState:UIControlStateNormal];
    [backToCropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backToCropButton.backgroundColor = [UIColor clearColor];
    [backToCropButton addTarget:self action:@selector(backToCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToCropButton];
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(320 - 60 - 5 , 25, 60, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor clearColor];
    [sendButton addTarget:self action:@selector(sendToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 350)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.image = self.cropedImage;
    [self.view addSubview:imageView];
    imageView.center = self.view.center;

}
-(void)backToCrop
{
    [self dismissMyViewController:self];
}
-(void)sendToServer
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
