//
//  TJTouchableImageView.h
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJTouchableImageViewDelegate <NSObject>

-(void)selectUserImageView:(int)sectionNum;

@end

@interface TJTouchableImageView : UIImageView
{
    __unsafe_unretained id<TJTouchableImageViewDelegate> delegate;
    int sectionNum;
}

@property(nonatomic,unsafe_unretained) id<TJTouchableImageViewDelegate> delegate;
@property(nonatomic,assign) int sectionNum;
@end
