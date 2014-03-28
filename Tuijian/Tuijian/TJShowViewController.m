//
//  TJShowViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJShowViewController.h"
#import "TJCamViewController.h"
#import "TJPostViewController.h"
#import "TJItemCell.h"
#import "TJItem.h"
#import "TJCommentViewController.h"
#import "GTScrollNavigationBar.H"
#import "TJTouchableImageView.h"
#import "TJUserInfoViewController.h"

@interface TJShowViewController ()<UITableViewDelegate,UITableViewDataSource,TJCamViewControllerDelegate,TJItemCellDelegate,TJTouchableImageViewDelegate>
{
    UITableView *itemTableView;
    NSMutableArray *itemsArray;
    NSMutableArray *textHeightArray;
}
@end

@implementation TJShowViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(id)init
{
    if (self = [super init]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"camera_18_2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto:)];
    }
    return self;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPosition:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.scrollNavigationBar.scrollView = itemTableView;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.scrollNavigationBar.scrollView = nil;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    self.title = @"推荐";
    [super viewDidLoad];
    itemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    itemTableView.dataSource = self;
    itemTableView.delegate = self;
    itemTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    [self.view addSubview:itemTableView];
    
    itemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    if ([[TJDataController sharedDataController]getUserLoginMask]) {
        [self refreshTableViewData];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewData) name:TJ_UPDATE_RECOMMEND_LIST_NOTIFICATION object:nil];
}
-(void)refreshTableViewData
{
    __block UITableView *weaktheTalbleView = itemTableView;
    __block NSMutableArray *weakItemsArray = itemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    [[TJDataController sharedDataController]getItems:^(NSArray *iteArray){
        if ([iteArray count] == 0) {
            return;
        }
        [weakTextHeightArray removeAllObjects];
        [weakItemsArray removeAllObjects];
        for (int i = 0; i < [iteArray count]; i++) {
            TJItem *item = [iteArray objectAtIndex:i];
            NSString *recommendTex = item.recommendReason;
            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(300, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            [weakTextHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
        }
        [weakItemsArray addObjectsFromArray:iteArray];
        [weaktheTalbleView reloadData];
//        [weaktheTalbleView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }failure:^(NSError *error){
        
    }];
}
-(void)takePhoto:(id)sender
{
    TJCamViewController *camViewController = [[TJCamViewController alloc]init];
    camViewController.delegate = self;
    [self presentViewController:camViewController animated:YES completion:^(void){
    }];
}
#pragma TJCamViewControllerDelegate
-(void)getTheCropedImage:(UIImage *)cropedImage
{
    TJPostViewController *postViewController =[[TJPostViewController alloc]init];
    postViewController.cropedImage = cropedImage;
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [self presentViewController:navcont animated:YES completion:nil];
}

#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [itemsArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
    return textHeight + 325 + 40 + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    TJItem *theItem = [itemsArray objectAtIndex:indexPath.section];
    cell.itemId = theItem.itemId;
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
    cell.titleLabel.text = theItem.title;
    [cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    cell.likeNumLabel.text = theItem.likeNum;
    cell.commentNumLabel.text = theItem.commentNum;
    [cell setLikeButtonColor:theItem.hasLiked];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItem *item = [itemsArray objectAtIndex:indexPath.section];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
    
    self.hidesBottomBarWhenPushed = YES;
    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
    commentViewController.theItem = item;
    commentViewController.textHeight = textHeight;
    [self.navigationController pushViewController:commentViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    TJItem *theItem = [itemsArray objectAtIndex:section];
    TJTouchableImageView *userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    userImageView.sectionNum = section;
    userImageView.delegate = self;
    userImageView.clipsToBounds = YES;
    [backView addSubview:userImageView];
    userImageView.layer.cornerRadius = 40 / 2.0;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
    nameLabel.textColor = [UIColor blackColor];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [backView addSubview:nameLabel];
    
    UIImageView *genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, 13, 13)];
    [backView addSubview:genderImageView];

    UIImage *genderPlaceHolder = nil;
    if ([theItem.userGender intValue] == 1) {
        [genderImageView setImage:[UIImage imageNamed:@"male.png"]];
        genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
    }else{
        [genderImageView setImage:[UIImage imageNamed:@"female.png"]];
        genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
    }
    [userImageView setImageWithURL:[NSURL URLWithString:theItem.userImg] placeholderImage:genderPlaceHolder];
    [nameLabel setText:theItem.userName];
    
    [backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.95]];
    return backView;
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    TJItem *theItem = [itemsArray objectAtIndex:sectionNum];
    
    self.hidesBottomBarWhenPushed = YES;
    TJUserInfoViewController *userInfoViewController = [[TJUserInfoViewController alloc]init];
    userInfoViewController.userImageUrl = theItem.userImg;
    userInfoViewController.userName = theItem.userName;
    userInfoViewController.userGender = theItem.userGender;
    userInfoViewController.uid = theItem.uid;
    [self.navigationController pushViewController:userInfoViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma TJItemCellDelegate
-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL
{
    __block TJItem *theItem = [self getItemFromId:itemId];
    [[TJDataController sharedDataController]saveLike:itemId success:^(BOOL hasLiked){
        hasL(hasLiked);
        theItem.hasLiked = hasLiked;
        if (hasLiked) {
            [[TJDataController sharedDataController]sendLike:theItem];
        }
    }failure:^(NSError *error){
        
    }];
}
-(TJItem *)getItemFromId:(NSString *)itemId
{
    TJItem *theItem = nil;
    for (int i = 0; i < [itemsArray count]; i++) {
        TJItem *item = [itemsArray objectAtIndex:i];
        if ([item.itemId isEqualToString:itemId]) {
            theItem = item;
            break;
        }
    }
    return theItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
