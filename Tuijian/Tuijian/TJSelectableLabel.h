//
//  TJSelectableLabel.h
//  Tuijian
//
//  Created by zhang kai on 4/10/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJSelectableLabelDelegate <NSObject>

-(void)selectLabel;

@end

@interface TJSelectableLabel : UILabel
{
    __unsafe_unretained id<TJSelectableLabelDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<TJSelectableLabelDelegate> delegate;

- (id)initWithFrameAndTextColor:(CGRect)frame andTextColor:(UIColor *)initTextColor;
@end
