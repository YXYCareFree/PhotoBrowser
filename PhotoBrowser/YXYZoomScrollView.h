//
//  YXYZoomScrollView.h
//  UIScrollView
//
//  Created by 杨肖宇 on 2017/4/14.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXYPhotoBrowser.h"

@interface YXYZoomScrollView : UIScrollView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image imageUrl:(NSString *)url;

@property (nonatomic, strong) UIImageView * zoomImageView;

@property (nonatomic, strong) YXYPhotoBrowser * browser;

@end
