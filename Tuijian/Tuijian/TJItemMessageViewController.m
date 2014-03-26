//
//  TJItemMessageViewController.m
//  Tuijian
//
//  Created by zhang kai on 3/26/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJItemMessageViewController.h"
#import "TJCommentCell.h"
#import "UIImage+additions.h"

@interface TJItemMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *itemMessageTableView;
    NSMutableArray *itemMessageArray;
    NSMutableArray *textHeightArray;
}
@end

@implementation TJItemMessageViewController
@synthesize messageId;

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
}
-(void)viewWillAppear:(BOOL)animated
{
    [[TJDataController sharedDataController]featchMessage:@"itemMessage" messageId:self.messageId];
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
    return textHeight + 40 + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TJComment *comment = [itemMessageArray objectAtIndex:indexPath.row];
    __block UIImageView *weakImageView = [(TJCommentCell *)cell userImageView];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:comment.user.profile_image_url]];
    [[cell userImageView] setImageWithURLRequest:urlRequest
                                                 placeholderImage:[UIImage imageNamed:@"photo.png"]
                                                          success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
                                                              
                                                              float radius = MAX(image.size.width, image.size.height);
                                                              weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
                                                          }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
                                                              
                                                          }];
    [[cell nameLable]setText:comment.user.name];
    [[cell commentLable]setText:comment.info];
    
    float  commentHeight = [[textHeightArray objectAtIndex:indexPath.row]floatValue];
    [cell setCommentHeight:commentHeight];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
