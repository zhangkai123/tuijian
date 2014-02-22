
#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIImageView        *imageView;
}

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

@end
