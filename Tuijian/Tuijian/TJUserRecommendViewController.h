//
//  TJUserRecommendViewController.h
//  Tuijian
//
//  Created by zhang kai on 4/22/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"

@interface TJUserRecommendViewController : TJBaseViewController
{
    NSString *theUserId;
}
@property(nonatomic,strong) NSString *theUserId;

-(id)initWithTitle:(NSString *)navTitle;
@end
