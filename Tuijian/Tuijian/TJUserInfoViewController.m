//
//  TJUserInfoViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJUserInfoViewController.h"
#import "TJUser.h"
#import "TJMyInfoCell.h"
#import "TJUserPhotoCell.h"
#import "TJValueCell.h"
#import "TJMyRecommendCell.h"
#import "TJUserRecommendViewController.h"
#import "TJChatCell.h"
#import "TJChatViewController.h"


@interface TJUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,TJChatCellDelegate>
{
    UITableView *theTableView;
    NSMutableArray *photoUrlArray;
    
    BOOL isMan;
}
@end

@implementation TJUserInfoViewController
@synthesize userImageUrl ,userName ,userGender ,uid;
-(id)init
{
    if (self = [super init]) {
        self.title = @"用户信息";
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
    theTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:theTableView];
    
    if (([self.userGender intValue] == 1) || [self.userGender isEqualToString:@"男"] || [self.userGender isEqualToString:@"m"]){
        isMan = YES;
    }else{
        isMan = NO;
    }
    
    photoUrlArray = [[NSMutableArray alloc]initWithCapacity:8];
    [photoUrlArray addObject:self.userImageUrl];
//    [photoUrlArray addObject:self.userImageUrl];
//    [photoUrlArray addObject:self.userImageUrl];
//    [photoUrlArray addObject:self.userImageUrl];
//    [photoUrlArray addObject:self.userImageUrl];
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
    }else if(section == 4){
        rowNum = 1;
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = 120;
    }else if(indexPath.section == 1){
        if ([photoUrlArray count] <= 4) {
            rowHeight = 87;
        }else{
           rowHeight = 165;
        }
    }else if(indexPath.section == 2){
        rowHeight = 40;
    }else if(indexPath.section == 3){
        rowHeight = 50;
    }else if(indexPath.section == 4){
        rowHeight = 100;
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
        [[(TJMyInfoCell *)cell profileImageView] setImageWithURL:[NSURL URLWithString:self.userImageUrl] placeholderImage:nil];
        [[(TJMyInfoCell *)cell nameLabel] setText:self.userName];
        if (isMan) {
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"male.png"]];
        }else{
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"female.png"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section == 1) {
        TJUserPhotoCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cellTwo) {
            cellTwo = [[TJUserPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
//        cellTwo.delegate = self;
        cellTwo.photoUrlArray = photoUrlArray;
        cell = cellTwo;
    }else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
    }else if (indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        if (!cell) {
            cell = [[TJMyRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFour"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            [cell.textLabel setTextColor:UIColorFromRGB(0x3399CC)];
            if (isMan) {
                 cell.textLabel.text = @"他的推荐";
            }else{
                 cell.textLabel.text = @"她的推荐";
            }
        }
    }else if (indexPath.section == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFive"];
        if (!cell) {
            cell = [[TJChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
        }
        [(TJChatCell *)cell setDelegate:self];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            NSString *theTitle = nil;
            if (isMan) {
                theTitle = @"他的推荐";
            }else{
                theTitle = @"她的推荐";
            }
            TJUserRecommendViewController *userRecommendViewController = [[TJUserRecommendViewController alloc]initWithTitle:theTitle];
            userRecommendViewController.theUserId = self.uid;
            [self.navigationController pushViewController:userRecommendViewController animated:YES];
        }
    }
}
#pragma TJChatCellDelegate
-(void)sendMessageTo
{
    self.hidesBottomBarWhenPushed = YES;
    TJChatViewController *chatViewController = [[TJChatViewController alloc]initWithTitle:self.userName];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
