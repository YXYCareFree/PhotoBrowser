
//  SingleDisplayImageView.m
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/3/27.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//
#define kScreenWidth       [UIScreen mainScreen].bounds.size.width
#define kScreenHeigth      [UIScreen mainScreen].bounds.size.height
#define keyWindow          [UIApplication sharedApplication].keyWindow

#import "DisplayImageView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@implementation DisplayImageView{
    
    UIImageView * _tempImageView;
    UIScrollView * _zoomScrollView;
    
    CGRect _tempOriginFrame;
    CGRect _convertRect;

    NSString * _src;//高清图的URL
    
    UIActivityIndicatorView * _indicatorView;
    UIView * _ActionView;
    
    BOOL _showAction;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addGesture];
    }
    return  self;
}
//xib时会调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)url{
    if (self = [super initWithFrame:frame]) {
        _src = url;
        [self addGesture];
    }
    return self;
}

- (void)addGesture{
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
    [self addGestureRecognizer:tap];
}

- (void)addGestures{
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [_zoomScrollView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail:doubleTap];
    [_tempImageView addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    longPress.minimumPressDuration = 1;
    [_tempImageView addGestureRecognizer:longPress];
}

- (void)show{
    
    [self prepareShow];
    //添加操作手势
    [self addGestures];
    
    [_zoomScrollView addSubview:_tempImageView];
    [keyWindow addSubview:_zoomScrollView];
    
    [UIView animateWithDuration:.5 animations:^{
        
        CGFloat height = self.image.size.height * kScreenWidth / self.image.size.width;
        _tempImageView.frame = CGRectMake(0, 0, kScreenWidth, height);
        _zoomScrollView.contentSize = _tempImageView.frame.size;
        _tempImageView.center = _zoomScrollView.center;
        _tempOriginFrame = _tempImageView.frame;
    }];
}

- (void)prepareShow{
    
    if (_zoomScrollView && _tempImageView) {
        return;
    }
    _zoomScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _zoomScrollView.backgroundColor = [UIColor blackColor];
    _zoomScrollView.maximumZoomScale = 2.0;
    _zoomScrollView.minimumZoomScale = 1.0;
    _zoomScrollView.delegate = self;
    _zoomScrollView.showsVerticalScrollIndicator = NO;
    _zoomScrollView.showsHorizontalScrollIndicator = NO;
    
    _tempImageView = [UIImageView new];
    
    CGRect rect=[self convertRect:self.bounds toView:keyWindow];
    
    _convertRect = rect;
    
    _tempImageView.frame = rect;
    [_tempImageView sd_setShowActivityIndicatorView:YES];
    [_tempImageView sd_setImageWithURL:[NSURL URLWithString:_src] placeholderImage:self.image];
    _tempImageView.userInteractionEnabled = YES;
    _tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    _tempImageView.clipsToBounds = YES;
    
    _zoomScrollView.contentSize = _tempImageView.frame.size;
}

- (void)dismiss:(UITapGestureRecognizer *)tap{
    
    if (_showAction) {
        [self dismiss];
        return;
    }

    if (_zoomScrollView.zoomScale > 1.0) {
        [_zoomScrollView setZoomScale:1.0 animated:YES];
    }
    
    tap.view.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.5 animations:^{
        
        _tempImageView.frame = _convertRect;
        
    } completion:^(BOOL finished) {
        
        _showAction = NO;
        
        [tap.view removeFromSuperview];
        [_ActionView removeFromSuperview];
        
        _zoomScrollView = nil;
    }];
}

#pragma mark--处理缩放
- (void)doubleTap:(UITapGestureRecognizer *)tap{
    
    if (_zoomScrollView.zoomScale > 1.0) {
        
        [_zoomScrollView setZoomScale:1.0 animated:YES];
        
    }else{
        
        [_zoomScrollView setZoomScale:2.0 animated:YES];
    }
}
#pragma mark--UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGSize originalSize = _zoomScrollView.bounds.size;
    CGSize contentSize = _zoomScrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    _tempImageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}
#pragma mark--添加弹出视图的Action
- (void)longPress{
    
    if (!_ActionView) {

        if (self.actionView) {
            
            _ActionView = self.actionView;
            
        }else{
            
            _ActionView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeigth, kScreenWidth, 44 * 3)];
            _ActionView.backgroundColor = [UIColor whiteColor];
            
            NSArray * titleArr = @[@"保存", @"发送", @"取消"];
            for (int i = 0; i < 3; i++) {
                
                UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * i, kScreenWidth, 43)];
                [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * i + 43, kScreenWidth, 1)];
                line.backgroundColor = [UIColor grayColor];
                [_ActionView addSubview:line];
                [_ActionView addSubview:btn];
            }
        }
    }
    
    if (!_showAction) {
        [keyWindow addSubview:_ActionView];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        _ActionView.frame = CGRectMake(0, kScreenHeigth - _ActionView.frame.size.height, kScreenWidth, _ActionView.frame.size.height);
    } completion:^(BOOL finished) {
        _showAction = finished;
    }];
}
#pragma mark--处理Action
- (void)btnClicked:(UIButton *)btn{
    NSLog(@"%ld", btn.tag);
    
    [self dismiss];
    
    if ([btn.titleLabel.text isEqualToString:@"保存"]) {
        [self saveImage];
    }
}

- (void)dismiss{
    
    [UIView animateWithDuration:.25 animations:^{
        _ActionView.frame = CGRectMake(0, kScreenHeigth, kScreenWidth, _ActionView.frame.size.height);
    } completion:^(BOOL finished) {
        _showAction = NO;
    }];
}

- (void)saveImage{
    
    UIImageWriteToSavedPhotosAlbum(_tempImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = keyWindow.center;
    _indicatorView = indicator;
    [keyWindow addSubview:indicator];
    
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    
    label.center = keyWindow.center;
    [keyWindow addSubview:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}
@end
