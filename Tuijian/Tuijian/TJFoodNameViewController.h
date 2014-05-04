//
//  TJFoodNameViewController.h
//  Tuijian
//
//  Created by zhang kai on 5/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJFoodNameViewControllerDelegate <NSObject>

-(void)getFoodName:(NSString *)foodName;

@end

@interface TJFoodNameViewController : UIViewController
{
    __unsafe_unretained id<TJFoodNameViewControllerDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<TJFoodNameViewControllerDelegate> delegate;
@end
