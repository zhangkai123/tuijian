//
//  TJMyRecommendViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJMyRecommendViewController.h"
#import "TJMyItemCell.h"
#import "TJUserItemViewController.h"

@interface TJMyRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myItemTableView;
    NSMutableArray *myItemsArray;
    NSMutableArray *textHeightArray;
}
@end

@implementation TJMyRecommendViewController

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
    self.title = @"我的推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    myItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [myItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    myItemTableView.showsHorizontalScrollIndicator = NO;
    myItemTableView.showsVerticalScrollIndicator = NO;
    myItemTableView.dataSource = self;
    myItemTableView.delegate = self;
    [self.view addSubview:myItemTableView];

    myItemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [self startActivityIndicator];
    [self refreshTableViewData];
}
-(void)refreshTableViewData
{
    __weak UITableView *weaktheTalbleView = myItemTableView;
    __block NSMutableArray *weakItemsArray = myItemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    NSString *myUserId = [[TJDataController sharedDataController]getMyUserId];
    [[TJDataController sharedDataController]getUserItems:myUserId success:^(NSArray *iteArray){
        if ([iteArray count] == 0) {
            [activityIndicator stopAnimating];
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
        if (strongTableView != nil) {
            [strongTableView reloadData];
        }
        [activityIndicator stopAnimating];
    }failure:^(NSError *error){
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
    return [myItemsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    float rowHeight = textHeight + 325 + 40;
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJMyItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TJItem *theItem = [myItemsArray objectAtIndex:indexPath.row];
    [(TJMyItemCell *)cell setItemId:theItem.itemId];
    [[(TJMyItemCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    [[(TJMyItemCell *)cell titleLabel] setText:theItem.title];
    [(TJMyItemCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItem *item = [myItemsArray objectAtIndex:indexPath.row];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    
    TJUserItemViewController *userItemViewController = [[TJUserItemViewController alloc]init];
    userItemViewController.theItem = item;
    userItemViewController.textHeight = textHeight;
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:userItemViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
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
