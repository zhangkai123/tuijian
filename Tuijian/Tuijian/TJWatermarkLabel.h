//
//  TJWatermarkLabel.h
//  Tuijian
//
//  Created by zhang kai on 5/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJWatermarkLabelDelegate <NSObject>

-(void)selectLabel;

@end

@interface TJWatermarkLabel : UILabel
{
    __unsafe_unretained id<TJWatermarkLabelDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<TJWatermarkLabelDelegate> delegate;
@end
