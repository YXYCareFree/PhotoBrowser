# PhotoBrowser
# PhotoBrowser
# 方便快捷的展示轮播图的图片，并支持双击和双指捏合放大缩小，支持自定义长按手势后进行操作的actionView，支持保存图片到相册
    YXYPhotoBrowser * browser = [[YXYPhotoBrowser alloc] initWithImageUrlGroup:arr delegate:self];
    browser.currentImageIndex = tap.view.tag - 100;
    browser.actionView = view;
    [browser show];
  #  详细的请看Demo
# 也可方便的展示单张图片，只需继承DisplayImageView即可， 
    DisplayImageView * imageView = [[DisplayImageView alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 200) imageUrl:url];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    imageView.actionView = actionView;
    [self.view addSubview:imageView];
    详细的请看Demo
# 希望能够帮助到大家，喜欢的朋友可以给一个Star✨
