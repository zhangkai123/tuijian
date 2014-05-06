//
//  TJChatViewController.m
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJChatViewController.h"
#import "TJAppDelegate.h"
#import "MessageFrame.h"
#import "TJChatMessage.h"
#import "TJMessage.h"
#import "MessageCell.h"
#import "TJChatView.h"
#import "TJUserInfoViewController.h"

@interface TJChatViewController ()<UITableViewDataSource,UITableViewDelegate,TJChatViewDelegate,MessageCellDelegate>
{
    NSString *myOwnImageUrl;
    UITableView *theTableView;
    NSMutableArray  *_allMessagesFrame;
    
    UIButton *coverButton;
    TJChatView *chatView;
    
    UIRefreshControl *refreshControl;
    int currentPageNum;
}
@end

@implementation TJChatViewController
@synthesize chatToUserId ,chatToUserImageUrl;

-(void)dealloc
{
    
}
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 40) style:UITableViewStylePlain];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    theTableView.allowsSelection = NO;
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    theTableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self.view addSubview:theTableView];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getMoreChatMessage) forControlEvents:UIControlEventValueChanged];
    [theTableView addSubview:refreshControl];
    
    coverButton = [[UIButton alloc]initWithFrame:self.view.frame];
    [coverButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverButton];
    coverButton.hidden = YES;
    
    chatView = [[TJChatView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    chatView.delegate = self;
    [self.view addSubview:chatView];
    
    TJUser *myUser = [[TJDataController sharedDataController]getMyUserInfo];
    myOwnImageUrl = myUser.profile_image_url;

    currentPageNum = 0;
    NSArray *array = [[TJDataController sharedDataController]featchChatMessage:self.chatToUserId byPage:currentPageNum];
    
    _allMessagesFrame = [NSMutableArray array];
//    NSString *previousTime = nil;
//    for (NSDictionary *dict in array) {
//        
//        MessageFrame *messageFrame = [[MessageFrame alloc] init];
//        TJChatMessage *message = [[TJChatMessage alloc] init];
//        message.dict = dict;
//        
//        messageFrame.showTime = ![previousTime isEqualToString:message.time];
//        
//        messageFrame.message = message;
//        
//        previousTime = message.time;
//        
//        [_allMessagesFrame addObject:messageFrame];
//    }
    float contentOffset = 0.0;
    for (TJChatMessage *chatMessage in array) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        
//        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = chatMessage;
        
//        previousTime = message.time;
        contentOffset += [messageFrame cellHeight];
        [_allMessagesFrame addObject:messageFrame];
    }
    [theTableView setContentOffset:CGPointMake(0, contentOffset)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveChatMessage) name:TJ_CHAT_VIEWCONTROLLER_NOTIFICATION object:nil];
}
-(void)getMoreChatMessage
{
    [refreshControl endRefreshing];
    NSArray *array = [[TJDataController sharedDataController]featchChatMessage:self.chatToUserId byPage:currentPageNum + 1];
    if ([array count] == 0) {
        return;
    }
    currentPageNum ++;
    [_allMessagesFrame removeAllObjects];
    for (TJChatMessage *chatMessage in array) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        messageFrame.message = chatMessage;
        [_allMessagesFrame addObject:messageFrame];
    }
    [theTableView reloadData];
}
-(void)hideKeyboard
{
    [chatView showKeyboard:NO];
}

//#pragma mark - 文本框代理方法
//#pragma mark 点击textField键盘的回车按钮
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    // 1、增加数据源
//    NSString *content = textField.text;
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    NSDate *date = [NSDate date];
//    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
//    NSString *time = [fmt stringFromDate:date];
//    [self addMessageWithContent:content time:time];
//    // 2、刷新表格
//    [theTableView reloadData];
//    // 3、滚动至当前行
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
//    [theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    // 4、清空文本框内容
//    _messageField.text = nil;
//    return YES;
//}
-(void)receiveChatMessage
{
    currentPageNum = 0;
    NSArray *array = [[TJDataController sharedDataController]featchChatMessage:self.chatToUserId byPage:currentPageNum];
    [_allMessagesFrame removeAllObjects];
    for (TJChatMessage *chatMessage in array) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        messageFrame.message = chatMessage;
        [_allMessagesFrame addObject:messageFrame];
    }
    [theTableView reloadData];
    [self moveTableToBottomWithAnimation:YES];
}
-(void)moveTableToBottomWithAnimation:(BOOL)animate
{
    if (_allMessagesFrame.count == 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animate];
}
#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    TJChatMessage *msg = [[TJChatMessage alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = myOwnImageUrl;
    msg.type = MessageTypeMe;
    mf.message = msg;
    [_allMessagesFrame addObject:mf];
    
    TJMessage *messageList = [[TJMessage alloc]init];
    messageList.messageId = self.chatToUserId;
    messageList.messageType = @"chatMessage";
    messageList.imageUrl = self.chatToUserImageUrl;
    messageList.messageTitle = self.title;
    messageList.messageName = nil;
    messageList.message = content;
    messageList.messageContentType = MessageTypeMe;
    [[TJDataController sharedDataController]insertLocalChatMessage:self.chatToUserId myChatMessage:msg messageList:messageList];
}

#pragma TJChatViewDelegate
-(void)sendMessage:(NSString *)messageContent
{
    // 1、增加数据源
    NSString *content = messageContent;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [theTableView reloadData];
    // 3、滚动至当前行
    [self moveTableToBottomWithAnimation:YES];
    
    [[TJDataController sharedDataController]sendChatMessageTo:self.chatToUserId chatMessage:messageContent];
}
#pragma MessageCellDelegate
-(void)goToUserInfoPage:(MessageType)messageType
{
//    UIViewController *rootViewController = [self getTheNavigationRootViewController];
//    rootViewController.hidesBottomBarWhenPushed = YES;
//    TJUserInfoViewController *userInfoViewController = [[TJUserInfoViewController alloc]init];
//    userInfoViewController.userImageUrl = theItem.userImg;
//    userInfoViewController.userName = self.title;
//    userInfoViewController.userGender = theItem.userGender;
//    userInfoViewController.uid = theItem.uid;
//    [self.navigationController pushViewController:userInfoViewController animated:YES];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    coverButton.hidden = NO;
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    
    NSDictionary *keyboardAnimationDetail = [note userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        theTableView.frame = CGRectMake(0, -ty, 320, self.view.frame.size.height + ty - 40);
    } completion:^(BOOL finished){
    }];
    [self moveTableToBottomWithAnimation:YES];
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    coverButton.hidden = YES;
    NSDictionary *keyboardAnimationDetail = [note userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        self.view.transform = CGAffineTransformIdentity;
        theTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 40);
    } completion:nil];
}
#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
