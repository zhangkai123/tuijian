//
//  TJWaterMarkViewController.m
//  Tuijian
//
//  Created by zhang kai on 5/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJWaterMarkViewController.h"
#import "TJWatermarkLabel.h"
#import "TJFoodNameViewController.h"

@interface TJWaterMarkViewController ()<TJWatermarkLabelDelegate,TJFoodNameViewControllerDelegate>
{
    UIImageView *waterMarkImageView;
    TJWatermarkLabel *watermarkLabel;
}
@end

@implementation TJWaterMarkViewController
@synthesize delegate ,theCropedPhoto;

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
    [cancelButton addTarget:self action:@selector(cancelWaterMark) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *useButton = [[UIButton alloc]initWithFrame:CGRectMake(320 - 60 - 5 , 25, 60, 30)];
    [useButton setTitle:@"完成" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.backgroundColor = [UIColor clearColor];
    [useButton addTarget:self action:@selector(useWaterMark) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useButton];
    
    waterMarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    waterMarkImageView.backgroundColor = [UIColor blackColor];
    waterMarkImageView.userInteractionEnabled = YES;
    waterMarkImageView.image = self.theCropedPhoto;
    [self.view addSubview:waterMarkImageView];
    if (IS_IPHONE_5) {
        waterMarkImageView.center = CGPointMake(self.view.center.x, 255);
    }else{
        waterMarkImageView.center = CGPointMake(self.view.center.x, 235);
    }
    
    float height = [self getWatermarkHeight:@"美食名称"];
    watermarkLabel = [[TJWatermarkLabel alloc]initWithFrame:CGRectMake(275, 10, 35, height)];
    watermarkLabel.delegate = self;
    watermarkLabel.textColor = [UIColor whiteColor];
    watermarkLabel.shadowColor = [UIColor blackColor];
    watermarkLabel.shadowOffset = CGSizeMake(0, 1);
    UIFont *font = [UIFont fontWithName:@"HiraMinProN-W6" size:35];
    [watermarkLabel setFont:font];
    watermarkLabel.numberOfLines = 0;
    watermarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    watermarkLabel.backgroundColor = [UIColor clearColor];
    watermarkLabel.text = @"美食名称";
    [waterMarkImageView addSubview:watermarkLabel];
    [watermarkLabel sizeToFit];
}
#pragma TJWatermarkLabelDelegate
-(void)selectLabel
{
    TJFoodNameViewController *foodNameViewController = [[TJFoodNameViewController alloc]init];
    foodNameViewController.delegate = self;
    UINavigationController *foodNameNavController = [[UINavigationController alloc]initWithRootViewController:foodNameViewController];
    [self presentViewController:foodNameNavController animated:YES completion:nil];
}
#pragma TJFoodNameViewControllerDelegate
-(void)getFoodName:(NSString *)foodName
{
    float height = [self getWatermarkHeight:foodName];
    watermarkLabel.text = foodName;
    watermarkLabel.frame = CGRectMake(275, 10, 35, height);
    [watermarkLabel sizeToFit];
    if (height > 300) {
        watermarkLabel.frame = CGRectMake(275, 10, 35, 300);
    }
    UIImage *theImage = [self drawLabelOnImage:watermarkLabel theImage:self.theCropedPhoto];
    waterMarkImageView.image = theImage;
}

-(void)cancelWaterMark
{
    
}
-(void)useWaterMark
{
    __block id<TJWaterMarkViewControllerDelegate> weakDelegate = self.delegate;
    [self dismissViewControllerAnimated:NO completion:^(void){
        [weakDelegate getTheWatermarkImage:waterMarkImageView.image];
    }];
}
-(float)getWatermarkHeight:(NSString *)foodName
{
    CGRect expectedLabelRect = [foodName boundingRectWithSize:CGSizeMake(35, 0)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HiraMinProN-W6" size:35]} context:nil];
    return expectedLabelRect.size.height;
}
-(UIImage *)drawLabelOnImage:(TJWatermarkLabel *)wLabel theImage:(UIImage *)theImage
{
    UIGraphicsBeginImageContextWithOptions(wLabel.bounds.size, NO, 0);
    [wLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(theImage.size, NO, 0);
    [theImage drawInRect:CGRectMake(0,0,theImage.size.width,theImage.size.height)];
    float scale = theImage.size.width/320;
    [viewImage drawInRect:CGRectMake(wLabel.frame.origin.x * scale, wLabel.frame.origin.y * scale, wLabel.frame.size.width * scale, wLabel.frame.size.height * scale)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
