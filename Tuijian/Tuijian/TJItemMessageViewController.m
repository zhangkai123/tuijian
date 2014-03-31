//
//  TJItemMessageViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/26/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemMessageViewController.h"
//#import "TJCommentCell.h"
#import "TJItemMessageCell.h"
#import "UIImage+additions.h"
#import "TJItemMessage.h"
#import "TJUserInfoViewController.h"

@interface TJItemMessageViewController ()<UITableViewDataSource,UITableViewDelegate,TJItemMessageCellDelegate>
{
    UITableView *itemMessageTableView;
    NSMutableArray *itemMessageArray;
    NSMutableArray *textHeightArray;
}
@end

@implementation TJItemMessageViewController
@synthesize messageId;

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
-(id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    itemMessageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    //    [itemTableView setBackgroundColor:[UIColor clearColor]];
    //    [itemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    itemMessageTableView.dataSource = self;
    itemMessageTableView.delegate = self;
    [self.view addSubview:itemMessageTableView];
    
    itemMessageArray = [[NSMutableArray alloc]init];
    textHeightArray = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recieveMessage) name:TJ_INFO_VIEWCONTROLLER_NOTIFICATION object:nil];
}
-(void)recieveMessage
{
    NSArray *mArray = [[TJDataController sharedDataController]featchItemMessage:self.messageId];
    [itemMessageArray removeAllObjects];
    [itemMessageArray addObjectsFromArray:mArray];
    for (int i = 0; i < [itemMessageArray count]; i++) {
        TJItemMessage *itemMessage = [itemMessageArray objectAtIndex:i];
        CGRect expectedLabelRect = [itemMessage.message boundingRectWithSize:CGSizeMake(TJ_ITEM_MESSAGE_WIDTH, 0)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_ITEM_MESSAGE_SIZE]} context:nil];
        [textHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
    }
    [itemMessageTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSArray *mArray = [[TJDataController sharedDataController]featchItemMessage:self.messageId];
    [itemMessageArray addObjectsFromArray:mArray];
    for (int i = 0; i < [itemMessageArray count]; i++) {
        TJItemMessage *itemMessage = [itemMessageArray objectAtIndex:i];
        CGRect expectedLabelRect = [itemMessage.message boundingRectWithSize:CGSizeMake(TJ_ITEM_MESSAGE_WIDTH, 0)
                                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_ITEM_MESSAGE_SIZE]} context:nil];
        [textHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
    }
    [super viewWillAppear:animated];
}
#pragma uitableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemMessageArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float textHeight = [[textHeightArray objectAtIndex:indexPath.row] floatValue];
    return textHeight + 30 + 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJItemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJItemMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TJItemMessage *itemMessage = [itemMessageArray objectAtIndex:indexPath.row];
    __block UIImageView *weakImageView = [cell userImageView];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:itemMessage.profileImageUrl]];
    [[cell userImageView] setImageWithURLRequest:urlRequest
                                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                                          success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                                              
                                                              float radius = MAX(image.size.width, image.size.height);
                                                              weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                                          }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                                              
                                                          }];
    [[cell nameLable]setText:itemMessage.userName];
    NSString *commentMessage = nil;
    if ([itemMessage.message isEqualToString:@"赞"]) {
        commentMessage = [NSString stringWithFormat:@"给了你一个赞！"];
    }else{
        commentMessage = itemMessage.message;
    }
    [[cell commentLable]setText:commentMessage];
    cell.delegate = (id)self;
    cell.rowNum = indexPath.row;
    
    float  commentHeight = [[textHeightArray objectAtIndex:indexPath.row]floatValue];
    [cell setCommentHeight:commentHeight];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma TJCommentCellDelegate
-(void)selectCommentUserImage:(int)rowNum
{
    TJItemMessage *itemMessage = [itemMessageArray objectAtIndex:rowNum];
    [self goToUserInformationPage:itemMessage.profileImageUrl userName:itemMessage.userName userGender:itemMessage.userGender userId:itemMessage.uid];
}
-(void)goToUserInformationPage:(NSString *)userImage userName:(NSString *)userN userGender:(NSString *)userG userId:(NSString *)uid
{
    self.hidesBottomBarWhenPushed = YES;
    TJUserInfoViewController *userInfoViewController = [[TJUserInfoViewController alloc]init];
    userInfoViewController.userImageUrl = userImage;
    userInfoViewController.userName = userN;
    userInfoViewController.userGender = userG;
    userInfoViewController.uid = uid;
    [self.navigationController pushViewController:userInfoViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
