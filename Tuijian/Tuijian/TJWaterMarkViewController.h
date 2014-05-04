//
//  TJWaterMarkViewController.h
//  Tuijian
//
//  Created by zhang kai on 5/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJWaterMarkViewControllerDelegate <NSObject>

-(void)getTheWatermarkImage:(UIImage *)watermarkImage;

@end

@interface TJWaterMarkViewController : UIViewController
{
    UIImage *theCropedPhoto;
}

@property(nonatomic,unsafe_unretained) id<TJWaterMarkViewControllerDelegate> delegate;
@property(nonatomic,strong) UIImage *theCropedPhoto;
@end
