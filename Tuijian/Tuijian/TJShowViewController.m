//
//  TJShowViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJShowViewController.h"

@interface TJShowViewController ()

@end

@implementation TJShowViewController


-(id)init
{
    if (self = [super init]) {
        self.title = @"推荐";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"camera_18_2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto:)];
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
}
-(void)takePhoto:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
