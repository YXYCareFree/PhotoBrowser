//
//  YXYPhotoBrowser.m
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/4/13.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "YXYPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "YXYZoomScrollView.h"

#define kScreenHeight        [UIScreen mainScreen].bounds.size.height
#define kScreenWidth         [UIScreen mainScreen].bounds.size.width

@implementation YXYPhotoBrowser{
    
    UIWindow * _window;
    NSArray * _urlArr;

    UIImageView * _tempImageView;
    UIView * _coverView;
    CGRect  _tempRect;
    
    UIView * _actionView;
    UIScrollView * _scrollView;
    UIActivityIndicatorView * _indicatorView;
    
    UILabel * _titleLabel;
    
    BOOL _showAction;
}

- (instancetype)init{
    
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithImageUrlGroup:(NSArray *)urlArr delegate:(id)delegate{
    
    self = [super init];
    if (self) {
        if (urlArr) {
            _urlArr = urlArr;
        }
        self.delegate = delegate;
        [self setupUI];

    }
    return self;
}

- (void)setupUI{

    _window = [UIApplication sharedApplication].keyWindow;
    
    [self createTitleLabel];
    [self createActionView];
}

- (void)createScrollView{
   
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += 20;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];

    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < _urlArr.count; i++) {
        
        YXYZoomScrollView * zoomScrollView = [[YXYZoomScrollView alloc] initWithFrame:CGRectMake((kScreenWidth + 20) * i + 10, 0, kScreenWidth, kScreenHeight) image:[self getImageWithIndex:i].image imageUrl:_urlArr[i]];
        zoomScrollView.browser = self;
        [_scrollView addSubview:zoomScrollView];
    }
    
    _scrollView.contentSize = CGSizeMake((kScreenWidth + 20) * _urlArr.count, kScreenHeight);
    _scrollView.center = _window.center;
}

- (void)createTitleLabel{

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 20, 30, 40, 25)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
}
#pragma mark--Setter
- (void)setImageCount:(NSInteger)imageCount{

    _titleLabel.hidden = (imageCount <= 1) ? @"YES" : @"NO";
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex{

    _currentImageIndex = currentImageIndex;
    
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentImageIndex + 1, _urlArr.count];

    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        

        [self initCoverView];

        CGFloat scale = kScreenWidth / _tempImageView.image.size.width;
        
        [UIView animateWithDuration:.5 animations:^{
            
           _tempImageView.frame = CGRectMake(0, (kScreenHeight - scale * _tempImageView.image.size.height) / 2, kScreenWidth, scale * _tempImageView.image.size.height);
            
        } completion:^(BOOL finished) {
           
            if (finished) {
                [_coverView removeFromSuperview];
                [self createScrollView];
                [_scrollView setContentOffset:CGPointMake((kScreenWidth + 20) * currentImageIndex, 0)];
                [self show];
            }
        }];
    }
}

- (void)initCoverView{
    
    UIImageView * imageView = [self.delegate photoBrowser:self placeholderImageForIndex:_currentImageIndex];
    _tempRect = [imageView convertRect:imageView.bounds toView:_window];
    
    _tempImageView = [[UIImageView alloc] initWithFrame:_tempRect];
    _tempImageView.image = imageView.image;
    
    _coverView = [[UIView alloc] initWithFrame:_window.frame];
    _coverView.backgroundColor = [UIColor blackColor];
    [_window addSubview:_coverView];
    [_coverView addSubview:_tempImageView];
}
#pragma mark--添加弹出视图的Action
- (void)createActionView{
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 44 * 3)];
    _actionView.backgroundColor = [UIColor whiteColor];
    
    NSArray * titleArr = @[@"保存", @"发送", @"取消"];
    for (int i = 0; i < 3; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44 * i, kScreenWidth, 43)];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * i + 43, kScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [_actionView addSubview:line];
        [_actionView addSubview:btn];
    }
}
#pragma mark--弹出Action的处理
- (void)btnClicked:(UIButton *)btn{
    NSLog(@"%ld", btn.tag);
    
    [self dismiss];
    
    if ([btn.titleLabel.text isEqualToString:@"保存"]) {
        [self saveImage];
    }
}

- (void)longPress{
    
    _showAction = YES;
    [UIView animateWithDuration:.25 animations:^{
        _actionView.frame = CGRectMake(0, kScreenHeight - 44 * 3, kScreenWidth, 44 *3);
    } completion:^(BOOL finished) {
        
    }];
}

- (UIImageView *)getImageWithIndex:(int)index{
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (void)saveImage{
    
    CGPoint point = _scrollView.contentOffset;
    NSInteger current = point.x / kScreenWidth;
    YXYZoomScrollView * view = (YXYZoomScrollView *)_scrollView.subviews[current]
    ;
    UIImageWriteToSavedPhotosAlbum(view.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = _window.center;
    _indicatorView = indicator;
    [_window addSubview:indicator];
    
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
    label.center = _window.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [_window addSubview:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

#pragma mark--show dismiss
- (void)show{
    
    [_window addSubview:_scrollView];
    [_window addSubview:_actionView];
    [_window addSubview:_titleLabel];
}

- (void)dismiss{
    
    if (_showAction) {
        [UIView animateWithDuration:.25 animations:^{
            _actionView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 44 *3);
        } completion:^(BOOL finished) {
            _showAction = NO;
        }];
    }else{
        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:dismissImageIndex:)]) {
            [self.delegate photoBrowser:self dismissImageIndex: _scrollView.contentOffset.x / _scrollView.frame.size.width];
        }
        
        //调整_tempImageView的frame和动画终点的_tempRect
        [self adjustFrame];
        
        [_actionView removeFromSuperview];
        [_scrollView removeFromSuperview];
        [_titleLabel removeFromSuperview];
        
        [_window addSubview:_coverView];
        
        [UIView animateWithDuration:.5 animations:^{
            _tempImageView.frame = _tempRect;
        } completion:^(BOOL finished) {
            [_coverView removeFromSuperview];
        }];
        
    }
}

- (void)adjustFrame{
    
    UIImageView * imageView = [self.delegate photoBrowser:self placeholderImageForIndex:_scrollView.contentOffset.x / _scrollView.frame.size.width];
    _tempRect = [imageView convertRect:imageView.bounds toView:_window];
    
    _tempImageView.image = imageView.image;
    
    CGFloat scale = kScreenWidth / imageView.image.size.width;
    _tempImageView.frame = CGRectMake(0, (kScreenHeight - scale * _tempImageView.image.size.height) / 2, kScreenWidth, scale * _tempImageView.image.size.height);
}
#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int next = (scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _titleLabel.text = [NSString stringWithFormat:@"%d/%ld", next + 1, _urlArr.count];
    
}
@end
