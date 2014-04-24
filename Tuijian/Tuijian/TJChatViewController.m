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
#import "MessageCell.h"
#import "TJChatView.h"


@interface TJChatViewController ()<UITableViewDataSource,UITableViewDelegate,TJChatViewDelegate>
{
    NSString *myOwnImageUrl;
    UITableView *theTableView;
    NSMutableArray  *_allMessagesFrame;
    
    TJChatView *chatView;
}
@end

@implementation TJChatViewController
@synthesize chatToUserId;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(goBackToInfoPage)];
    }
    return self;
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
    
    chatView = [[TJChatView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    chatView.delegate = self;
    [self.view addSubview:chatView];
    
    TJUser *myUser = [[TJDataController sharedDataController]getMyUserInfo];
    myOwnImageUrl = myUser.profile_image_url;

//    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"]];
    NSArray *array = [[TJDataController sharedDataController]featchChatMessage:self.chatToUserId];
    
    _allMessagesFrame = [NSMutableArray array];
    NSString *previousTime = nil;
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
    for (TJChatMessage *chatMessage in array) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        
//        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = chatMessage;
        
//        previousTime = message.time;
        
        [_allMessagesFrame addObject:messageFrame];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [[TJDataController sharedDataController]insertLocalChatMessage:self.chatToUserId myChatMessage:msg];
}

#pragma TJChatViewDelegate
-(void)sendMessage:(NSString *)theMessage
{
    // 1、增加数据源
    NSString *content = theMessage;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [theTableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [[TJDataController sharedDataController]sendChatMessageTo:self.chatToUserId chatMessage:theMessage];
}

-(void)goBackToInfoPage
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate changeToInfoTab];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        theTableView.frame = CGRectMake(0, -ty, 320, self.view.frame.size.height + ty - 40);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        theTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 40);
    }];
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
