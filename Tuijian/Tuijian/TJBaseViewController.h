//
//  TJBaseViewController.h
//  Tuijian
//
//  Created by zhang kai on 3/1/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJBaseViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
}
- (void) displayContentController: (UIViewController*) content;
-(void)dismissMyViewController: (UIViewController*) content;
-(UIViewController *)getTheNavigationRootViewController;
- (void)stoppedScrolling;
- (void)updateBarButtonItems:(CGFloat)alpha;
- (void)animateNavBarTo:(CGFloat)y;

-(void)startActivityIndicator;
@end
