//
//  TJInfoViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJInfoViewController.h"

@interface TJInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infoTableView;
    NSMutableArray *infoArray;
}
@end

@implementation TJInfoViewController

-(id)init
{
    if (self = [super init]) {
        self.title = @"消息";
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
    infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    infoTableView.dataSource = self;
    infoTableView.delegate = self;
    infoTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    infoTableView.rowHeight = 80;
    [self.view addSubview:infoTableView];

    infoArray = [[NSMutableArray alloc]init];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoArray count];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TJItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    TJItem *theItem = [itemsArray objectAtIndex:indexPath.section];
//    cell.itemId = theItem.itemId;
//    [cell.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
//    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
//    [cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
//    cell.likeNumLabel.text = theItem.likeNum;
//    cell.commentNumLabel.text = theItem.commentNum;
//    [cell setLikeButtonColor:theItem.hasLiked];
//    cell.delegate = self;
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TJItem *item = [itemsArray objectAtIndex:indexPath.section];
//    float textHeight = [[textHeightArray objectAtIndex:indexPath.section] floatValue];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
//    commentViewController.theItem = item;
//    commentViewController.textHeight = textHeight;
//    [self.navigationController pushViewController:commentViewController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
