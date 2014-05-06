//
//  TJCropViewController.h
//  Tuijian
//
//  Created by zhang kai on 2/19/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJBaseViewController.h"

@protocol TJCropViewControllerDelegate <NSObject>

-(void)cancelCropToActivateCamera;
-(void)getTheCropedImage:(UIImage *)cropedImage;

@end

@interface TJCropViewController : TJBaseViewController

@property(nonatomic,unsafe_unretained) id<TJCropViewControllerDelegate> delegate;
@property(nonatomic,strong) UIImage *thePhoto;
@end
