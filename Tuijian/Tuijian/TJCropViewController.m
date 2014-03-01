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
#import "TJEditViewController.h"

@interface TJCropViewController ()
{
    ImageScrollView *imageScrollView;
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
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(5 , 25, 60, 30)];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *useButton = [[UIButton alloc]initWithFrame:CGRectMake(320 - 60 - 5 , 25, 60, 30)];
    [useButton setTitle:@"使用" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.backgroundColor = [UIColor clearColor];
    [useButton addTarget:self action:@selector(useCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
    
    imageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(0, 0, 300, 350)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.layer.cornerRadius = 5;
    imageScrollView.layer.masksToBounds = YES;
    [imageScrollView displayImage:self.thePhoto];
    [self.view addSubview:imageScrollView];
    imageScrollView.center = self.view.center;
}
-(void)cancelCrop
{
    [self dismissMyViewController:self];
}
-(void)useCrop
{
    UIImage *cropedImage = [self getImageFromScrollView:imageScrollView];
    TJEditViewController *editViewController = [[TJEditViewController alloc]init];
    editViewController.cropedImage = cropedImage;
    [self displayContentController:editViewController];
}
-(UIImage *)getImageFromScrollView:(UIScrollView *)theScrollView
{
    UIGraphicsBeginImageContext(theScrollView.frame.size);
    CGPoint offset=theScrollView.contentOffset;
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y);
    [theScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
