//
//  TJCommentViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/14/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJCommentViewController.h"
#import "TJItemCell.h"
#import "YFInputBar.h"

@interface TJCommentViewController ()<UITableViewDelegate,UITableViewDataSource,YFInputBarDelegate>
{
    UITableView *detailTableView;
    YFInputBar *commentInputBar;
    BOOL isWirting;
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
    //    [itemTableView setBackgroundColor:[UIColor clearColor]];
    //    [itemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    detailTableView.rowHeight = 500;
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    detailTableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 50);
    [self.view addSubview:detailTableView];

    commentInputBar = [[YFInputBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY([UIScreen mainScreen].bounds), 320, 44)];
    commentInputBar.backgroundColor = [UIColor lightGrayColor];
    commentInputBar.delegate = self;
    commentInputBar.clearInputWhenSend = YES;
    [self.view addSubview:commentInputBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[TJDataController sharedDataController]getLikesComments:self.theItem.itemId likes:^(NSArray *likesArray){
        
    }comments:^(NSArray *commentsArray){
        
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
    NSLog(@"%@",str);
    [[TJDataController sharedDataController]saveComment:self.theItem.itemId commentInfo:str success:^(BOOL hasCommented){
        
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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if (indexPath.section == 0) {
        rowHeight = textHeight + 355 + 40;
    }else{
        rowHeight = 50;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellOne"];
        if (!cell) {
            cell = [[TJItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOne"];
        }
        
        [[(TJItemCell *)cell itemImageView] setImageWithURL:[NSURL URLWithString:theItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo.png"]];
        [(TJItemCell *)cell setRecommendInfoAndHeight:theItem.recommendReason textHeight:textHeight];
        [(TJItemCell *)cell likeNumLabel].text = theItem.likeNum;
        [(TJItemCell *)cell commentNumLabel].text = theItem.commentNum;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    }
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
        
        [backView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    }
    return backView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
