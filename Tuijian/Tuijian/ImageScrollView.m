
#import "ImageScrollView.h"

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;        
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
//    // center the image as it becomes smaller than the size of the screen
//
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = imageView.frame;
//    
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//    
//    imageView.frame = frameToCenter;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [imageView removeFromSuperview];
    imageView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;

    // make a new UIImageView for the new image
    float width = 0.0;
    float height = 0.0;
    if (image.size.height >= image.size.width) {
        width = 320;
        height = image.size.height*320/image.size.width;
    }else{
        height = 320;
        width = image.size.width*320/image.size.height;
    }

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    [self configureForImageSize:CGSizeMake(width, height)];
}

- (void)configureForImageSize:(CGSize)imageSize 
{    
    self.contentSize = imageSize;
    self.maximumZoomScale = 2;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;  // start out with the content fully visible
    [self setContentOffset:CGPointMake(0, (imageSize.height - 320)/2)];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    
}
@end
