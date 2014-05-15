//
//  TJWirteMoodViewController.h
//  Tuijian
//
//  Created by zhang kai on 4/28/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPersonalSignViewControllerDelegate <NSObject>

-(void)updateMoodText:(NSString *)mText;

@end

@interface TJPersonalSignViewController : UIViewController

@property(nonatomic,unsafe_unretained) id<TJPersonalSignViewControllerDelegate> delegate;
@property(nonatomic,strong) NSString *moodText;
@end
