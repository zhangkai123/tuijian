//
//  TJRootShowController.m
//  Tuijian
//
//  Created by zhang kai on 4/4/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TJRootShowController.h"
#import "TJShowViewController.h"
#import "TJCamViewController.h"
#import "MTStatusBarOverlay.h"
#import "TJPostViewController.h"

@interface TJRootShowController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,TJCamViewControllerDelegate,MTStatusBarOverlayDelegate>
{
    UIView *titleView;
    UIPageControl *pageControl;
    UILabel *lblTitle;
    
    TJShowViewController *pendingShowViewController;
    int currentIndex;
    int pendingIndex;
}
@end

@implementation TJRootShowController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    if (self = [super init]) {
        UIButton *cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        [cameraButton setImage:[UIImage imageNamed:@"camera_18_2x.png"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
        self.navigationItem.rightBarButtonItem = cameraButtonItem;
        
        titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = titleView;
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 160, 24)];
        lblTitle.text = @"美食";
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
        lblTitle.shadowColor = [UIColor whiteColor];
        lblTitle.shadowOffset = CGSizeMake(0, 1);
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
        [titleView addSubview:lblTitle];
        
        pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0,30,160,10);
        pageControl.pageIndicatorTintColor = UIColorFromRGB(0xA0BFFB);
        pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xF29A0B);
        pageControl.numberOfPages = 4;
        pageControl.currentPage = 0;
        [titleView addSubview:pageControl];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐";
    // kick things off by making the first page
    TJShowViewController *pageZero = [TJShowViewController showViewControllerForPageIndex:0];
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                                 options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
        pageViewController.dataSource = self;
        pageViewController.delegate = self;
        
        [pageViewController setViewControllers:@[pageZero]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:NULL];
        
        [self addChildViewController:pageViewController];
        pageViewController.view.frame = CGRectMake(0,20,320,self.view.frame.size.height - 20 - 49);
        [self.view addSubview:pageViewController.view];
        [pageViewController didMoveToParentViewController:self];
        
        currentIndex = 0;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadingItem) name:TJ_UPLOADING_ITEM_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadItemSuccess) name:TJ_UPLOADING_ITEM_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadItemFail) name:TJ_UPLOADING_ITEM_FAIL object:nil];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(TJShowViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [TJShowViewController showViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(TJShowViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [TJShowViewController showViewControllerForPageIndex:(index + 1)];
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    pendingShowViewController = nil;
    if ([pendingViewControllers count] > 0) {
        pendingShowViewController = [pendingViewControllers objectAtIndex:0];
        NSUInteger index = pendingShowViewController.pageIndex;
        pendingIndex = index;
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self setNavigationBar:pendingIndex];
    }
}
-(void)setNavigationBar:(int)index
{
    currentIndex = index;
    if (currentIndex == 0) {
        lblTitle.text = @"美食";
    }else if(currentIndex == 1){
        lblTitle.text = @"玩乐";
    }else if(currentIndex == 2){
        lblTitle.text = @"动态";
    }else if(currentIndex == 3){
        lblTitle.text = @"关注过";
    }
    pageControl.currentPage = currentIndex;
}
-(void)uploadingItem
{
    [self showUploadingActivityOnStatusbar];
}
-(void)uploadItemSuccess
{
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    [overlay postImmediateFinishMessage:@"发布成功!" duration:2.0 animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:TJ_UPDATE_RECOMMEND_LIST_NOTIFICATION object:nil];
}
-(void)uploadItemFail
{
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    [overlay postImmediateErrorMessage:@"发布失败" duration:2.0 animated:YES];
}
-(void)showUploadingActivityOnStatusbar
{
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;
    overlay.detailViewMode = MTDetailViewModeDetailText;
    overlay.delegate = self;
    [overlay postMessage:@"正在发布您的推荐…"];
}
#pragma TJCamViewControllerDelegate
-(void)getTheCropedImage:(UIImage *)cropedImage
{
    TJPostViewController *postViewController =[[TJPostViewController alloc]init];
    postViewController.cropedImage = cropedImage;
    UINavigationController *navcont = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [self presentViewController:navcont animated:YES completion:nil];
}

-(void)takePhoto:(id)sender
{
    TJCamViewController *camViewController = [[TJCamViewController alloc]init];
    camViewController.delegate = self;
    [self presentViewController:camViewController animated:YES completion:^(void){
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
