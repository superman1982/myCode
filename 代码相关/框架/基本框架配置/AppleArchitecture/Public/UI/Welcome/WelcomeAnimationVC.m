//
//  WelcomeAnimationVC.m
//  BaseArchitecture
//
//  Created by lin on 14-9-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "WelcomeAnimationVC.h"

#define WelcomePages   4
#define ItemWidth      200
#define DefaultScale   0.5
#define MiddleWidth    (CGRectGetWidth(scrollContentView.frame)/2)

@interface WelcomeAnimationVC ()
{
    UIScrollView     *scrollContentView;
    NSMutableArray   *imageViewsArray;
    BOOL             fingerMoveLeft;
    CGFloat          currentOffsetX;
    NSInteger        currentIndex;
}

@end

@implementation WelcomeAnimationVC

-(void)dealloc{
    [scrollContentView release];
    [imageViewsArray removeAllObjects],imageViewsArray = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageViewsArray = [[NSMutableArray alloc] init];
    CGRect vViewRect = [UIScreen mainScreen].applicationFrame;
    CGRect vNewViewRect = CGRectMake(0, 0, vViewRect.size.height, vViewRect.size.width);
    scrollContentView = [[UIScrollView alloc] initWithFrame:vNewViewRect];
    scrollContentView.delegate = self;
    [scrollContentView setContentSize:CGSizeMake(vNewViewRect.size.width /2 *WelcomePages + vNewViewRect.size.width /2, vNewViewRect.size.height)];
    for (NSInteger page = 0;page < WelcomePages; page++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_pic_510_%d",page]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imageView.image = image;
        imageView.center = CGPointMake((page+1) * vNewViewRect.size.width /2, vNewViewRect.size.height/2);
        if (page != 0) {
            imageView.transform = CGAffineTransformMakeScale(DefaultScale, DefaultScale);
        }
        [scrollContentView addSubview:imageView];
        [imageViewsArray addObject:imageView];
        [imageView release];
    }
    
    UIImage *backGroundImage = [UIImage imageNamed:@"welcome_background"];
    UIImageView *vBackgoundView = [[UIImageView alloc] initWithImage:backGroundImage];
    vBackgoundView.frame = CGRectMake(0, 0, backGroundImage.size.width, backGroundImage.size.height);
    
    [self.view addSubview:vBackgoundView];
    [self.view addSubview:scrollContentView];
    
    [vBackgoundView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    fingerMoveLeft = (scrollContentView.contentOffset.x  - currentOffsetX > 0);
    currentOffsetX = scrollContentView.contentOffset.x;
    
    currentIndex = scrollContentView.contentOffset.x / MiddleWidth;
    NSInteger delax = ((NSInteger )scrollContentView.contentOffset.x) %(NSInteger)(MiddleWidth);
    CGFloat  imageScale = delax * DefaultScale / MiddleWidth;
//    NSLog(@"index:%ld",(long)currentIndex);
    
    //前一页
    NSInteger preIndex = currentIndex -1;
    UIImageView *preImageView = nil;
    if (preIndex > 0) {
        preImageView = [imageViewsArray objectAtIndex:preIndex];
        preImageView.transform = CGAffineTransformMakeScale(imageScale +DefaultScale, imageScale + DefaultScale);
    }
    //当前页
    if (currentIndex < imageViewsArray.count) {
        UIImageView *currentImageView = [imageViewsArray objectAtIndex:currentIndex];
        currentImageView.transform = CGAffineTransformMakeScale(1 - imageScale, 1 - imageScale);
    }
    
    //下一页
    NSInteger nextIndex = currentIndex + 1;
    UIImageView *nextImageView = nil;
    if (nextIndex < imageViewsArray.count) {
        nextImageView = [imageViewsArray objectAtIndex:nextIndex];
        nextImageView.transform = CGAffineTransformMakeScale(DefaultScale + imageScale, DefaultScale + imageScale);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (fingerMoveLeft) {
            if (currentIndex < WelcomePages - 1) {
                [scrollContentView setContentOffset: CGPointMake((currentIndex + 1) * MiddleWidth, scrollView.contentOffset.y) animated:YES];
            }
        }else{
            [scrollContentView setContentOffset: CGPointMake((currentIndex ) * MiddleWidth, scrollView.contentOffset.y) animated:YES];
        }

    });}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}
@end
