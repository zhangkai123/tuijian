//
//  TJChatViewController.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJMessage.h"

@interface TJChatViewController : UIViewController
{
    NSString *chatToUserId;
}
@property(nonatomic,strong) NSString *chatToUserId;

-(id)initWithTitle:(NSString *)navTitle fromInfoPage:(BOOL)fInfoPage;
@end
