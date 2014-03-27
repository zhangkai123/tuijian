//
//  TJMineViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMineViewController.h"
#import "TJUser.h"
#import "TJMyItemCell.h"
#import "TJCommentViewController.h"

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

    myItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 164, 320, self.view.frame.size.height - 164 - 49) style:UITableViewStylePlain];
    [myItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    [[TJDataController sharedDataController]getMyItems:^(NSArray *iteArray){
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myItemsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    return textHeight + 325 + 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJMyItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    TJItem *theItem = [myItemsArray objectAtIndex:indexPath.row];
    cell.itemId = theItem.itemId;
    [cell.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    cell.titleLabel.text = theItem.title;
    [cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItem *item = [myItemsArray objectAtIndex:indexPath.row];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    
    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
    commentViewController.theItem = item;
    commentViewController.textHeight = textHeight;
//    [self presentViewController:commentViewController animated:YES completion:nil];
    
    self.hidesBottomBarWhenPushed = YES;
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:commentViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
     self.hidesBottomBarWhenPushed = NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"我的推荐";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
