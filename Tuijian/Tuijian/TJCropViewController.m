//
//  TJCropViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TJCropViewController.h"
#import "ImageScrollView.h"

@interface TJCropViewController ()
{
    UIImageView *imageView;
}
@end

@implementation TJCropViewController
@synthesize thePhoto;

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
    
    ImageScrollView *imageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 350)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.layer.cornerRadius = 5;
    imageScrollView.layer.masksToBounds = YES;
    [imageScrollView displayImage:self.thePhoto];
    [self.view addSubview:imageScrollView];
    imageScrollView.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
