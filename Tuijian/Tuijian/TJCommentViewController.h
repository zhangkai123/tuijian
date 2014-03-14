//
//  TJCommentViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/14/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJItem.h"

@interface TJCommentViewController : UIViewController
{
    TJItem *theItem;
    float textHeight;
}

@property(nonatomic,strong) TJItem *theItem;
@property(nonatomic,assign) float textHeight;
@end
