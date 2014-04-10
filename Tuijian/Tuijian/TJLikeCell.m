//
//  TJLikeCell.m
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJLikeCell.h"
#import "TJLikeUserCell.h"
#import "TJUser.h"
#import "UIImage+additions.h"

@interface TJLikeCell()<UITableViewDelegate,UITableViewDataSource,TJLikeCellDelegate>
{
    UITableView *likeTableView;
    
    UIView *bottomLineView;
}
@end

@implementation TJLikeCell
@synthesize likesArray;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundColor = UIColorFromRGB(0x242424);
        
        likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 0, 320 - 30, 50)];
        likeTableView.delegate = self;
        likeTableView.dataSource = self;
        likeTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        likeTableView.pagingEnabled = YES;
        likeTableView.showsVerticalScrollIndicator = NO;
        likeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        likeTableView.rowHeight = 50;
        [self addSubview:likeTableView];
        //after transform , should reframe the table
        likeTableView.frame = CGRectMake(30, 0, 320 - 30, 50);
        likeTableView.backgroundColor = [UIColor clearColor];

        likesArray = [[NSMutableArray alloc]init];
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 1)];
        topLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:topLineView];
        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 1, 50)];
        leftLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:leftLineView];
        UIView *rightLineView = [[UIView alloc]initWithFrame:CGRectMake(309, 0, 1, 50)];
        rightLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:rightLineView];
        bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49, 300, 1)];
        bottomLineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
        [self addSubview:bottomLineView];
        bottomLineView.hidden = YES;
        
        UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        likeImageView.image = [UIImage imageNamed:@"like.png"];
        [self addSubview:likeImageView];
    }
    return self;
}
-(void)setLikesArray:(NSMutableArray *)likesA
{
    likesArray = likesA;
    [likeTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.likesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJLikeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TJLikeUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.delegate = (id)self;
    cell.theRowNum = indexPath.row;
    TJUser *user = [self.likesArray objectAtIndex:indexPath.row];
    UIImage *placeHoder = [self getGenderPlaceHolder:user];
    __block UIImageView *weakImageView = cell.userImageView;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:user.profile_image_url]];
    [cell.userImageView setImageWithURLRequest:urlRequest placeholderImage:placeHoder
    success:^(NSURLRequest *request ,NSHTTPURLResponse *response ,UIImage *image){
        
        float radius = MAX(image.size.width, image.size.height);
        weakImageView.image = [image makeRoundCornersWithRadius:radius/2];
    }failure:^(NSURLRequest *request ,NSHTTPURLResponse *response ,NSError *error){
         
     }];
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.delegate selectUserCell:indexPath.row];
//}

-(UIImage *)getGenderPlaceHolder:(TJUser *)theUser
{
    UIImage *genderPlaceHolder = nil;
    if ([theUser.gender intValue] == 1) {
        genderPlaceHolder = [UIImage imageNamed:@"man_placeholder.png"];
    }else{
        genderPlaceHolder = [UIImage imageNamed:@"womanPlaceholder.png"];
    }
    return genderPlaceHolder;
}
-(void)setBottomLineViewHidden:(BOOL)hidden
{
    bottomLineView.hidden = hidden;
}
#pragma TJLikeUserCellDelegate
-(void)clickImageViewAtRow:(int)rowNum
{
    [self.delegate selectUserCell:rowNum];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
