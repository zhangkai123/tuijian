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
#import "TJMyItemCell.h"
#import "TJUserItemViewController.h"

@interface TJUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *herItemTableView;
    NSMutableArray *herItemsArray;
    NSMutableArray *textHeightArray;
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
    herItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [herItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    herItemTableView.showsHorizontalScrollIndicator = NO;
    herItemTableView.showsVerticalScrollIndicator = NO;
    herItemTableView.dataSource = self;
    herItemTableView.delegate = self;
    [self.view addSubview:herItemTableView];
    
    herItemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [self refreshTableViewData];
}
-(void)refreshTableViewData
{
    __weak UITableView *weaktheTalbleView = herItemTableView;
    __block NSMutableArray *weakItemsArray = herItemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    [[TJDataController sharedDataController]getUserItems:self.uid success:^(NSArray *iteArray){
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
        UITableView *strongTableView = weaktheTalbleView;
        if (strongTableView) {
           [strongTableView reloadData];
        }
    }failure:^(NSError *error){
        
    }];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    if (section == 0) {
        rowNum = 1;
    }else{
        rowNum = [herItemsArray count];
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = 100;
    }else{
        float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
        rowHeight = textHeight + 325 + 40;
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
        if (([self.userGender intValue] == 1) || [self.userGender isEqualToString:@"男"] || [self.userGender isEqualToString:@"m"]) {
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"male.png"]];
        }else{
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"female.png"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cell) {
            cell = [[TJMyItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        TJItem *theItem = [herItemsArray objectAtIndex:indexPath.row];
        [(TJMyItemCell *)cell setItemId:theItem.itemId];
        [[(TJMyItemCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
        [[(TJMyItemCell *)cell titleLabel] setText:theItem.title];
        [(TJMyItemCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    TJItem *item = [herItemsArray objectAtIndex:indexPath.row];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    
    TJUserItemViewController *userItemViewController = [[TJUserItemViewController alloc]init];
    userItemViewController.theItem = item;
    userItemViewController.textHeight = textHeight;
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:userItemViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"我的推荐";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float headerHeight = 0;
    if (section != 0) {
        headerHeight = 30;
    }
    return headerHeight;
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
