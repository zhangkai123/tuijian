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
#import "TJMySignCell.h"
#import "TJMyPhotoCell.h"
#import "TJValueCell.h"
#import "TJMyRecommendCell.h"
#import "TJUserRecommendViewController.h"
#import "TJRecentViewerViewController.h"
#import "TJAppDelegate.h"

#import "TJInfoEditViewController.h"
#import "TJPersonalSignViewController.h"
#import "TJTouchablePhotoView.h"
#import "TJPhotosViewController.h"

@interface TJMineViewController ()<UITableViewDataSource,UITableViewDelegate,TJMySignCellDelegate,TJMyPhotoCellDelegate,UIActionSheetDelegate,TJPersonalSignViewControllerDelegate,TJPhotosViewControllerDelegate>
{
    UITableView *theTableView;
    TJUser *theUser;
    
    MBProgressHUD *uploadHud;
    
    UIView *photosCoverView;
    int deletingPhotoIndex;
}
@property(nonatomic,strong) TJUser *theUser;
@end

@implementation TJMineViewController
@synthesize theUser;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(id)init
{
    if (self = [super init]) {
        self.title = @"我的";
        
//        UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
//        [[logoutButton titleLabel]setFont:[UIFont systemFontOfSize:16]];
//        [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
//        [logoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
//        self.navigationItem.leftBarButtonItem = logoutButtonItem;
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
    
    theUser = [[TJDataController sharedDataController]getMyUserInfo];
//    [theUser.photosArray addObject:theUser.profile_image_url];
    NSString *myUserId = [[TJDataController sharedDataController]getMyUserId];
    [[TJDataController sharedDataController]getUserInformationFromServer:myUserId success:^(TJUser *user){
        
        [theUser.photosArray removeAllObjects];
        self.theUser = user;
        self.theUser.userStar = [self computeUserStar:self.theUser.charmValue];
        [theTableView reloadData];
    }failure:^(NSError *error){
        
    }];
}
-(int)computeUserStar:(int)value
{
    int userStar = 1;
    if ((value >= 1) && (value < 10)) {
        userStar = 1;
    }
    else if ((value >= 10) && (value < 30)){
        userStar = 2;
    }
    else if ((value >= 30) && (value < 70)){
        userStar = 3;
    }
    else if ((value >= 70) && (value < 150)){
        userStar = 4;
    }
    else if ((value >= 150) && (value < 310)){
        userStar = 5;
    }
    else if ((value >= 310) && (value < 630)){
        userStar = 6;
    }
    else if ((value >= 630) && (value < 1270)){
        userStar = 7;
    }
    else if ((value >= 1270) && (value < 2550)){
        userStar = 8;
    }
    else if ((value >= 2550) && (value < 5110)){
        userStar = 9;
    }
    else if ((value >= 5110) && (value < 10122)){
        userStar = 10;
    }
    return userStar;
}
-(TJMyPhotoCell *)getPhotoCell
{
    return (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
}
-(TJMySignCell *)getSignCell
{
    return (TJMySignCell *)[theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
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
        rowNum = 1;
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
        [[(TJMyInfoCell *)cell profileImageView] setImageWithURL:[NSURL URLWithString:theUser.profile_image_url] placeholderImage:nil];
        [[(TJMyInfoCell *)cell nameLabel] setText:theUser.name];
        if ([theUser.gender isEqualToString:@"男"] || [theUser.gender isEqualToString:@"m"] || ([theUser.gender intValue] == 1)) {
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"male.png"]];
        }else{
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"female.png"]];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1) {
        TJMySignCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cellTwo) {
            cellTwo = [[TJMySignCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        cellTwo.delegate = self;
        if ([theUser.mood isEqualToString:@""]) {
            cellTwo.signLabel.text = @"说点什么吧";
        }else{
            cellTwo.signLabel.text = theUser.mood;
        }
        cellTwo.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = cellTwo;
    }else if (indexPath.section == 2) {
        TJMyPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!photoCell) {
            photoCell = [[TJMyPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        photoCell.delegate = self;
        photoCell.photoUrlArray = theUser.photosArray;
        cell = photoCell;
    }else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        if (!cell) {
            cell = [[TJValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFour"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [(TJValueCell *)cell setLikeNumber:theUser.heartNum];
        [(TJValueCell *)cell setTheUserStar:theUser.userStar];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFive"];
        if (!cell) {
            cell = [[TJMyRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.textLabel setTextColor:UIColorFromRGB(0x3399CC)];
        cell.textLabel.text = @"我的美食";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        self.hidesBottomBarWhenPushed = YES;
//        TJInfoEditViewController *infoEditViewController = [[TJInfoEditViewController alloc]init];
//        infoEditViewController.theUser = theUser;
//        
//        [self.navigationController pushViewController:infoEditViewController animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            TJUserRecommendViewController *myRecommendViewController = [[TJUserRecommendViewController alloc]initWithTitle:@"我的美食"];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma TJMySignCellDelegate
-(void)haveClickedSignCell
{
    TJPersonalSignViewController *personalSignViewController = [[TJPersonalSignViewController alloc]init];
    personalSignViewController.delegate = self;
    personalSignViewController.moodText = theUser.mood;
    [self presentViewController:personalSignViewController animated:YES completion:nil];
}
#pragma TJMyPhotoCellDelegate
-(void)selectPhotoWithIndex:(int)photoIndex
{
    NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    TJMyPhotoCell *photosCell = (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:theIndexPath];
    TJTouchablePhotoView *thePhotoView = (TJTouchablePhotoView *)[photosCell viewWithTag:1000 + photoIndex];
    
    CGRect photoViewRect = [self getThePhotoImageViewRectAtIndex:photoIndex];
    float tableViewContentOffset = theTableView.contentOffset.y + 64;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    photosCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenRect.size.height)];
    photosCoverView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(photoViewRect.origin.x, photoViewRect.origin.y + 64 - tableViewContentOffset, 70, 70)];
    bigImageView.image = thePhotoView.image;
    bigImageView.tag = 1000;
    [photosCoverView addSubview:bigImageView];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:photosCoverView];
    
    float scaleValue = 320.0/70.0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         bigImageView.transform=CGAffineTransformMakeScale(scaleValue, scaleValue);
                         bigImageView.center = keyWindow.center;
                     }
                     completion:^(BOOL finished){
                         [photosCoverView removeFromSuperview];
                         TJPhotosViewController *photosViewController = [[TJPhotosViewController alloc]init];
                         photosViewController.imageArray = theUser.photosArray;
                         photosViewController.placeHolderImageArray = [self getTheSmallPhotos];
                         photosViewController.beginningIndex = photoIndex;
                         photosViewController.delegate = self;
                         [self presentViewController:photosViewController animated:NO completion:nil];
                     }];
}
-(NSMutableArray *)getTheSmallPhotos
{
    NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    TJMyPhotoCell *photosCell = (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:theIndexPath];
    NSMutableArray *smallPhotosArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [theUser.photosArray count]; i++) {
        
        TJTouchablePhotoView *thePhotoView = (TJTouchablePhotoView *)[photosCell viewWithTag:1000 + i];
        [smallPhotosArray addObject:thePhotoView.image];
    }
    return smallPhotosArray;
}
-(void)showPhotoActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}
-(void)showDeletePhotoActionSheet:(int)photoIndex
{
    deletingPhotoIndex = photoIndex;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"删除",nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}
#pragma TJPhotosViewControllerDelegate
-(void)backFromPhotoAlum:(UIImage *)bigPhoto atIndex:(int)theIndex
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    int position = 0;
    if (screenHeight == 568){
        position = 124;
    }else{
        position = 80;
    }
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    coverView.backgroundColor = [UIColor clearColor];
    UIImageView *holdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, position, 320, 320)];
    holdImageView.image = bigPhoto;
    [coverView addSubview:holdImageView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:coverView];
   
    float tableViewContentOffset = theTableView.contentOffset.y + 64;
    CGRect photoViewRect = [self getThePhotoImageViewRectAtIndex:theIndex];
    float scaleValue = 70.0/320.0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         holdImageView.transform=CGAffineTransformMakeScale(scaleValue, scaleValue);
                         holdImageView.frame = CGRectMake(photoViewRect.origin.x,photoViewRect.origin.y + 64 - tableViewContentOffset, 70, 70);
                         holdImageView.layer.cornerRadius = 5/scaleValue;
                         holdImageView.layer.masksToBounds = YES;
                     }
                     completion:^(BOOL finished){
                         [coverView removeFromSuperview];
                     }];
}

