//
//  TJShowViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJShowViewController.h"
#import "TJCamViewController.h"
#import "TJItemCell.h"
#import "TJItem.h"
#import "TJCommentViewController.h"

@interface TJShowViewController ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *itemTableView;
    NSMutableArray *itemsArray;
    NSMutableArray *textHeightArray;
}
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
-(void)viewWillAppear:(BOOL)animated
{
    [self refreshTableViewData];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    itemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
//    [itemTableView setBackgroundColor:[UIColor clearColor]];
//    [itemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    itemTableView.rowHeight = 500;
    itemTableView.dataSource = self;
    itemTableView.delegate = self;
    itemTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    [self.view addSubview:itemTableView];
    
    itemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [self refreshTableViewData];
//    __block UITableView *weaktheTalbleView = itemTableView;
//    __block NSMutableArray *weakItemsArray = itemsArray;
//    __block NSMutableArray *weakTextHeightArray = textHeightArray;
//    [[TJDataController sharedDataController]getItems:^(NSArray *iteArray){
//        for (int i = 0; i < [iteArray count]; i++) {
//            TJItem *item = [iteArray objectAtIndex:i];
//            NSString *recommendTex = item.recommendReason;
////            CGSize expectedLabelSize = [recommendTex sizeWithFont:[UIFont systemFontOfSize:15]
////                                              constrainedToSize:CGSizeMake(300, 0)
////                                                  lineBreakMode:NSLineBreakByCharWrapping];
//            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(300, 0)
//                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//            [weakTextHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
//        }
//        [weakItemsArray addObjectsFromArray:iteArray];
//        [weaktheTalbleView reloadData];
//    }failure:^(NSError *error){
//        
//    }];
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
            //            CGSize expectedLabelSize = [recommendTex sizeWithFont:[UIFont systemFontOfSize:15]
            //                                              constrainedToSize:CGSizeMake(300, 0)
            //                                                  lineBreakMode:NSLineBreakByCharWrapping];
            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(300, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            [weakTextHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
        }
        [weakItemsArray addObjectsFromArray:iteArray];
        [weaktheTalbleView reloadData];
        [weaktheTalbleView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }failure:^(NSError *error){
        
    }];
}
-(void)takePhoto:(id)sender
{
    TJCamViewController *camViewController = [[TJCamViewController alloc]init];
    [self presentViewController:camViewController animated:YES completion:^(void){
    }];
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
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
    return textHeight + 355 + 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TJItem *theItem = [itemsArray objectAtIndex:indexPath.section];
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
    
    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
    [cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    cell.likeNumLabel.text = theItem.likeNum;
    cell.commentNumLabel.text = theItem.commentNum;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
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
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
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
    
    [backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
//    [backView setBackgroundColor:[UIColor whiteColor]];
    return backView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
