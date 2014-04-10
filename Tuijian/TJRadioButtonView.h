//
//  TJRadioButtonView.h
//  Tuijian
//
//  Created by zhang kai on 4/7/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJRadioButtonViewDelegate <NSObject>

-(void)haveSelectedTag;

@end

@interface TJRadioButtonView : UIView
{
    __unsafe_unretained id<TJRadioButtonViewDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<TJRadioButtonViewDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSString *selectedTag;
-(id)initWithTitleArray:(NSArray *)titleArray theFrame:(CGRect)frame;
@end
