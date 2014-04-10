//
//  TJLikeUserCell.h
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchableImageView.h"

@protocol TJLikeUserCellDelegate <NSObject>

-(void)clickImageViewAtRow:(int)rowNum;

@end

@interface TJLikeUserCell : UITableViewCell<TJTouchableImageViewDelegate>
{
    __unsafe_unretained id<TJLikeUserCellDelegate> delegate;
    int theRowNum;
    TJTouchableImageView *userImageView;
}
@property(nonatomic,unsafe_unretained) id<TJLikeUserCellDelegate> delegate;
@property(nonatomic,assign) int theRowNum;
@property(nonatomic,strong) TJTouchableImageView *userImageView;
@end
