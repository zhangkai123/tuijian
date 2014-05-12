//
//  TJHiMessageViewController.m
//  Tuijian
//
//  Created by zhang kai on 5/12/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJHiMessageViewController.h"
#import "TJHiMessageCell.h"
#import "TJHiMessage.h"
#import "UIImage+additions.h"

#import "TJAppDelegate.h"
#import "TJChatViewController.h"

@interface TJHiMessageViewController ()<UITableViewDataSource,UITableViewDelegate,TJHiMessageCellDelegate>
{
    UITableView *hiMessageTableView;
    NSMutableArray *hiMessageArray;
}
@end

@implementation TJHiMessageViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"招呼";
    
    hiMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    hiMessageTableView.dataSource = self;
    hiMessageTableView.delegate = self;
    hiMessageTableView.rowHeight = 60;
    [self.view addSubview:hiMessageTableView];
    
    hiMessageArray = [[NSMutableArray alloc]init];
    [self recieveMessage];
}
-(void)recieveMessage
{
    NSArray *mArray = [[TJDataController sharedDataController]featchHiMessage:0];
    [hiMessageArray removeAllObjects];
    [hiMessageArray addObjectsFromArray:mArray];
//    for (int i = 0; i < [hiMessageArray count]; i++) {
//        TJHiMessage *hiMessage = [hiMessageArray objectAtIndex:i];
//    }
    [hiMessageTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hiMessageArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJHiMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJHiMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TJHiMessage *hiMessage = [hiMessageArray objectAtIndex:indexPath.row];
    __block UIImageView *weakImageView = [cell userImageView];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:hiMessage.profileImageUrl]];
    [[cell userImageView] setImageWithURLRequest:urlRequest
                                placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                         success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                             
                                             float radius = MAX(image.size.width, image.size.height);
                                             weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                         }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                             
                                         }];
    cell.delegate = self;
    cell.rowNum = indexPath.row;
    [cell setUserName:hiMessage.userName];
    [cell setButtonType:hiMessage.messageContentType];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma TJHiMessageCellDelegate
-(void)acceptChat:(int)rowN
{
    TJHiMessage *hiMessage = [hiMessageArray objectAtIndex:rowN];
    hiMessage.messageContentType = @"0";
    [[TJDataController sharedDataController]haveReadHiMessage:hiMessage.theId];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate changeToInfoTab];
    UINavigationController *infoNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
    NSArray *viewControllers = infoNavController.viewControllers;
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
    
    rootViewController.hidesBottomBarWhenPushed = YES;
    TJChatViewController *chatViewController = [[TJChatViewController alloc]initWithTitle:hiMessage.userName];
    chatViewController.chatToUserId = hiMessage.uid;
    chatViewController.chatToUserImageUrl = hiMessage.profileImageUrl;
    [infoNavController pushViewController:chatViewController animated:YES];
    rootViewController.hidesBottomBarWhenPushed = NO;
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
