//
//  TJCropViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCropViewController.h"

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
    float width = 300;
    float height = self.thePhoto.size.height*300/self.thePhoto.size.width;
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = self.thePhoto;
    [self.view addSubview:imageView];
    imageView.center = self.view.center;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
