//
//  TJMineViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJUser.h"

@interface TJMineViewController ()

@end

@implementation TJMineViewController

-(id)init
{
    if (self = [super init]) {
        self.title = @"我的";
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
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 100)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    TJUser *user = [[TJDataController sharedDataController]getMyUserInfo];
    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [profileImageView setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:nil];
    profileImageView.clipsToBounds = YES;
    [backView addSubview:profileImageView];
    profileImageView.layer.cornerRadius = 80 / 2.0;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 40)];
    nameLabel.text = user.name;
    nameLabel.textColor = [UIColor whiteColor];
    [backView addSubview:nameLabel];
    
    UIImageView *genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 60, 20, 20)];
    if ([user.gender isEqualToString:@"男"]) {
        [genderImageView setImage:[UIImage imageNamed:@"male.png"]];
    }else{
        [genderImageView setImage:[UIImage imageNamed:@"female.png"]];
    }
    [backView addSubview:genderImageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
