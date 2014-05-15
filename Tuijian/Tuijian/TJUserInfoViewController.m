//
//  TJUserInfoViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJUserInfoViewController.h"
#import "TJUser.h"
#import "TJMyInfoCell.h"
#import "TJUserSignCell.h"
#import "TJUserPhotoCell.h"
#import "TJValueCell.h"
#import "TJMyRecommendCell.h"
#import "TJUserRecommendViewController.h"
#import "TJChatViewController.h"
#import "TJPaperViewController.h"

#import "TJAppDelegate.h"

@interface TJUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,TJChatCellDelegate>
{
    TJUser *theUser;
    UITableView *theTableView;
    
    BOOL isMan;
}
@property(nonatomic,strong) TJUser *theUser;
@end

@implementation TJUserInfoViewController
@synthesize userImageUrl ,userName ,userGender ,uid;
@synthesize theUser;
@synthesize chatCellStatus ,hiMessageLocalId;
@synthesize hiMessage;
-(id)init
{
    if (self = [super init]) {
        self.title = @"用户信息";
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
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    theTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:theTableView];
    
    theUser = [[TJUser alloc]init];
    theUser.name = self.userName;
    theUser.profile_image_url = self.userImageUrl;
    theUser.gender = self.userGender;
    [theUser.photosArray addObject:self.userImageUrl];
    
    if (([theUser.gender intValue] == 1) || [theUser.gender isEqualToString:@"男"] || [theUser.gender isEqualToString:@"m"]){
        isMan = YES;
    }else{
        isMan = NO;
    }
    
    [[TJDataController sharedDataController]getUserInformationFromServer:self.uid success:^(TJUser *user){
        
        self.theUser = user;
        [theTableView reloadData];
        
    }failure:^(NSError *error){
        
    }];
}
#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 0;
    if (section == 0) {
        rowNum = 1;
    }else if(section == 1){
        rowNum = 1;
    }else if(section == 2){
        rowNum = 1;
    }else if(section == 3){
        rowNum = 1;
    }else if(section == 4){
        rowNum = 1;
    }else if(section == 5){
        rowNum = 1;
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = 101;
    }else if(indexPath.section == 1){
        rowHeight = 51;
    }else if(indexPath.section == 2){
        if ([theUser.photosArray count] <= 4) {
            rowHeight = 87;
        }else{
           rowHeight = 165;
        }
    }else if(indexPath.section == 3){
        rowHeight = 40;
    }else if(indexPath.section == 4){
        rowHeight = 50;
    }else if(indexPath.section == 5){
        rowHeight = 100;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cell) {
            cell = [[TJMyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        [[(TJMyInfoCell *)cell profileImageView] setImageWithURL:[NSURL URLWithString:theUser.profile_image_url] placeholderImage:nil];
        [[(TJMyInfoCell *)cell nameLabel] setText:theUser.name];
        if (isMan) {
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"male.png"]];
        }else{
            [[(TJMyInfoCell *)cell genderImageView] setImage:[UIImage imageNamed:@"female.png"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1) {
        TJUserSignCell *userSignCell = [tableView dequeueReusableCellWithIdentifier:@"userSignCell"];
        if (!userSignCell) {
            userSignCell = [[TJUserSignCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userSignCell"];
        }
        if ([theUser.mood isEqualToString:@""]) {
            userSignCell.signLabel.text = @"这家伙还没写个性签名哦~";
        }else{
            userSignCell.signLabel.text = theUser.mood;
        }
        cell = userSignCell;
    }else if (indexPath.section == 2) {
        TJUserPhotoCell *userPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"userPhotoCell"];
        if (!userPhotoCell) {
            userPhotoCell = [[TJUserPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPhotoCell"];
        }
//        userPhotoCell.delegate = self;
        userPhotoCell.photoUrlArray = theUser.photosArray;
        cell = userPhotoCell;
    }else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        [[(TJValueCell *)cell likeNumLabel] setText:[NSString stringWithFormat:@"%d",theUser.heartNum]];
    }else if (indexPath.section == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFour"];
        if (!cell) {
            cell = [[TJMyRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFour"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            [cell.textLabel setTextColor:UIColorFromRGB(0x3399CC)];
            if (isMan) {
                 cell.textLabel.text = @"他的美食";
            }else{
                 cell.textLabel.text = @"她的美食";
            }
        }
    }else if (indexPath.section == 5){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellFive"];
        if (!cell) {
            cell = [[TJChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFive"];
        }
        [(TJChatCell *)cell setDelegate:self];
        [(TJChatCell *)cell setChatCellStatus:self.chatCellStatus];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed = YES;
            NSString *theTitle = nil;
            if (isMan) {
                theTitle = @"他的美食";
            }else{
                theTitle = @"她的美食";
            }
            TJUserRecommendViewController *userRecommendViewController = [[TJUserRecommendViewController alloc]initWithTitle:theTitle];
            userRecommendViewController.theUserId = self.uid;
            [self.navigationController pushViewController:userRecommendViewController animated:YES];
        }
    }
}
#pragma TJChatCellDelegate
-(void)sendHiTo
{
    TJPaperViewController *paperViewController = [[TJPaperViewController alloc]init];
    paperViewController.userId = self.uid;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:paperViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)acceptChat
{
    [[TJDataController sharedDataController]haveReadHiMessage:self.hiMessageLocalId];
    [[TJDataController sharedDataController]sendChatMessageTo:self.uid chatMessage:@"接受了你的聊天请求"];
    [self addPaperMessageToChat:self.hiMessage];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate changeToInfoTab];
    UINavigationController *infoNavController = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
    NSArray *viewControllers = infoNavController.viewControllers;
    UIViewController *rootViewController = [viewControllers objectAtIndex:0];
    
    rootViewController.hidesBottomBarWhenPushed = YES;
    TJChatViewController *chatViewController = [[TJChatViewController alloc]initWithTitle:self.userName];
    chatViewController.chatToUserId = self.uid;
    chatViewController.chatToUserImageUrl = self.userImageUrl;
    [infoNavController pushViewController:chatViewController animated:YES];
    rootViewController.hidesBottomBarWhenPushed = NO;
}
-(void)addPaperMessageToChat:(TJHiMessage *)theHiMessage
{
    if ([theHiMessage.messageContent isEqualToString:@""]) {
        return;
    }
    TJChatMessage *msg = [[TJChatMessage alloc] init];
    msg.content = theHiMessage.messageContent;
    //    msg.time = time;
    msg.icon = theHiMessage.profileImageUrl;
    msg.type = MessageTypeOther;
    
    TJMessage *messageList = [[TJMessage alloc]init];
    messageList.messageId = theHiMessage.uid;
    messageList.messageType = @"chatMessage";
    messageList.imageUrl = theHiMessage.profileImageUrl;
    messageList.messageTitle = theHiMessage.userName;
    messageList.messageName = nil;
    messageList.message = theHiMessage.messageContent;
    messageList.messageContentType = [NSString stringWithFormat:@"%d",MessageTypeOther];
    [[TJDataController sharedDataController]insertLocalChatMessage:theHiMessage.uid myChatMessage:msg messageList:messageList];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
