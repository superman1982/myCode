//
//  ViewController.m
//  测试ShowPhoto
//
//  Created by lin on 14-9-29.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "ViewController.h"
#import "KzPhoto.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
{
    kZPagedScrollView *mScrollView;
    NSMutableArray *mPhotoArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (mScrollView == nil) {
        mScrollView = [[kZPagedScrollView alloc] init];
        mScrollView.kzScrollViewDelegate = self;
    }
    [self.view addSubview:mScrollView];
    
    NSArray *bigurls = @[ @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg", @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg", @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg", @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg", @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg", @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg", @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    
    NSArray *smallURLS = @[@"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg", @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg", @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg", @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    
    //将相册数据转换成对象
    if (mPhotoArray == nil) {
        mPhotoArray = [[NSMutableArray alloc] init];
    }
    for (int i = 0 ; i < bigurls.count ; i++) {
        NSString *bigURLStr = [bigurls objectAtIndex:i];
        NSString *smallURLStr = [smallURLS objectAtIndex:i];
        KzPhoto *vPhoto = [[KzPhoto alloc] init];
        vPhoto.smallImageURLStr = smallURLStr;
        vPhoto.bigImageURLStr = bigURLStr;
        [mPhotoArray addObject:vPhoto];
        [vPhoto release];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:.2];
    [mScrollView disPlayItemAtIndex:0];
}

-(void)dealloc{
    [mPhotoArray removeAllObjects];
    mPhotoArray = nil;
    [mScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layOutPoritWithFrame:(CGRect)aFrame{
    mScrollView.frame = aFrame;
    [mScrollView oritationChangedReLayoutImageviews];
}

-(NSInteger)numberOfPagesInScrollView:(kZPagedScrollView *)aView{
    return 4;
}

-(void)prepareToReusePageViewAtIndex:(NSInteger)aIndex WithItem:(kZPageViewItem *)aPageItem{
//    UIImage *vImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)aIndex]];
//    [aPageItem disPlayIndex:aIndex WithImage:vImage];
    if (mPhotoArray.count > aIndex) {
        [aPageItem disPlayIndex:aIndex WithKZPhoto:[mPhotoArray objectAtIndex:aIndex]];
    }
}

-(kZPageViewItem *)PagedViewItemForScrollViewAtIndex:(NSInteger)aIndex
{
    kZPageViewItem *item = [[[kZPageViewItem alloc] init] autorelease];
//    UIImage *vImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)aIndex]];
//    [item disPlayIndex:aIndex WithImage:vImage];
    if (mPhotoArray.count > aIndex) {
        [item disPlayIndex:aIndex WithKZPhoto:[mPhotoArray objectAtIndex:aIndex]];
    }
    return item;
}

// 旋转屏幕时做的事情
- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration: (NSTimeInterval) duration {
    // 这里的时候需要设置一下当前的终端的横竖屏状态
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect vRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        NSLog(@"scrollViewRect:%@",NSStringFromCGRect(vRect));
        [self layOutPoritWithFrame:vRect];
    } else {
        [self layOutPoritWithFrame:self.view.frame];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    // iPhone客户端不能够横竖屏切换
    return YES;
}

@end
