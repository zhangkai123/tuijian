//
//  TJShowViewController.h
//  Tuijian
//
//  Created by zhang kai on 2/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"

@interface TJShowViewController : TJBaseViewController
{
    UITableView *itemTableView;
}
@property(nonatomic,strong) UITableView *itemTableView;
- (NSInteger)pageIndex;
+ (TJShowViewController *)showViewControllerForPageIndex:(NSUInteger)pageIndex;
@end
