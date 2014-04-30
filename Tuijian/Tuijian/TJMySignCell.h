//
//  TJMoodCell.h
//  Tuijian
//
//  Created by zhang kai on 4/25/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMySignCellDelegate <NSObject>

-(void)haveClickedSignCell;

@end

@interface TJMySignCell : UITableViewCell
{
    __unsafe_unretained id<TJMySignCellDelegate> delegate;
    UILabel *signLabel;
}
@property(nonatomic,unsafe_unretained) id<TJMySignCellDelegate> delegate;
@property(nonatomic,strong) UILabel *signLabel;
@end
