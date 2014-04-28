//
//  TJInfoTextCell.h
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJInfoTextCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *infoLabel;
}
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *infoLabel;
@end
