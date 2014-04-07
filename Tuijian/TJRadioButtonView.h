//
//  TJRadioButtonView.h
//  Tuijian
//
//  Created by zhang kai on 4/7/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJRadioButtonView : UIView


@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSString *selectedTag;
-(id)initWithTitleArray:(NSArray *)titleArray theFrame:(CGRect)frame;
@end
