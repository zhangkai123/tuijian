//
//  TJLikeCell.h
//  Tuijian
//
//  Created by zhang kai on 3/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJLikeCellDelegate <NSObject>

-(void)selectUserCell:(int)rowNum;

@end

@interface TJLikeCell : UITableViewCell
{
    NSMutableArray *likesArray;
    __unsafe_unretained id<TJLikeCellDelegate> delegate;
}
@property(nonatomic,strong) NSMutableArray *likesArray;
@property(nonatomic,unsafe_unretained) id<TJLikeCellDelegate> delegate;

@end
