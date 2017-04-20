//
//  DisplayImageView.h
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/4/18.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayImageView : UIImageView<UIGestureRecognizerDelegate, UIScrollViewDelegate>

//自定义长按图片的弹出的视图
@property (nonatomic, strong) UIView * actionView;

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)url;

//保存图片到相册
- (void)saveImage;

@end
