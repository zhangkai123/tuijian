//
//  TJLoginViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/11/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>

@interface TJLoginViewController : UIViewController<TencentSessionDelegate>
{
    TencentOAuth* _tencentOAuth;
    NSArray* _permissions;
}
@end
