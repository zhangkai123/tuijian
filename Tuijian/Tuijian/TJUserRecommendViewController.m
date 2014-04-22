//
//  TJUserRecommendViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJUserRecommendViewController.h"
#import "TJMyItemCell.h"
#import "TJUserItemViewController.h"

@interface TJUserRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userItemTableView;
    NSMutableArray *userItemsArray;
    NSMutableArray *textHeightArray;
}
@end

@implementation TJUserRecommendViewController
@synthesize theUserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithTitle:(NSString *)navTitle
{
    if (self = [super init]) {
        self.title = navTitle;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    userItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [userItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    userItemTableView.showsHorizontalScrollIndicator = NO;
    userItemTableView.showsVerticalScrollIndicator = NO;
    userItemTableView.dataSource = self;
    userItemTableView.delegate = self;
    [self.view addSubview:userItemTableView];
    
    userItemsArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [self startActivityIndicator];
    [self refreshTableViewData];
}
-(void)refreshTableViewData
{
    __weak UITableView *weaktheTalbleView = userItemTableView;
    __block NSMutableArray *weakItemsArray = userItemsArray;
    __block NSMutableArray *weakTextHeightArray = textHeightArray;
    [[TJDataController sharedDataController]getUserItems:self.theUserId success:^(NSArray *iteArray){
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
    return [userItemsArray count];
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
    TJItem *theItem = [userItemsArray objectAtIndex:indexPath.row];
    [(TJMyItemCell *)cell setItemId:theItem.itemId];
    [[(TJMyItemCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    [[(TJMyItemCell *)cell titleLabel] setText:theItem.title];
    [(TJMyItemCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItem *item = [userItemsArray objectAtIndex:indexPath.row];
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    
    TJUserItemViewController *userItemViewController = [[TJUserItemViewController alloc]init];
    userItemViewController.theItem = item;
    userItemViewController.textHeight = textHeight;
    
    self.hidesBottomBarWhenPushed = YES;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.7];
    [self.navigationController pushViewController: userItemViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
