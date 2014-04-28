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
#import "TJMoodCell.h"
#import "TJMyPhotoCell.h"
#import "TJValueCell.h"
#import "TJMyRecommendCell.h"
#import "TJUserRecommendViewController.h"
#import "TJRecentViewerViewController.h"
#import "TJAppDelegate.h"

#import "TJInfoEditViewController.h"
#import "TJMoodViewController.h"

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
        
        UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        [[logoutButton titleLabel]setFont:[UIFont systemFontOfSize:16]];
        [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
        self.navigationItem.leftBarButtonItem = logoutButtonItem;
    }
    return self;
}
-(void)logout
{
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate logoutToShowLoginPage];
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
    theTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:theTableView];
    
    photoUrlArray = [[NSMutableArray alloc]initWithCapacity:8];
    TJUser *user = [[TJDataController sharedDataController]getMyUserInfo];
    [photoUrlArray addObject:user.profile_image_url];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
    }else if(section == 3){
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
        rowHeight = 101;
    }else if(indexPath.section == 1){
        rowHeight = 51;
    }else if(indexPath.section == 2){
        rowHeight = 165;
    }else if(indexPath.section == 3){
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1) {
        TJMoodCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cellTwo) {
            cellTwo = [[TJMoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        cellTwo.moodLabel.text = @"[开心]今天好开心呀！今天好开心呀！";
        cellTwo.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = cellTwo;
    }else if (indexPath.section == 2) {
        TJMyPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!photoCell) {
            photoCell = [[TJMyPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        photoCell.delegate = self;
        photoCell.photoUrlArray = photoUrlArray;
        cell = photoCell;
    }else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        if (!cell) {
            cell = [[TJValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFour"];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFive"];
        if (!cell) {
            cell = [[TJMyRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
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
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed = YES;
        TJInfoEditViewController *infoEditViewController = [[TJInfoEditViewController alloc]init];
        [self.navigationController pushViewController:infoEditViewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(indexPath.section == 1){
        self.hidesBottomBarWhenPushed = YES;
        TJMoodViewController *moodViewController = [[TJMoodViewController alloc]init];
        [self.navigationController pushViewController:moodViewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            TJUserRecommendViewController *myRecommendViewController = [[TJUserRecommendViewController alloc]initWithTitle:@"我的推荐"];
            NSString *myUserId = [[TJDataController sharedDataController]getMyUserId];
            myRecommendViewController.theUserId = myUserId;
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
        [self showAlbume];
    }
}
-(void)showAlbume
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
//    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    TJCropViewController *cropViewController = [[TJCropViewController alloc]init];
//    cropViewController.delegate = self;
//    cropViewController.thePhoto = chosenImage;
//    [self displayContentController:cropViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
