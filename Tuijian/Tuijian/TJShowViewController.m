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

@interface TJShowViewController ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *itemTableView;
    NSMutableArray *itemsArray;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    itemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, 548-45) style:UITableViewStylePlain];
//    [itemTableView setBackgroundColor:[UIColor clearColor]];
    [itemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    itemTableView.rowHeight = 190;
    itemTableView.dataSource = self;
    itemTableView.delegate = self;
    [self.view addSubview:itemTableView];
    
    itemsArray = [[NSMutableArray alloc]init];

    __block UITableView *weaktheTalbleView = itemTableView;
    __block NSMutableArray *weakproductsArray = itemsArray;
    [[TJDataController sharedDataController]getItems:^(id Json){
        
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.rowNum = indexPath.row;
//    cell.delegate = self;
//    Product *leftProduct = [productsArray objectAtIndex:indexPath.row*2];
//    //change to big image to see if better performance
//    NSString *lProduct = [NSString stringWithFormat:@"%@_160x160.jpg",leftProduct.pic_url];
//    [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//    //        [cell.leftImageView setImageWithURL:[NSURL URLWithString:lProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//    cell.priceLabel2.text = leftProduct.price;
//    cell.likeLabel2.text = leftProduct.seller_credit_score;
//    
//    cell.coverView2.hidden = NO;
//    if ([productsArray count] > indexPath.row*2 + 1) {
//        Product *rightProduct = [productsArray objectAtIndex:indexPath.row*2 + 1];
//        NSString *rProduct = [NSString stringWithFormat:@"%@_160x160.jpg",rightProduct.pic_url];
//        [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//        //                [cell.rightImageView setImageWithURL:[NSURL URLWithString:rProduct] placeholderImage:[UIImage imageNamed:@"smallbPlaceHolder.png"]];
//        cell.priceLabelR2.text = rightProduct.price;
//        cell.likeLabel2R.text = rightProduct.seller_credit_score;
//    }else{
//        cell.coverView2.hidden = YES;
//    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
