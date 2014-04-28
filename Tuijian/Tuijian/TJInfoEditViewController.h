//
//  TJInfoEditViewController.h
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJUser.h"

@interface TJInfoEditViewController : UIViewController
{
    TJUser *theUser;
}
@property(nonatomic,strong) TJUser *theUser;
@end
