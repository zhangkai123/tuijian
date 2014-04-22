//
//  TJUserPhotoCell.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJUserPhotoCellDelegate <NSObject>

-(void)selectPhotoAtIndex:(int)photoNum;

@end
@interface TJUserPhotoCell : UITableViewCell
{
    __unsafe_unretained id<TJUserPhotoCellDelegate> delegate;
    NSMutableArray *photoUrlArray;
}
@property(nonatomic,unsafe_unretained) id<TJUserPhotoCellDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *photoUrlArray;

@end
