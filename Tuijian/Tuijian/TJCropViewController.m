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
#import "UIImage+JTImageCrop.h"

@interface TJCropViewController ()
{
    ImageScrollView *imageScrollView;
}
@end

@implementation TJCropViewController
@synthesize delegate;
@synthesize thePhoto;

-(void)dealloc
{
    
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
    self.view.backgroundColor = [UIColor blackColor];
    
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
    
    imageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    imageScrollView.backgroundColor = [UIColor blackColor];
//    imageScrollView.layer.cornerRadius = 2;
//    imageScrollView.layer.masksToBounds = YES;
    [imageScrollView displayImage:self.thePhoto];
    [self.view addSubview:imageScrollView];
    imageScrollView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
}
-(void)cancelCrop
{
    [self dismissMyViewController:self];
}
-(void)useCrop
{
    __block id<TJCropViewControllerDelegate> weakDelegate = self.delegate;
//    UIImage *cropedImage = [self getImageFromScrollView:imageScrollView];
    
    CGRect cropRect = [self getCropRect:self.thePhoto];
    UIImage *cropedImage = [UIImage imageWithImage:self.thePhoto cropInRect:cropRect];
    [self dismissViewControllerAnimated:NO completion:^(void){
        [weakDelegate getTheCropedImage:cropedImage];
    }];
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
-(CGRect)getCropRect:(UIImage *)theImage
{
    CGPoint offset = imageScrollView.contentOffset;
    float imageScale = theImage.size.width/320;
    float actualXOffset = offset.x/imageScrollView.zoomScale * imageScale;
    float actualYOffset = offset.y/imageScrollView.zoomScale * imageScale;
    float imageWidth = theImage.size.width/imageScrollView.zoomScale;
    CGRect cropRect = CGRectMake(actualXOffset, actualYOffset, imageWidth, imageWidth);
    return cropRect;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
