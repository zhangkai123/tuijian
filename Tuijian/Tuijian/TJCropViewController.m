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
    [cancelButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(cancelCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *useButton = [[UIButton alloc]initWithFrame:CGRectMake(320 - 60 - 5 , 25, 60, 30)];
    [useButton setTitle:@"完成" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.backgroundColor = [UIColor clearColor];
    [useButton addTarget:self action:@selector(useCrop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
    
    imageScrollView = [[ImageScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    [imageScrollView displayImage:self.thePhoto];
    [self.view addSubview:imageScrollView];
    if (IS_IPHONE_5) {
        imageScrollView.center = CGPointMake(self.view.center.x, 280);
    }else{
        imageScrollView.center = CGPointMake(self.view.center.x, 236);
    }
}
-(void)cancelCrop
{    
    __block id<TJCropViewControllerDelegate> weakDelegate = self.delegate;
    [self dismissViewControllerAnimated:NO completion:^(void){
        [weakDelegate cancelCropToActivateCamera];
    }];
}
-(void)useCrop
{
    CGRect cropRect = [self getCropRect:self.thePhoto];
    UIImage *cropedImage = [UIImage imageWithImage:self.thePhoto cropInRect:cropRect];
    if (cropedImage.size.width > 360) {
        cropedImage = [UIImage resizeImageToSize:cropedImage toSize:CGSizeMake(360, 360)];
    }
    __block id<TJCropViewControllerDelegate> weakDelegate = self.delegate;
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
    CGRect cropRect;
    if (theImage.size.height >= theImage.size.width) {
        CGPoint offset = imageScrollView.contentOffset;
        float imageScale = theImage.size.width/320;
        float actualXOffset = offset.x/imageScrollView.zoomScale * imageScale;
        float actualYOffset = offset.y/imageScrollView.zoomScale * imageScale;
        float imageWidth = theImage.size.width/imageScrollView.zoomScale;
        cropRect = CGRectMake(actualXOffset, actualYOffset, imageWidth, imageWidth);
    }else{
        CGPoint offset = imageScrollView.contentOffset;
        float imageScale = theImage.size.height/320;
        float actualXOffset = offset.x/imageScrollView.zoomScale * imageScale;
        float actualYOffset = offset.y/imageScrollView.zoomScale * imageScale;
        float imageHeight = theImage.size.height/imageScrollView.zoomScale;
        cropRect = CGRectMake(actualXOffset, actualYOffset, imageHeight, imageHeight);
    }
    return cropRect;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
