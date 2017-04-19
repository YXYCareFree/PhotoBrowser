//
//  CustomTableViewCell.m
//  PhotoBrowser
//
//  Created by 杨肖宇 on 2017/3/30.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
//    
//    _displayImageView = [[DisplayImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 180) imageUrl:@""];
//    NSLog(@"cell.bounds==%@, %@", NSStringFromCGRect(self.bounds), NSStringFromCGRect(_displayImageView.frame));
////    _displayImageView.image = [UIImage imageNamed:@"shape"];
//    _displayImageView.image = [UIImage imageNamed:@"1.jpg"];
//    
//    
//    DisplayImageView * imageView = [[DisplayImageView alloc] initWithFrame:CGRectMake(160, 0, 160, 180) imageUrl:@""];
//    imageView.image = [UIImage imageNamed:@"1.jpg"];
////    [self.contentView addSubview:imageView];
//    [self.contentView addSubview:_displayImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
