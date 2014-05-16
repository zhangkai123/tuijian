//
//  TJPhotosViewController.m
//  Tuijian
//
//  Created by zhang kai on 5/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJPhotosViewController.h"
#import "TJBigPhotoCell.h"

@interface TJPhotosViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
}
@end

@implementation TJPhotosViewController
@synthesize imageArray ,placeHolderImageArray ,beginningIndex;

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
    self.view.backgroundColor = [UIColor blackColor];
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    myTableView.pagingEnabled = YES;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //set the row height to 340 for 20 space bettwen two images
    myTableView.rowHeight = 340;
    [self.view addSubview:myTableView];
    //after transform , should reframe the table
    myTableView.frame = CGRectMake(0, 0, 340, screenHeight);
    myTableView.backgroundColor = [UIColor clearColor];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.beginningIndex inSection:0];
    [myTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJBigPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJBigPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    NSString *imageUrl = [self.imageArray objectAtIndex:indexPath.row];
    [cell.photoImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[self.placeHolderImageArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
