//
//  TJCommentViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/14/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentViewController.h"
#import "TJItemDetailCell.h"
#import "TJLikeCell.h"
#import "TJCommentView.h"
#import "TJCommentCell.h"
#import "TJComment.h"
#import "UIImage+additions.h"
#import "TJTouchableImageView.h"
#import "TJSelectableLabel.h"
#import "TJUserInfoViewController.h"

@interface TJCommentViewController ()<UITableViewDelegate,UITableViewDataSource,TJTouchableImageViewDelegate,TJCommentViewDelegate>
{
    UITableView *detailTableView;
    int numberOfSections;
    
    TJCommentView *commentInputView;
    BOOL isWirting;
    BOOL replyStatus;
    TJUser *replyedUser;
    
    NSMutableArray *myLikesArray;
    NSMutableArray *myCommentsArray;
    NSMutableArray *myCommentHeightArray;
    
    TJLikeCell *myLikeCell;
}
@end

@implementation TJCommentViewController
//two different way to get the item information
@synthesize theItemId;
@synthesize theItem ,textHeight;

-(id)init
{
    if (self = [super init]) {
        self.title = @"推荐详情";
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

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 200, 0);
    detailTableView.contentInset = insets;

    commentInputView = [[TJCommentView alloc]initWithFrame:self.view.frame];
    commentInputView.delegate = self;
    commentInputView.hidden = YES;
    [self.view addSubview:commentInputView];
    
    myLikesArray = [[NSMutableArray alloc]init];
    myCommentsArray = [[NSMutableArray alloc]init];
    myCommentHeightArray = [[NSMutableArray alloc]init];
    numberOfSections = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    __weak UITableView *weakDetailTableView = detailTableView;
    __block NSMutableArray *weakMyLikesArray = myLikesArray;
    __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
    __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
    if (self.theItem != nil) {
        //get item info from pre vie controller
        [[TJDataController sharedDataController]getLikesComments:self.theItem.itemId likes:^(NSArray *likesArray){
            numberOfSections = 3;
            [weakMyLikesArray removeAllObjects];
            [weakMyLikesArray addObjectsFromArray:likesArray];
        }comments:^(NSArray *commentsArray){
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
//        __block TJItem *weakItem = self.theItem;
//        __block float weakRecommendHeight = self.textHeight;
        __block NSMutableArray *weakMyLikesArray = myLikesArray;
        __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
        __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
        [[TJDataController sharedDataController]getItemWholeInfo:self.theItemId theItem:^(TJItem *item){
            numberOfSections = 3;
            NSString *recommendTex = item.recommendReason;
            CGRect expectedLabelRect = [recommendTex boundingRectWithSize:CGSizeMake(TJ_RECOMMEND_WIDTH, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TJ_RECOMMEND_SIZE]} context:nil];
             self.textHeight = expectedLabelRect.size.height;
            self.theItem = item;
        }likesArray:^(NSArray *likesArray){
            [weakMyLikesArray removeAllObjects];
            [weakMyLikesArray addObjectsFromArray:likesArray];
        }comments:^(NSArray *commentsArray){
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
    [myCommentHeightArray insertObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height] atIndex:0];
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
    }else if(section == 1){
        if ([myLikesArray count] != 0) {
            rowNum = 1;
        }
    }else{
        rowNum = (NSInteger)[myCommentsArray count];
    }
    return rowNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = textHeight + 325 + 40 + 30;
    }else if (indexPath.section == 1){
        if ([myLikesArray count] != 0) {
            rowHeight = 50;
        }
    }else{
        rowHeight = [[myCommentHeightArray objectAtIndex:indexPath.row] floatValue] + 35 + 5;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cell) {
            cell = [[TJItemDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        [(TJItemDetailCell *)cell setItemId:theItem.itemId];
        [[(TJItemDetailCell *)cell titleLabel] setText:theItem.title];
        [[(TJItemDetailCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [(TJItemDetailCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
        [(TJItemDetailCell *)cell setLikeButtonColor:theItem.hasLiked];
        [(TJItemDetailCell *)cell setDelegate:(id)self];

    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cell) {
            cell = [[TJLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        if ([myCommentsArray count] == 0) {
            [(TJLikeCell *)cell setBottomLineViewHidden:NO];
        }else{
            [(TJLikeCell *)cell setBottomLineViewHidden:YES];
        }
        [(TJLikeCell *)cell setLikesArray:myLikesArray];
        [(TJLikeCell *)cell setDelegate:(id)self];
        myLikeCell = (TJLikeCell *)cell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        float  commentHeight = [[myCommentHeightArray objectAtIndex:indexPath.row]floatValue];
        if (indexPath.row != 0) {
            [[(TJCommentCell *)cell commentImageView]setImage:nil];
            [(TJCommentCell *)cell setLineWidthAndHeight:265 sideLineHeight:commentHeight + 40];
        }else{
            [[(TJCommentCell *)cell commentImageView]setImage:[UIImage imageNamed:@"comment.png"]];
            [(TJCommentCell *)cell setLineWidthAndHeight:300 sideLineHeight:commentHeight + 40];
        }
        if (indexPath.row == ([myCommentsArray count] - 1)) {
            [(TJCommentCell *)cell setBottomLineViewHidden:NO];
        }else{
            [(TJCommentCell *)cell setBottomLineViewHidden:YES];
        }
        TJComment *comment = [myCommentsArray objectAtIndex:indexPath.row];
        __block UIImageView *weakImageView = [(TJCommentCell *)cell userImageView];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
        [[(TJCommentCell *)cell userImageView] setImageWithURLRequest:urlRequest
                                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                               success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
            
                                                    float radius = MAX(image.size.width, image.size.height);
                                                    weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                               }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
            
                                               }];
        [[(TJCommentCell *)cell nameLable]setText:comment.user.name];
        [[(TJCommentCell *)cell commentLable]setText:comment.info];
        [(TJCommentCell *)cell setDelegate:(id)self];
        [(TJCommentCell *)cell setRowNum:indexPath.row];
        
        [(TJCommentCell *)cell setCommentHeight:commentHeight];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        TJCommentCell *cell = (TJCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showSelectedAnimation];
        TJComment *comment = [myCommentsArray objectAtIndex:indexPath.row];
        [self replyCommentTo:comment.user];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float headerHeight = 0;
    if (section == 0) {
        headerHeight = 50;
    }
    return headerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = nil;
    if (section == 0) {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        TJTouchableImageView *userImageView = [[TJTouchableImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        userImageView.sectionNum = section;
        userImageView.delegate = self;
        userImageView.clipsToBounds = YES;
        [backView addSubview:userImageView];
        userImageView.layer.cornerRadius = 40 / 2.0;
        
        CGRect expectedLabelRect = [theItem.userName boundingRectWithSize:CGSizeMake(0, 20)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        float nameLabelWidth = expectedLabelRect.size.width;
        if (nameLabelWidth > 150) {
            nameLabelWidth = 150;
        }
        TJSelectableLabel *nameLabel = [[TJSelectableLabel alloc]initWithFrameAndTextColor:CGRectMake(60, 10, nameLabelWidth, 20) andTextColor:UIColorFromRGB(0x336699)];
        nameLabel.delegate = (id)self;
        nameLabel.theRowNum = section;
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [backView addSubview:nameLabel];
        
        UIImageView *genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, 13, 13)];
        [backView addSubview:genderImageView];
        
        UIImage *genderPlaceHolder = nil;
        if ([theItem.userGender intValue] == 1) {
            [genderImageView setImage:[UIImage imageNamed:@"male.png"]];
            genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
        }else{
            [genderImageView setImage:[UIImage imageNamed:@"female.png"]];
            genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
        }
        [userImageView setImageWithURL:[NSURL URLWithString:theItem.userImg] placeholderImage:genderPlaceHolder];
        [nameLabel setText:theItem.userName];
        
        [backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.95]];
    }
    return backView;
}
#pragma TJTouchableImageViewDelegate
-(void)selectUserImageView:(int)sectionNum
{
    [self goToUserInformationPage:theItem.userImg userName:theItem.userName userGender:theItem.userGender userId:theItem.uid];
}
#pragma TJSelectableLabelDelegate
-(void)selectLabel:(int)rowNum
{
    [self goToUserInformationPage:theItem.userImg userName:theItem.userName userGender:theItem.userGender userId:theItem.uid];
}
#pragma TJLikeCellDelegate
-(void)selectUserCell:(int)rowNum
{
    TJUser *user = [myLikesArray objectAtIndex:rowNum];
    [self goToUserInformationPage:user.profile_image_url userName:user.name userGender:user.gender userId:user.myUserId];
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
    theItem.hasLiked = !theItem.hasLiked;
    hasL(theItem.hasLiked);
    TJUser *myUserInfo = [[TJDataController sharedDataController] getMyWholeUserInfo];
    if (theItem.hasLiked) {
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] - 1];
        [myLikesArray insertObject:myUserInfo atIndex:0];
        [myLikeCell setLikesArray:myLikesArray];
    }else{
        theItem.likeNum = [NSString stringWithFormat:@"%d",[theItem.likeNum intValue] + 1];
        TJUser *user = [self findUserInLikesArray:myUserInfo.myUserId];
        if (user != nil) {
            [myLikesArray removeObject:user];
            [myLikeCell setLikesArray:myLikesArray];
        }
    }
    [detailTableView reloadData];
    
    __block TJItem *weakItem = theItem;
    [[TJDataController sharedDataController]saveLike:itemId success:^(BOOL hasLiked){
        if (hasLiked) {
             [[TJDataController sharedDataController]sendLike:weakItem];
        }
    }failure:^(NSError *error){
        
    }];
}
-(TJUser *)findUserInLikesArray:(NSString *)userId
{
    for (int i = 0; i < [myLikesArray count]; i++) {
        TJUser *user = [myLikesArray objectAtIndex:i];
        if ([user.myUserId isEqualToString:userId]) {
            return user;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
