//
//  TJPhotosViewController.h
//  Tuijian
//
//  Created by zhang kai on 5/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPhotosViewControllerDelegate <NSObject>

-(void)backFromPhotoAlum:(UIImage *)bigPhoto atIndex:(int)theIndex;

@end

@interface TJPhotosViewController : UIViewController
{
    __unsafe_unretained id<TJPhotosViewControllerDelegate> delegate;
    NSMutableArray *imageArray;
    NSMutableArray *placeHolderImageArray;
    int beginningIndex;
}
@property(nonatomic,unsafe_unretained) id<TJPhotosViewControllerDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *placeHolderImageArray;
@property(nonatomic,assign) int beginningIndex;
@end
