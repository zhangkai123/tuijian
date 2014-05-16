//
//  TJUserSignCell.h
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJUserSignCell : UITableViewCell
{
    UIImageView *signImageView;
    UILabel *signLabel;
    UIView *lineView;
}
@property(nonatomic,strong) UILabel *signLabel;

-(void)setSignLabelText:(NSString *)moodText andTextHeight:(float)moodLabelHeight;
@end
