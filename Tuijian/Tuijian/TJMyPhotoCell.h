//
//  TJMyPhotoCell.h
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJMyPhotoCellDelegate <NSObject>

-(void)showPhotoActionSheet;

@end

@interface TJMyPhotoCell : UITableViewCell
{
    __unsafe_unretained id<TJMyPhotoCellDelegate> delegate;
    NSMutableArray *photoUrlArray;
}
@property(nonatomic,unsafe_unretained) id<TJMyPhotoCellDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *photoUrlArray;

-(void)setImageAtIndex:(int)whichImageView placeHolderImage:(UIImage *)placeHolderImage;
@end
