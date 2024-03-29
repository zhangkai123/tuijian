//
//  TJItemMessageCell.h
//  Tuijian
//
//  Created by zhang kai on 3/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchableImageView.h"
#import "TJSelectableLabel.h"
#import "TJTouchablePhotoView.h"

@protocol TJItemMessageCellDelegate <NSObject>

-(void)selectCommentUserImage:(int)rowNum;
-(void)selectItemImage:(int)rowNum;

@end
@interface TJItemMessageCell : UITableViewCell<TJTouchableImageViewDelegate,TJSelectableLabelDelegate,TJTouchablePhotoViewDelegate>
{
    TJTouchableImageView *userImageView;
    TJSelectableLabel *nameLable;
    UILabel *commentLable;
    TJTouchablePhotoView *itemImageView;
    __unsafe_unretained id<TJItemMessageCellDelegate> delegate;
    int rowNum;
}
@property(nonatomic,strong) TJTouchableImageView *userImageView;
@property(nonatomic,strong) UILabel *commentLable;
@property(nonatomic,strong) TJTouchablePhotoView *itemImageView;
@property(nonatomic,assign) float commentHeight;

@property(nonatomic,unsafe_unretained) id<TJItemMessageCellDelegate> delegate;
@property(nonatomic,assign) int rowNum;

-(void)setUserName:(NSString *)theUserName;
@end