#pragma TJPersonalSignViewControllerDelegate
-(void)updateMoodText:(NSString *)mText
{
    TJMySignCell *signCell = [self getSignCell];
    signCell.signLabel.text = mText;
    theUser.mood = mText;
}
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (popup.tag == 0) {
        if (buttonIndex == 0) {
            [self showCamera];
        }else if(buttonIndex == 1){
            [self showAlbume];
        }
    }else{
        if (buttonIndex == 0) {
            NSString *photoId = [theUser.photosIdArray objectAtIndex:deletingPhotoIndex];
            [[TJDataController sharedDataController]removePhotoWithId:photoId success:^(BOOL success){
                
            }failure:^(NSError *error){
            }];
            [theUser.photosArray removeObjectAtIndex:deletingPhotoIndex];
            [theTableView reloadData];
        }else{
            NSIndexPath *photoCellIndex = [NSIndexPath indexPathForRow:0 inSection:2];
            TJMyPhotoCell *myPhotoCell = (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:photoCellIndex];
            [myPhotoCell cancelShakeView];
        }
    }
}
-(void)showCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    [picker setAllowsEditing:YES];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
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
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    int position = 0;
    if (screenHeight == 568){
        position = 124;
    }else{
        position = 80;
    }
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    coverView.backgroundColor = [UIColor blackColor];
    UIImageView *holdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, position, 320, 320)];
    holdImageView.image = chosenImage;
    [coverView addSubview:holdImageView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:coverView];
    [self showHUDWhenUploading];
    [[TJDataController sharedDataController]uploadUserPhoto:chosenImage progress:^(float uploadProgress){
        uploadHud.progress = uploadProgress;
        if (uploadProgress >= 1.0) {
            uploadHud.progress = 1.0;
            [uploadHud hide:YES];
            holdImageView.frame = CGRectMake(0, position - 64, 320, 320);
            [theTableView addSubview:holdImageView];
            [coverView removeFromSuperview];
            
            float scaleValue = 70.0/320.0;
            [UIView animateWithDuration:0.7
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 holdImageView.transform=CGAffineTransformMakeScale(scaleValue, scaleValue);
                                 holdImageView.center = [self getTheUploadImageViewPosition];
                                 holdImageView.layer.cornerRadius = 5/scaleValue;
                                 holdImageView.layer.masksToBounds = YES;
                             }
                             completion:^(BOOL finished){
                                 [theUser.photosArray addObject:@"uploading"];
                                 NSIndexPath *photoCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                                 TJMyPhotoCell *myPhotoCell = (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:photoCellIndexPath];
                                 myPhotoCell.photoUrlArray = theUser.photosArray;
                                 [myPhotoCell setImageAtIndex:([theUser.photosArray count] - 1) placeHolderImage:chosenImage];
                                 [holdImageView removeFromSuperview];
                             }];
        }
    }success:^(NSString *uploadImageUrl){
        [self updatePhotoCellData:uploadImageUrl];
    }failure:^(NSError *error){
        [uploadHud hide:YES];
    }];
}
-(void)updatePhotoCellData:(NSString *)iUrl
{
    for (int i = 0; i < [theUser.photosArray count]; i++) {
        NSString *photoUrl = [theUser.photosArray objectAtIndex:i];
        if ([photoUrl isEqualToString:@"uploading"]) {
            [theUser.photosArray replaceObjectAtIndex:i withObject:iUrl];
            break;
        }
    }
    NSIndexPath *photoCellIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    TJMyPhotoCell *myPhotoCell = (TJMyPhotoCell *)[theTableView cellForRowAtIndexPath:photoCellIndex];
    myPhotoCell.photoUrlArray = theUser.photosArray;
}
- (void)showHUDWhenUploading {
	
	uploadHud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
	
	// Configure for text only and offset down
	uploadHud.mode = MBProgressHUDModeDeterminate;
	uploadHud.margin = 10.f;
	uploadHud.removeFromSuperViewOnHide = YES;
}
-(CGPoint)getTheUploadImageViewPosition
{
    NSIndexPath *photoCellIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    CGRect photoCellRect = [theTableView rectForRowAtIndexPath:photoCellIndex];
    int imageCount = [theUser.photosArray count];
    int colume = imageCount/4;
    int row = imageCount%4;
    CGPoint uploadImageViewPosition = CGPointMake(8 + row*(70 + 8) + 35, 8 + colume*(70 + 8) + photoCellRect.origin.y + 35);
    return uploadImageViewPosition;
}
-(CGRect)getThePhotoImageViewRectAtIndex:(int)photoIndex
{
    NSIndexPath *photoCellIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    CGRect photoCellRect = [theTableView rectForRowAtIndexPath:photoCellIndex];
    int colume = photoIndex/4;
    int row = photoIndex%4;
    CGRect theRect = CGRectMake(8 + row*(70 + 8), 8 + colume*(70 + 8) + photoCellRect.origin.y,70,70);
    return theRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
