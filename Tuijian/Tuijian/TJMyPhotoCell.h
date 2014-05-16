//
//  TJMyPhotoCell.h
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJTouchablePhotoView.h"

@protocol TJMyPhotoCellDelegate <NSObject>

-(void)selectPhotoWithIndex:(int)photoIndex;
-(void)showPhotoActionSheet;
-(void)showDeletePhotoActionSheet;

@end

@interface TJMyPhotoCell : UITableViewCell
{
    __unsafe_unretained id<TJMyPhotoCellDelegate> delegate;
    NSMutableArray *photoUrlArray;
    
    TJTouchablePhotoView *shakingView;
}
@property(nonatomic,unsafe_unretained) id<TJMyPhotoCellDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *photoUrlArray;

-(void)setImageAtIndex:(int)whichImageView placeHolderImage:(UIImage *)placeHolderImage;
-(void)cancelShakeView;
@end
