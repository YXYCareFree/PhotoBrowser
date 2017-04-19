//
//  TableViewController.m
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/3/30.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "TableViewController.h"
#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YXYPhotoBrowser.h"

#define kScreenWidth       [UIScreen mainScreen].bounds.size.width

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource, YXYPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableViewHeaderView];
}

- (void)createTableViewHeaderView{
    
    UIScrollView * _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 200)];
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
    
    _tableView.tableHeaderView = _scrollView;
}
#pragma mark--UITbaleViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cellID";
    
    if (indexPath.row == 0) {
        UITableViewCell * cell = [UITableViewCell new];
        cell.textLabel.text = @"好玩不";
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    if (!cell) {
   
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:nil options:nil] lastObject];
        cell.imageView1.image = [UIImage imageNamed:@"shape"];
        cell.imageView2.image = [UIImage imageNamed:@"1.jpg"];
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:@"http://ar-staticresource.bj.bcebos.com/pollingimage/wt_9978.jpg"] placeholderImage:nil];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://ar-staticresource.bj.bcebos.com/pollingimage/94m58PICK69_1024%20(18).jpg"] placeholderImage:nil];
//        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    return cell;
}

#pragma mark--UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)displayImageView:(UITapGestureRecognizer *)tap{
    
    NSArray * arr = @[
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/94m58PICK69_1024%20(18).jpg",
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/wt_9978.jpg",
                      @"http://ar-staticresource.bj.bcebos.com/pollingimage/e361172f5391473dba60c32752e51340/Desert.jpg"];
    YXYPhotoBrowser * browser = [[YXYPhotoBrowser alloc] initWithImageUrlGroup:arr delegate:self];
    browser.currentImageIndex = tap.view.tag - 100;
    [browser show];
}
#pragma mark--YXYPhotoBrowserDelegate
- (UIImageView *)photoBrowser:(YXYPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return _tableView.tableHeaderView.subviews[index];
}

- (void)photoBrowser:(YXYPhotoBrowser *)browser dismissImageIndex:(NSInteger)index{
    UIScrollView * scr = (UIScrollView *)_tableView.tableHeaderView;
    [scr setContentOffset:CGPointMake(scr.frame.size.width * index, 0)];
}
@end
