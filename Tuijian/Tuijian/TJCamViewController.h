//
//  TJCamViewController.h
//  Tuijian
//
//  Created by zhang kai on 2/18/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"

@protocol TJCamViewControllerDelegate <NSObject>

-(void)getTheCropedImage:(UIImage *)cropedImage;

@end

@interface TJCamViewController : TJBaseViewController

@property(nonatomic,unsafe_unretained) id<TJCamViewControllerDelegate> delegate;
@end
