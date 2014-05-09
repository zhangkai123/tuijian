//
//  TJCommentViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/14/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentViewController.h"
#import "TJItemDetailCell.h"
#import "TJCommentView.h"
#import "TJCommentCell.h"
#import "TJComment.h"
#import "UIImage+additions.h"
#import "TJUserInfoViewController.h"

@interface TJCommentViewController ()<UITableViewDelegate,UITableViewDataSource,TJCommentViewDelegate>
{
    UITableView *detailTableView;
    int numberOfSections;
    
    TJCommentView *commentInputView;
    BOOL isWirting;
    BOOL replyStatus;
    TJUser *replyedUser;
    
    NSMutableArray *myCommentsArray;
    NSMutableArray *myCommentHeightArray;
}
@end

@implementation TJCommentViewController
//two different way to get the item information
@synthesize theItemId;
@synthesize theItem ,textHeight;

-(id)init
{
    if (self = [super init]) {
        self.title = @"美食详情";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"write.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    detailTableView.rowHeight = 500;
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    detailTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailTableView];
    detailTableView.backgroundColor = UIColorFromRGB(0xF2F2F2);

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 200, 0);
    detailTableView.contentInset = insets;

    commentInputView = [[TJCommentView alloc]initWithFrame:self.view.frame];
    commentInputView.delegate = self;
    commentInputView.hidden = YES;
    [self.view addSubview:commentInputView];
    
    myCommentsArray = [[NSMutableArray alloc]init];
    myCommentHeightArray = [[NSMutableArray alloc]init];
    numberOfSections = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self startActivityIndicator];
    __weak UITableView *weakDetailTableView = detailTableView;
    __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
    __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
    if (self.theItem != nil) {
        //get item info from pre vie controller
        [[TJDataController sharedDataController]getLikesComments:self.theItem.itemId likes:^(NSArray *likesArray){

        }comments:^(NSArray *commentsArray){
            [activityIndicator stopAnimating];
            numberOfSections = 2;
            [weakmyCommentHeightArray removeAllObjects];
            for (int i = 0; i < [commentsArray count]; i++) {
                TJComment *comment = [commentsArray objectAtIndex:i];
                CGRect expectedLabelRect = [comment.info boundingRectWithSize:CGSizeMake(TJ_COMMENT_LABEL_WIDTH, 0)
                                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_COMMENT_SIZE]} context:nil];
                [weakmyCommentHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
                
            }
            [weakMyCommentsArray removeAllObjects];
            [weakMyCommentsArray addObjectsFromArray:commentsArray];
            UITableView *strongTableView = weakDetailTableView;
            if (strongTableView != nil) {
                [strongTableView reloadData];
            }
        }failure:^(NSError *error){
            
        }];
    }else{
        //get item info from server
        __weak UITableView *weakDetailTableView = detailTableView;
        __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
        __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
        [[TJDataController sharedDataController]getItemWholeInfo:self.theItemId theItem:^(TJItem *item){
            [activityIndicator stopAnimating];
            numberOfSections = 2;
            NSString *recommendTex = item.recommendReason;
            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(TJ_RECOMMEND_WIDTH, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]} context:nil];
             self.textHeight = expectedLabelRect.size.height;
            self.theItem = item;
        }likesArray:^(NSArray *likesArray){

        }comments:^(NSArray *commentsArray){
            [weakmyCommentHeightArray removeAllObjects];
            for (int i = 0; i < [commentsArray count]; i++) {
                TJComment *comment = [commentsArray objectAtIndex:i];
                CGRect expectedLabelRect = [comment.info boundingRectWithSize:CGSizeMake(TJ_COMMENT_LABEL_WIDTH, 0)
                                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_COMMENT_SIZE]} context:nil];
                [weakmyCommentHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];
                
            }
            [weakMyCommentsArray removeAllObjects];
            [weakMyCommentsArray addObjectsFromArray:commentsArray];
            UITableView *strongTableView = weakDetailTableView;
            if (strongTableView != nil) {
                [strongTableView reloadData];
            }
        }failed:^(NSError *error){
            
        }];
    }
    [super viewWillAppear:animated];
}
-(void)replyCommentTo:(TJUser *)theUser
{
    replyStatus = YES;
    replyedUser = theUser;
    [self enterOrExitWrite];
}
-(void)writeComment
{
    replyStatus = NO;
    [self enterOrExitWrite];
}
-(void)enterOrExitWrite
{
    if (isWirting) {
        [self exitWriteStatus];
    }else{
        [self enterWriteStatus];
    }
}
-(void)enterWriteStatus
{
    if (replyStatus) {
        [commentInputView showReplyCommentPlaceHolder:replyedUser.name];
    }else{
        [commentInputView showCommentPlaceHolder];
    }
    isWirting = YES;
    commentInputView.hidden = NO;
    [commentInputView showKeyboard:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"writing.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
}
-(void)exitWriteStatus
{
    isWirting = NO;
    commentInputView.hidden = YES;
    [commentInputView showKeyboard:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"write.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
}
#pragma TJCommentViewDelegate
-(void)exitInputMode
{
    [self exitWriteStatus];
}
-(void)sendComment:(NSString *)theComment
{
    __block NSString *commentInfo = theComment;
    if (replyStatus) {
        theComment = [NSString stringWithFormat:@"回复%@:%@",replyedUser.name,theComment];
    }
    TJComment *comment = [[TJDataController sharedDataController] getMyOwnCommentItem:theComment];
    [myCommentsArray addObject:comment];
    CGRect expectedLabelRect = [comment.info boundingRectWithSize:CGSizeMake(TJ_COMMENT_LABEL_WIDTH, 0)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_COMMENT_SIZE]} context:nil];
    [myCommentHeightArray insertObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height] atIndex:[myCommentHeightArray count]];
    [detailTableView reloadData];
    theItem.commentNum = [NSString stringWithFormat:@"%d",[theItem.commentNum intValue] + 1];

    __block TJItem *weakItem = self.theItem;
    [[TJDataController sharedDataController]saveComment:self.theItem.itemId commentInfo:theComment success:^(BOOL hasCommented){
        if (hasCommented) {
            if (replyStatus) {
                [[TJDataController sharedDataController]replyComment:replyedUser theItem:weakItem comment:commentInfo];
            }else{
                [[TJDataController sharedDataController]sendComment:weakItem comment:commentInfo];
            }
        }
    }failure:^(NSError *error){
        
    }];
    [self exitWriteStatus];
    [self showHUDAfterComment];
}
- (void)showHUDAfterComment {
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
    if (replyStatus) {
        hud.labelText = @"回复成功";
    }else{
        hud.labelText = @"评论成功";
    }
	hud.margin = 10.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1];
}

