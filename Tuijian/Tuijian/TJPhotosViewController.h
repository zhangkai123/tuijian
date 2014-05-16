//
//  TJPhotosViewController.h
//  Tuijian
//
//  Created by zhang kai on 5/16/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJPhotosViewController : UIViewController
{
    NSMutableArray *imageArray;
    NSMutableArray *placeHolderImageArray;
    int beginningIndex;
}
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *placeHolderImageArray;
@property(nonatomic,assign) int beginningIndex;
@end
