//
//  TJInfoViewController.m
//  Tuijian
//
//  Created by zhang kai on 2/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJInfoViewController.h"
#import "TJMessage.h"
#import "TJMessageCell.h"
#import "TJItemMessageViewController.h"
#import "TJChatViewController.h"
#import "UIImage+additions.h"
#import "TJAppDelegate.h"
#import "TJCommentViewController.h"

@interface TJInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *infoTableView;
    NSMutableArray *infoListArray;
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
-(void)viewWillAppear:(BOOL)animated
{
    [infoTableView reloadData];
    [super viewWillAppear:animated];
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

    infoListArray = [[NSMutableArray alloc]init];
    
    NSArray *messageListArray = [[TJDataController sharedDataController]featchMessageList];
    [infoListArray addObjectsFromArray:messageListArray];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMessageList) name:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
}
-(void)refreshMessageList
{
    NSArray *messageListArray = [[TJDataController sharedDataController]featchMessageList];
    [infoListArray removeAllObjects];
    [infoListArray addObjectsFromArray:messageListArray];
    [infoTableView reloadData];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoListArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TJMessage *message = [infoListArray objectAtIndex:indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:message.imageUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageUrl];
    __block UIImageView *weakImageView = cell.theImageView;
    cell.messageId = message.messageId;
    [cell.theImageView setImageWithURLRequest:urlRequest
                                placeholderImage:[UIImage imageNamed:@"message_placeholder.png"]
                                         success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                             
                                             float radius = MAX(image.size.width, image.size.height);
                                             weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                         }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                             
                                         }];
    [cell setMessageTitle:message.messageTitle];
    NSString *messageContent = nil;
    if ([message.messageType isEqualToString:@"itemMessage"]) {
        if ([message.messageContentType isEqualToString:@"like"]) {
            messageContent = [NSString stringWithFormat:@"%@给了你一个赞",message.messageName];
        }else if([message.messageContentType isEqualToString:@"comment"]){
            messageContent = [NSString stringWithFormat:@"%@评论%@",message.messageName,message.message];
        }else if([message.messageContentType isEqualToString:@"replyComment"]){
            messageContent = [NSString stringWithFormat:@"%@回复你的评论:%@",message.messageName,message.message];
        }
    }else if ([message.messageType isEqualToString:@"chatMessage"]){
        messageContent = message.message;
    }
    [cell.messageLabel setText:messageContent];
    if (message.messageNum > 0) {
        cell.notificationView.hidden = NO;
    }else{
        cell.notificationView.hidden = YES;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = [infoListArray objectAtIndex:indexPath.row];

    if ([message.messageType isEqualToString:@"itemMessage"]) {
        [[TJDataController sharedDataController]clearInfoMessageNum:[message.messageId intValue] messageType:@"itemMessage"];
        message.messageNum = 0;
        
        self.hidesBottomBarWhenPushed = YES;
        TJItemMessageViewController *itemMessageViewController = [[TJItemMessageViewController alloc]initWithTitle:message.messageTitle];
        itemMessageViewController.theMessage = message;
        [self.navigationController pushViewController:itemMessageViewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([message.messageType isEqualToString:@"chatMessage"]){
        [[TJDataController sharedDataController]clearInfoMessageNum:[message.messageId intValue] messageType:@"chatMessage"];
        message.messageNum = 0;

        self.hidesBottomBarWhenPushed = YES;
        TJChatViewController *chatViewController = [[TJChatViewController alloc]initWithTitle:message.messageTitle fromInfoPage:YES];
        chatViewController.chatToUserId = message.messageId;
        [self.navigationController pushViewController:chatViewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate updateInfoTabbarBadge];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        TJMessage *message = [infoListArray objectAtIndex:indexPath.row];
        [[TJDataController sharedDataController]deleteFromMessageList:message.messageId messageType:message.messageType];
        [self refreshMessageList];
    }
}
//#pragma TJMessageCellDelegate
//-(void)goToMessageParent:(NSString *)messageId
//{
//    UIViewController *rootViewController = [self getTheNavigationRootViewController];
//    rootViewController.hidesBottomBarWhenPushed = YES;
//    TJCommentViewController *commentViewController = [[TJCommentViewController alloc]init];
//    commentViewController.theItemId = messageId;
//    [self.navigationController pushViewController:commentViewController animated:YES];
//    rootViewController.hidesBottomBarWhenPushed = NO;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
