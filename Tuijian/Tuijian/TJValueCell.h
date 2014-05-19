//
//  TJValueCell.h
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJValueCell : UITableViewCell
{
    UIImageView *likeImageView;
    UILabel *likeNumLabel;
    UILabel *charmLabel;
}
@property(nonatomic,strong) UILabel *likeNumLabel;

-(void)setTheUserStar:(int)theUserStar;
-(void)setLikeNumber:(int)likeNum;
@end
