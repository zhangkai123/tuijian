//
//  TJCommentCell.h
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchableImageView.h"
#import "TJSelectableLabel.h"

@protocol TJCommentCellDelegate <NSObject>

-(void)selectCommentUserImage:(int)rowNum;
-(void)selectCommentUserNameLabel:(int)rowNum;

@end

@interface TJCommentCell : UITableViewCell<TJTouchableImageViewDelegate,TJSelectableLabelDelegate>
{
    TJTouchableImageView *userImageView;
    TJSelectableLabel *nameLable;
    UILabel *commentLable;
    __unsafe_unretained id<TJCommentCellDelegate> delegate;
    int rowNum;
}

@property(nonatomic,strong) TJTouchableImageView *userImageView;
@property(nonatomic,strong) UILabel *commentLable;
@property(nonatomic,assign) float commentHeight;

@property(nonatomic,unsafe_unretained) id<TJCommentCellDelegate> delegate;
@property(nonatomic,assign) int rowNum;

-(void)setUserName:(NSString *)theName;
@end