#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return numberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowNum = 0;
    if (section == 0) {
        rowNum = 1;
    }else{
        rowNum = (NSInteger)[myCommentsArray count];
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = textHeight + 165 + 40 + 22 + 50;
    }else{
        rowHeight = [[myCommentHeightArray objectAtIndex:indexPath.row] floatValue] + 31;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        TJItemDetailCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cellOne) {
            cellOne = [[TJItemDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        [cellOne setItemId:theItem.itemId];
        
        UIImage *genderPlaceHolder = nil;
        if ([theItem.userGender isEqualToString:@"男"] || [theItem.userGender isEqualToString:@"m"] || ([theItem.userGender intValue] == 1)) {
            [cellOne.genderImageView setImage:[UIImage imageNamed:@"male.png"]];
            genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
        }else{
            [cellOne.genderImageView setImage:[UIImage imageNamed:@"female.png"]];
            genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
        }
        __block UIImageView *weakImageView = cellOne.userImageView;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:theItem.userImg]];
        [cellOne.userImageView setImageWithURLRequest:urlRequest
                                  placeholderImage:genderPlaceHolder
                                           success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                               
                                               float radius = MAX(image.size.width, image.size.height);
                                               weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                           }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                               
                                           }];
        CGRect expectedLabelRect = [theItem.userName boundingRectWithSize:CGSizeMake(0, 20)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        float nameLabelWidth = expectedLabelRect.size.width;
        if (nameLabelWidth > 150) {
            nameLabelWidth = 150;
        }
        [cellOne.nameLabel setText:theItem.userName];
        
        cellOne.likeNumLabel.text = theItem.likeNum;
        cellOne.commentNumLabel.text = theItem.commentNum;
        [cellOne.itemImageView setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [cellOne setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
        [cellOne setLikeButtonColor:theItem.hasLiked];
        [cellOne setDelegate:(id)self];
        
        cell = cellOne;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        float  commentHeight = [[myCommentHeightArray objectAtIndex:indexPath.row]floatValue];
        TJComment *comment = [myCommentsArray objectAtIndex:indexPath.row];
        UIImage *genderPlaceHolder = nil;
        if ([comment.user.gender isEqualToString:@"男"] || [comment.user.gender isEqualToString:@"m"] || ([comment.user.gender intValue] == 1)) {
            genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
        }else{
            genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
        }
        __block UIImageView *weakImageView = [(TJCommentCell *)cell userImageView];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
        [[(TJCommentCell *)cell userImageView] setImageWithURLRequest:urlRequest
                                               placeholderImage:genderPlaceHolder
                                               success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
            
                                                    float radius = MAX(image.size.width, image.size.height);
                                                    weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                               }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
            
                                               }];
        [(TJCommentCell *)cell setUserName:comment.user.name];
        [[(TJCommentCell *)cell commentLable]setText:comment.info];
        [(TJCommentCell *)cell setDelegate:(id)self];
        [(TJCommentCell *)cell setRowNum:indexPath.row];
        
        [(TJCommentCell *)cell setCommentHeight:commentHeight];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TJComment *comment = [myCommentsArray objectAtIndex:indexPath.row];
        [self replyCommentTo:comment.user];
    }
}
#pragma TJCommentCellDelegate
-(void)selectCommentUserImage:(int)rowNum
{
    TJComment *comment = [myCommentsArray objectAtIndex:rowNum];
    [self goToUserInformationPage:comment.user.profile_image_url userName:comment.user.name userGender:comment.user.gender userId:comment.user.myUserId];
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
}
#pragma TJItemCellDelegate
-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL
{
    if (theItem.hasLiked) {
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] - 1];
    }else{
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] + 1];
    }
    theItem.hasLiked = !theItem.hasLiked;
    hasL(theItem.hasLiked);
    
    __block TJItem *weakItem = theItem;
    [[TJDataController sharedDataController]saveLike:itemId success:^(BOOL hasLiked){
        if (hasLiked) {
             [[TJDataController sharedDataController]sendLike:weakItem];
        }
    }failure:^(NSError *error){
        
    }];
}
-(void)goToUserInformationPgae:(int)rowNum
{
    [self goToUserInformationPage:theItem.userImg userName:theItem.userName userGender:theItem.userGender userId:theItem.uid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
