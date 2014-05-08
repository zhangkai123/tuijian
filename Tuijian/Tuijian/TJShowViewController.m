//
//  TJShowViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJShowViewController.h"
#import "TJItemCell.h"
#import "TJItem.h"
#import "TJCommentViewController.h"
#import "TJUserInfoViewController.h"
#import "UIImage+additions.h"

@interface TJShowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _pageIndex;
    UIRefreshControl *refreshControl;
    
    NSMutableArray *itemsArray;
    NSMutableArray *textHeightArray;
    
    float previousScrollViewYOffset;
}
@end

@implementation TJShowViewController
@synthesize itemTableView;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
+ (TJShowViewController *)showViewControllerForPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex < 4)
    {
        return [[self alloc] initWithPageIndex:pageIndex];
    }
    return nil;
}
- (id)initWithPageIndex:(NSInteger)pageIndex
{
    self = [super init];
    if (self)
    {
        _pageIndex = pageIndex;
    }
    return self;
}
- (NSInteger)pageIndex
{
    return _pageIndex;
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
    [itemTableView reloadData];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    self.title = @"美食";
    [super viewDidLoad];
    itemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 20 - 49) style:UITableViewStylePlain];
    itemTableView.dataSource = self;
    itemTableView.delegate = self;
    itemTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:itemTableView];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 50, 0);
    itemTableView.contentInset = insets;
    itemTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableViewData) forControlEvents:UIControlEventValueChanged];
    [itemTableView addSubview:refreshControl];
    
    itemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    if ([[TJDataController sharedDataController]getUserLoginMask]) {
        [self startActivityIndicator];
        [self refreshTableViewData];
    }
    if (_pageIndex == 0) {
        //only “动态” get the latest post item
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewData) name:TJ_UPDATE_RECOMMEND_LIST_NOTIFICATION object:nil];
    }
}

-(void)refreshTableViewData
{
    __weak UITableView *weaktheTalbleView = itemTableView;
    __block NSMutableArray *weakItemsArray = itemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    NSString *category = nil;
    if (_pageIndex == 0) {
        category = @"美食";
    }else if(_pageIndex == 1){
        category = @"玩乐";
    }else if(_pageIndex == 2){
        category = @"all";
    }else if(_pageIndex == 3){
        category = @"focus";
    }
    [[TJDataController sharedDataController]getItems:category success:^(NSArray *iteArray){
        if ([iteArray count] == 0) {
            [activityIndicator stopAnimating];
            [refreshControl endRefreshing];
            return;
        }
        [weakTextHeightArray removeAllObjects];
        [weakItemsArray removeAllObjects];
        for (int i = 0; i < [iteArray count]; i++) {
            TJItem *item = [iteArray objectAtIndex:i];
            NSString *recommendTex = item.recommendReason;
            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(TJ_RECOMMEND_WIDTH, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]} context:nil];
            if ([recommendTex isEqualToString:@""]) {
                expectedLabelRect.size.height = 0;
            }
            [weakTextHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
        }
        [weakItemsArray addObjectsFromArray:iteArray];
        UITableView *strongTableView = weaktheTalbleView;
        if (strongTableView != nil) {
            [strongTableView reloadData];
        }
        [refreshControl endRefreshing];
        [activityIndicator stopAnimating];
    }failure:^(NSError *error){
        [refreshControl endRefreshing];
        [activityIndicator stopAnimating];
    }];
}

#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    return textHeight + 165 + 40 + 22 + 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    TJItem *theItem = [itemsArray objectAtIndex:indexPath.row];
    cell.itemId = theItem.itemId;
    cell.theRowNum = indexPath.row;
    
    UIImage *genderPlaceHolder = nil;
    if ([theItem.userGender intValue] == 1) {
        [cell.genderImageView setImage:[UIImage imageNamed:@"male.png"]];
        genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
    }else{
        [cell.genderImageView setImage:[UIImage imageNamed:@"female.png"]];
        genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
    }
    __block UIImageView *weakImageView = cell.userImageView;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:theItem.userImg]];
    [cell.userImageView setImageWithURLRequest:urlRequest
                         placeholderImage:genderPlaceHolder
                                  success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                      
                                      float radius = MAX(image.size.width, image.size.height);
                                      weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                  }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                      
                                  }];
    CGRect expectedLabelRect = [theItem.userName boundingRectWithSize:CGSizeMake(0, 20)
                                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    float nameLabelWidth = expectedLabelRect.size.width;
    if (nameLabelWidth > 150) {
        nameLabelWidth = 150;
    }
    [cell.nameLabel setText:theItem.userName];
    
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    [cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    cell.likeNumLabel.text = theItem.likeNum;
    cell.commentNumLabel.text = theItem.commentNum;
    [cell setLikeButtonColor:theItem.hasLiked];
    cell.delegate = (id)self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItem *item = [itemsArray objectAtIndex:indexPath.row];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    
    UIViewController *rootViewController = [self getTheNavigationRootViewController];
    rootViewController.hidesBottomBarWhenPushed = YES;
    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
    commentViewController.theItem = item;
    commentViewController.textHeight = textHeight;
    [self.navigationController pushViewController:commentViewController animated:YES];
    rootViewController.hidesBottomBarWhenPushed = NO;
}
#pragma TJItemCellDelegate
-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL
{
    __block TJItem *theItem = [self getItemFromId:itemId];
    if (theItem.hasLiked) {
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] - 1];
        if ([theItem.likeNum intValue] < 0) {
            theItem.likeNum = @"0";
        }
    }else{
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] + 1];
    }
    theItem.hasLiked = !theItem.hasLiked;
    hasL(theItem.hasLiked);
    [[TJDataController sharedDataController]saveLike:itemId success:^(BOOL hasLiked){
        if (hasLiked) {
            [[TJDataController sharedDataController]sendLike:theItem];
        }
    }failure:^(NSError *error){
        
    }];
}
-(void)goToUserInformationPgae:(int)rowNum
{
    TJItem *theItem = [itemsArray objectAtIndex:rowNum];
    
    UIViewController *rootViewController = [self getTheNavigationRootViewController];
    rootViewController.hidesBottomBarWhenPushed = YES;
    TJUserInfoViewController *userInfoViewController = [[TJUserInfoViewController alloc]init];
    userInfoViewController.userImageUrl = theItem.userImg;
    userInfoViewController.userName = theItem.userName;
    userInfoViewController.userGender = theItem.userGender;
    userInfoViewController.uid = theItem.uid;
    [self.navigationController pushViewController:userInfoViewController animated:YES];
    rootViewController.hidesBottomBarWhenPushed = NO;
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
