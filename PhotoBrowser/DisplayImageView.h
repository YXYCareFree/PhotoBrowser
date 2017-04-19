//
//  DisplayImageView.h
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/4/18.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayImageView : UIImageView<UIGestureRecognizerDelegate, UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)url;

@end
