//
//  TJMineViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJUser.h"
#import "TJMyInfoCell.h"
#import "TJMyPhotoCell.h"
#import "TJValueCell.h"
#import "TJMyRecommendCell.h"
#import "TJMyRecommendViewController.h"
#import "TJRecentViewerViewController.h"

@interface TJMineViewController ()<UITableViewDataSource,UITableViewDelegate,TJMyPhotoCellDelegate,UIActionSheetDelegate>
{
    UITableView *theTableView;
    
    NSMutableArray *photoUrlArray;
}
@end

@implementation TJMineViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
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
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];
    
    photoUrlArray = [[NSMutableArray alloc]initWithCapacity:8];
    TJUser *user = [[TJDataController sharedDataController]getMyUserInfo];
    [photoUrlArray addObject:user.profile_image_url];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    if (section == 0) {
        rowNum = 1;
    }else if(section == 1){
        rowNum = 1;
    }else if(section == 2){
        rowNum = 1;
    }else{
        rowNum = 2;
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = 120;
    }else if(indexPath.section == 1){
        rowHeight = 165;
    }else if(indexPath.section == 2){
        rowHeight = 40;
    }else{
        rowHeight = 50;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cell) {
            cell = [[TJMyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        TJUser *user = [[TJDataController sharedDataController]getMyUserInfo];
        [[(TJMyInfoCell *)cell profileImageView] setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:nil];
        [[(TJMyInfoCell *)cell nameLabel] setText:user.name];
        if ([user.gender isEqualToString:@"男"] || [user.gender isEqualToString:@"m"]) {
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"male.png"]];
        }else{
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"female.png"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1) {
        TJMyPhotoCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cellTwo) {
            cellTwo = [[TJMyPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        cellTwo.delegate = self;
        cellTwo.photoUrlArray = photoUrlArray;
        cell = cellTwo;
    }else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        if (!cell) {
            cell = [[TJMyRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFour"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            [cell.textLabel setTextColor:UIColorFromRGB(0x3399CC)];
            cell.textLabel.text = @"我的推荐";
        }else{
            cell.textLabel.text = @"最近访客";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            TJMyRecommendViewController *myRecommendViewController = [[TJMyRecommendViewController alloc]init];
            [self.navigationController pushViewController:myRecommendViewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 1){
            self.hidesBottomBarWhenPushed = YES;
            TJRecentViewerViewController *recentViewerViewController = [[TJRecentViewerViewController alloc]init];
            [self.navigationController pushViewController:recentViewerViewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}
#pragma TJMyPhotoCellDelegate
-(void)showPhotoActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [actionSheet showInView:self.view];
}
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
