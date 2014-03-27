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
#import "TJMyItemCell.h"
#import "TJUserItemViewController.h"

@interface TJMineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myItemTableView;
    NSMutableArray *myItemsArray;
    NSMutableArray *textHeightArray;
}
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
    
    myItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [myItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myItemTableView.showsHorizontalScrollIndicator = NO;
    myItemTableView.showsVerticalScrollIndicator = NO;
    myItemTableView.dataSource = self;
    myItemTableView.delegate = self;
    [self.view addSubview:myItemTableView];
    
    myItemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [self refreshTableViewData];
}
-(void)refreshTableViewData
{
    __block UITableView *weaktheTalbleView = myItemTableView;
    __block NSMutableArray *weakItemsArray = myItemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    NSString *myUserId = [[TJDataController sharedDataController]getMyUserId];
    [[TJDataController sharedDataController]getUserItems:myUserId success:^(NSArray *iteArray){
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
        rowNum = [myItemsArray count];
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
        TJUser *user = [[TJDataController sharedDataController]getMyUserInfo];
        [[(TJMyInfoCell *)cell profileImageView] setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:nil];
        [[(TJMyInfoCell *)cell nameLabel] setText:user.name];
        if ([user.gender isEqualToString:@"男"]) {
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
        TJItem *theItem = [myItemsArray objectAtIndex:indexPath.row];
        [(TJMyItemCell *)cell setItemId:theItem.itemId];
        [[(TJMyItemCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
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
    TJItem *item = [myItemsArray objectAtIndex:indexPath.row];
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

@end
