//
//  ViewController.m
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/3/27.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "TableViewController.h"

#import "DisplayImageView.h"
#import "YXYPhotoBrowser.h"

#define kScreenWidth       [UIScreen mainScreen].bounds.size.width
#define kScreenHeigth      [UIScreen mainScreen].bounds.size.height
#define STRING_ISNIL(__POINTER) (__POINTER == nil || [__POINTER isEqualToString:@""] || [__POINTER isEqualToString:@"(null)"] || [__POINTER isEqualToString:@"null"]|| [__POINTER isEqualToString:@"(NULL)"] || [__POINTER isEqualToString:@"NULL"] || [__POINTER isEqualToString:@"<null>"] || __POINTER == NULL || [__POINTER isKindOfClass:[NSNull class]] || [[__POINTER stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)?YES:NO

@interface ViewController ()<YXYPhotoBrowserDelegate>

@property (nonatomic, assign) CGPoint originPoint;

@property (nonatomic, strong) YXYPhotoBrowser * photo;

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    
    [self createDisplayImageView];
}

- (void)createScrollView{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];

    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 150)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 100 + i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayImageView:)];
        [imageView addGestureRecognizer:tap];
        
        [_scrollView addSubview:imageView];
    }
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    [self.view addSubview:_scrollView];
}

- (void)createDisplayImageView{
    
    
    UIView * actionView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeigth, kScreenWidth, 100)];
    actionView.backgroundColor = [UIColor brownColor];
    NSString * url = @"http://ar-staticresource.bj.bcebos.com/pollingimage/9b3249a5a19a438791c5dffe520d80ec/94m58PICK69_1024.jpg";
    
    DisplayImageView * imageView = [[DisplayImageView alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 200) imageUrl:url];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    imageView.actionView = actionView;
    [self.view addSubview:imageView];
}

- (void)displayImageView:(UITapGestureRecognizer *)tap{
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeigth, kScreenWidth, 200)];
    view.backgroundColor = [UIColor redColor];
    NSArray * arr = @[
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/94m58PICK69_1024%20(18).jpg",
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/wt_9978.jpg",
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/e361172f5391473dba60c32752e51340/Desert.jpg"];
    YXYPhotoBrowser * browser = [[YXYPhotoBrowser alloc] initWithImageUrlGroup:arr delegate:self];
    browser.currentImageIndex = tap.view.tag - 100;
    browser.actionView = view;
    [browser show];
}

#pragma mark--YXYPhotoBrowserDelegate
- (UIImageView *)photoBrowser:(YXYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return _scrollView.subviews[index];
}

- (void)photoBrowser:(YXYPhotoBrowser *)browser dismissImageIndex:(NSInteger)index{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * index, 0)];
}

- (IBAction)nextVC:(id)sender {
    
    [self.navigationController pushViewController:[TableViewController new] animated:YES];
}
@end
