//
//  TJGenderEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJGenderEditViewController.h"

@interface TJGenderEditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *theTableView;
}
@end

@implementation TJGenderEditViewController
@synthesize userGender;

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
    self.title = @"性别";
    self.view.backgroundColor = [UIColor whiteColor];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    theTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:theTableView];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
    }else{
        cell.textLabel.text = @"女";
    }
    if ([self.userGender isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    theCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (indexPath.row == 0) {
        NSIndexPath *theOtherIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *theOtherCell = [tableView cellForRowAtIndexPath:theOtherIndexPath];
        theOtherCell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        NSIndexPath *theOtherIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *theOtherCell = [tableView cellForRowAtIndexPath:theOtherIndexPath];
        theOtherCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.userGender = theCell.textLabel.text;
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
