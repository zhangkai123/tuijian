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
#import "YFInputBar.h"
#import "TJCommentCell.h"
#import "TJComment.h"
#import "UIImage+additions.h"

@interface TJCommentViewController ()<UITableViewDelegate,UITableViewDataSource,YFInputBarDelegate>
{
    UITableView *detailTableView;
    YFInputBar *commentInputBar;
    BOOL isWirting;
    
    NSMutableArray *myLikesArray;
    NSMutableArray *myCommentsArray;
    NSMutableArray *myCommentHeightArray;
}
@end

@implementation TJCommentViewController
@synthesize theItem ,textHeight;

-(id)init
{
    if (self = [super init]) {
        self.title = @"详情";
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
//    [detailTableView setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
    detailTableView.rowHeight = 500;
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    detailTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
//    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailTableView];

    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 50, 0);
    detailTableView.contentInset = insets;
    
    commentInputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds), 320, 44)];
    commentInputBar.backgroundColor = [UIColor lightGrayColor];
    commentInputBar.delegate = self;
    commentInputBar.clearInputWhenSend = YES;
    [self.view addSubview:commentInputBar];
    
    myLikesArray = [[NSMutableArray alloc]init];
    myCommentsArray = [[NSMutableArray alloc]init];
    myCommentHeightArray = [[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    __block UITableView *weakDetailTableView = detailTableView;
    __block NSMutableArray *weakMyLikesArray = myLikesArray;
    __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
    __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
    [[TJDataController sharedDataController]getLikesComments:self.theItem.itemId likes:^(NSArray *likesArray){
        [weakMyLikesArray removeAllObjects];
        [weakMyLikesArray addObjectsFromArray:likesArray];
    }comments:^(NSArray *commentsArray){
        for (int i = 0; i < [commentsArray count]; i++) {
            TJComment *comment = [commentsArray objectAtIndex:i];
            CGRect expectedLabelRect = [comment.info boundingRectWithSize:CGSizeMake(250, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
            [weakmyCommentHeightArray addObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height]];

        }
        [weakMyCommentsArray removeAllObjects];
        [weakMyCommentsArray addObjectsFromArray:commentsArray];
        [weakDetailTableView reloadData];
    }failure:^(NSError *error){
        
    }];
    [super viewWillAppear:animated];
}
-(void)writeComment
{
    if (isWirting) {
        [self exitWriteStatus];
    }else{
        [self enterWriteStatus];
    }
}
-(void)enterWriteStatus
{
    isWirting = YES;
    [commentInputBar.textField becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"writing.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
}
-(void)exitWriteStatus
{
    isWirting = NO;
    [commentInputBar.textField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"write.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
}
#pragma YFInputBar delegate
-(void)inputBar:(YFInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    __block TJItem *weakItem = self.theItem;
    __block NSString *commentInfo = str;
    __block UITableView *weakDetailTableView = detailTableView;
    __block NSMutableArray *weakMyCommentsArray = myCommentsArray;
    __block NSMutableArray *weakmyCommentHeightArray = myCommentHeightArray;
    [[TJDataController sharedDataController]saveComment:self.theItem.itemId commentInfo:str success:^(BOOL hasCommented){
        if (hasCommented) {
           TJComment *comment = [[TJDataController sharedDataController] getMyOwnCommentItem:commentInfo];
            [weakMyCommentsArray insertObject:comment atIndex:0];
            CGRect expectedLabelRect = [comment.info boundingRectWithSize:CGSizeMake(250, 0)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            [weakmyCommentHeightArray insertObject:[NSString stringWithFormat:@"%f",expectedLabelRect.size.height] atIndex:0];
            [weakDetailTableView reloadData];
            [[TJDataController sharedDataController]sendComment:weakItem comment:commentInfo];
        }
    }failure:^(NSError *error){
        
    }];
    [self exitWriteStatus];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        isWirting = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"write.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(writeComment)];
        [((UIView*)obj) resignFirstResponder];
    }];
}

#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowNum = 0;
    if ((section == 0) || (section == 1)) {
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
        rowHeight = textHeight + 325 + 40 + 30;
    }else if (indexPath.section == 1){
        rowHeight = 50;
    }else{
        rowHeight = [[myCommentHeightArray objectAtIndex:indexPath.row] floatValue] + 30 + 5;
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
//        [(TJItemDetailCell *)cell setUserId:theItem.uid];
        [[(TJItemDetailCell *)cell titleLabel] setText:theItem.title];
        [[(TJItemDetailCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
        [(TJItemDetailCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
        [(TJItemDetailCell *)cell setLikeButtonColor:theItem.hasLiked];
        [(TJItemDetailCell *)cell setDelegate:(id)self];

    }else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellTwo"];
        if (!cell) {
            cell = [[TJLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTwo"];
        }
        [(TJLikeCell *)cell setLikesArray:myLikesArray];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellThree"];
        if (!cell) {
            cell = [[TJCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellThree"];
        }
        TJComment *comment = [myCommentsArray objectAtIndex:indexPath.row];
        __block UIImageView *weakImageView = [(TJCommentCell *)cell userImageView];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
        [[(TJCommentCell *)cell userImageView] setImageWithURLRequest:urlRequest
                                               placeholderImage:[UIImage imageNamed:@"photo.png"]
                                               success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
            
                                                    float radius = MAX(image.size.width, image.size.height);
                                                    weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                               }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
            
                                               }];
        [[(TJCommentCell *)cell nameLable]setText:comment.user.name];
        [[(TJCommentCell *)cell commentLable]setText:comment.info];
        
        float  commentHeight = [[myCommentHeightArray objectAtIndex:indexPath.row]floatValue];
        [(TJCommentCell *)cell setCommentHeight:commentHeight];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        userImageView.clipsToBounds = YES;
        [backView addSubview:userImageView];
        userImageView.layer.cornerRadius = 40 / 2.0;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
        nameLabel.textColor = [UIColor blackColor];
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
#pragma TJItemCellDelegate
-(void)likeItem:(NSString *)itemId liked:(void (^)(BOOL Liked))hasL
{
    __block TJItem *item = theItem;
    [[TJDataController sharedDataController]saveLike:itemId success:^(BOOL hasLiked){
        hasL(hasLiked);
        item.hasLiked = hasLiked;
    }failure:^(NSError *error){
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
