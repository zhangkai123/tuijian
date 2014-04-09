//
//  TJItemMessageViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/26/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMessage.h"

@interface TJItemMessageViewController : UIViewController

@property(nonatomic,strong) TJMessage *theMessage;

-(id)initWithTitle:(NSString *)title;
@end
