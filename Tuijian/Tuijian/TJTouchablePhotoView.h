//
//  TJTouchablePhotoView.h
//  Tuijian
//
//  Created by zhang kai on 4/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJTouchablePhotoViewDelegate <NSObject>

-(void)selectPhotoView;

@end

@interface TJTouchablePhotoView : UIImageView
{
    __unsafe_unretained id<TJTouchablePhotoViewDelegate> delegate;
}

@property(nonatomic,unsafe_unretained) id<TJTouchablePhotoViewDelegate> delegate;
@end
