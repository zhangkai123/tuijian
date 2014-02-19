//
//  TJShowViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJShowViewController.h"
#import "TJCamViewController.h"

@interface TJShowViewController ()<UIImagePickerControllerDelegate>

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
//    @try
//    {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        picker.cameraViewTransform = CGAffineTransformMakeScale(0.5, 0.5);
//        picker.delegate = (id)self;
//        
//        [self presentViewController:picker animated:YES completion:^(void){
//            
//        }];
//    }
//    @catch (NSException *exception)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }
    TJCamViewController *camViewController = [[TJCamViewController alloc]init];
    [self presentViewController:camViewController animated:YES completion:^(void){
    }];
}
//-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
////    self.imageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
