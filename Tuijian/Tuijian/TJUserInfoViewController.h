//
//  TJUserInfoViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/27/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJUserInfoViewController : UIViewController
{
    NSString *userImageUrl;
    NSString *userName;
    NSString *userGender;
    NSString *uid;
}
@property(nonatomic,strong) NSString *userImageUrl;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *userGender;
@property(nonatomic,strong) NSString *uid;
@end