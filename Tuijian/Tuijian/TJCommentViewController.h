//
//  TJCommentViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/14/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"
#import "TJItem.h"

@interface TJCommentViewController : TJBaseViewController
{
    TJItem *theItem;
    float textHeight;
}
@property(nonatomic,strong) NSString *theItemId;
@property(nonatomic,strong) TJItem *theItem;
@property(nonatomic,assign) float textHeight;
@end
