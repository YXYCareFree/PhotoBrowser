//
//  YXYZoomScrollView.m
//  UIScrollView
//
//  Created by 杨肖宇 on 2017/4/14.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "YXYZoomScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

#define KScreenWidth       [UIScreen mainScreen].bounds.size.width
#define KScreenHeight      [UIScreen mainScreen].bounds.size.height

@implementation YXYZoomScrollView{
    
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageUrl:(NSString *)url{
    
    if (self = [super initWithFrame:frame]) {
       
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 2.0;
       
        [self configImageView:image imageUrl:url];
    }
    return self;
}

- (void)addGesture{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer * press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.minimumPressDuration = 1.0;
    [self addGestureRecognizer:press];
}

- (void)configImageView:(UIImage *)image imageUrl:(NSString *)url{
   
    if (image) {
        CGFloat scale = KScreenWidth / image.size.width;
        
        self.zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - scale * image.size.height) / 2, KScreenWidth, scale * image.size.height)];
    }else{
        self.zoomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KScreenHeight / 2 - 120, KScreenWidth, 240)];
    }

    self.contentSize = self.zoomImageView.frame.size;
    
    [self.zoomImageView sd_setShowActivityIndicatorView:YES];

    [self.zoomImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
    self.zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.zoomImageView.clipsToBounds = YES;
    
    [self addSubview:self.zoomImageView];
    
    self.zoomImageView.userInteractionEnabled = YES;
    
    [self addGesture];
}

- (void)longPress{
    [self.browser longPress];
}

- (void)dismiss{
    [self.browser dismiss];
}

- (void)doubleTap{

    if (self.zoomScale > 1) {

        [self setZoomScale:1.0 animated:YES];

    }else{
        [self setZoomScale:2.0 animated:YES];

    }
}

#pragma mark--UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGSize originalSize = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.zoomImageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}


@end
