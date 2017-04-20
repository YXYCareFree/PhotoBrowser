//
//  YXYPhotoBrowser.h
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/4/13.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YXYPhotoBrowser;

@protocol YXYPhotoBrowserDelegate <NSObject>

/**
    获取placholderImage

 */
- (UIImageView *)photoBrowser:(YXYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

/**
 
 @param index index是dismiss时点击的图片序号
 */
- (void)photoBrowser:(YXYPhotoBrowser *)browser dismissImageIndex:(NSInteger)index;

@end

@interface YXYPhotoBrowser : NSObject<UIScrollViewDelegate>

//自定义长按图片的弹出的视图
@property (nonatomic, strong) UIView * actionView;

@property (nonatomic, assign) NSInteger currentImageIndex;

@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<YXYPhotoBrowserDelegate> delegate;

- (instancetype)initWithImageUrlGroup:(NSArray *)urlArr delegate:(id)delegate;

//保存图片到相册
- (void)saveImage;

- (void)show;

- (void)dismiss;

- (void)longPress;

@end
