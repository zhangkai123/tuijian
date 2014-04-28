//
//  TJInfoEditViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJInfoEditViewController.h"
#import "TJHeadProtraitCell.h"
#import "TJInfoTextCell.h"

@interface TJInfoEditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *theTableView;
}
@end

@implementation TJInfoEditViewController
@synthesize theUser;

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
    self.title = @"基本资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];

}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        TJHeadProtraitCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cellOne) {
            cellOne = [[TJHeadProtraitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        [cellOne.headProtraitImageView setImageWithURL:[NSURL URLWithString:theUser.profile_image_url] placeholderImage:nil];
        cell = cellOne;
    }else{
        TJInfoTextCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cellTwo) {
            cellTwo = [[TJInfoTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        switch (indexPath.row) {
            case 1:
            {
                cellTwo.titleLabel.text = @"昵称";
                cellTwo.infoLabel.text = theUser.name;
            }
                break;
            case 2:
            {
                cellTwo.titleLabel.text = @"性别";
                if ([theUser.gender isEqualToString:@"男"] || [theUser.gender isEqualToString:@"m"] || ([theUser.gender intValue] == 1)) {
                    cellTwo.infoLabel.text = @"男";
                }else{
                    cellTwo.infoLabel.text = @"女";
                }
            }
                break;
            case 3:
            {
                cellTwo.titleLabel.text = @"年龄";
                cellTwo.infoLabel.text = @"25";
            }
                break;
            default:
                break;
        }
        cell = cellTwo;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0.0;
    switch (indexPath.row) {
        case 0:
        {
            rowHeight = 100;
        }
            break;
        case 1:
        {
            rowHeight = 50;
        }
            break;
        case 2:
        {
            rowHeight = 50;
        }
            break;
        case 3:
        {
            rowHeight = 50;
        }
            break;
        default:
            break;
    }
    return rowHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
