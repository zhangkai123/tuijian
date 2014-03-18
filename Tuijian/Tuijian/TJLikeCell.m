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

@interface TJLikeCell()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *likeTableView;
}
@end

@implementation TJLikeCell
@synthesize likesArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        likeTableView.delegate = self;
        likeTableView.dataSource = self;
        likeTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        likeTableView.pagingEnabled = YES;
        likeTableView.showsVerticalScrollIndicator = NO;
        likeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        likeTableView.rowHeight = 50;
        [self addSubview:likeTableView];
        //after transform , should reframe the table
        likeTableView.frame = CGRectMake(0, 0, 320, 50);
        likeTableView.backgroundColor = [UIColor clearColor];

        likesArray = [[NSMutableArray alloc]init];
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
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    TJUser *user = [self.likesArray objectAtIndex:indexPath.row];
    UIImage *placeHoder = [self getGenderPlaceHolder:user];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:placeHoder];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

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
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
