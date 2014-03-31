//
//  TJItemMessageCell.h
//  Tuijian
//
//  Created by zhang kai on 3/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchableImageView.h"

@protocol TJItemMessageCellDelegate <NSObject>

-(void)selectCommentUserImage:(int)rowNum;

@end
@interface TJItemMessageCell : UITableViewCell<TJTouchableImageViewDelegate>
{
    TJTouchableImageView *userImageView;
    UILabel *nameLable;
    UILabel *commentLable;
    __unsafe_unretained id<TJItemMessageCellDelegate> delegate;
    int rowNum;
}
@property(nonatomic,strong) TJTouchableImageView *userImageView;
@property(nonatomic,strong) UILabel *nameLable;
@property(nonatomic,strong) UILabel *commentLable;
@property(nonatomic,assign) float commentHeight;

@property(nonatomic,unsafe_unretained) id<TJItemMessageCellDelegate> delegate;
@property(nonatomic,assign) int rowNum;

@end
