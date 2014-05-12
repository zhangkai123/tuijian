//
//  TJHiMessageCell.h
//  Tuijian
//
//  Created by zhang kai on 5/12/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchableImageView.h"
#import "TJSelectableLabel.h"

@protocol TJHiMessageCellDelegate <NSObject>

-(void)acceptChat:(int)rowN;
-(void)goToUserInfoPage:(int)rowN;

@end

@interface TJHiMessageCell : UITableViewCell<TJTouchableImageViewDelegate,TJSelectableLabelDelegate>
{
    TJTouchableImageView *userImageView;
    TJSelectableLabel *nameLable;
    UIButton *acceptButton;
    int rowNum;
}
@property(nonatomic,unsafe_unretained) id<TJHiMessageCellDelegate> delegate;
@property(nonatomic,assign) int rowNum;
@property(nonatomic,strong) TJTouchableImageView *userImageView;

-(void)setUserName:(NSString *)theUserName;
-(void)setButtonType:(NSString *)contentType;
@end
