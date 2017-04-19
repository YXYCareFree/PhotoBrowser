//
//  CustomTableViewCell.h
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/3/30.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayImageView.h"

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DisplayImageView *imageView1;
@property (weak, nonatomic) IBOutlet DisplayImageView *imageView2;


@property (nonatomic, strong) DisplayImageView * displayImageView;

@end
