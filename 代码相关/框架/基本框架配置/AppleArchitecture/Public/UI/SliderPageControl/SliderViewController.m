//
//  SliderViewController.m
//  SliderPageControlDemo
//
//  Created by klbest1 on 14-1-26.
//
//

#import "SliderViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define PAGECONTROLHEIGHT 20

@interface SliderViewController ()
{
    ClickableScrollView *mScrollContentView;
    SliderPageControl *mSliderPageControl;
    BOOL pageControlUsed;
    NSInteger currentPage_;
    NSInteger mWholePages;
    NSTimer *mAutoTime;
}
@end

@implementation SliderViewController
@synthesize scrolloContentView = mScrollContentView;

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
    //    mViewControllers = [NSMutableArray array];
    UIView *vContentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    if (mScrollContentView == nil) {
        mScrollContentView = [[ClickableScrollView alloc] init];
        id VC = [[ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER]getBaseViewController:@"ElectronicRouteBookVC"];
        if (VC != nil) {
            mScrollContentView.clickDelegate = VC;
        }
    }
    mScrollContentView.pagingEnabled = YES;
    mScrollContentView.delegate = self;
    
    if (mSliderPageControl == nil) {
        mSliderPageControl = [[SliderPageControl  alloc] initWithFrame:CGRectMake(0,200,320,PAGECONTROLHEIGHT)];
    }
    [mSliderPageControl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
    [mSliderPageControl setDelegate:self];
    [mSliderPageControl setShowsHint:YES];
//    [mSliderPageControl setHidden:YES];
    [vContentView addSubview:mScrollContentView];
    [vContentView addSubview:mSliderPageControl];
    
    self.view = vContentView;
    SAFE_ARC_RELEASE(vContentView);
}
#if __has_feature(objc_arc)
#else
-(void)dealloc
{
    [mScrollContentView release];
    [mSliderPageControl release];
    [mAutoTime invalidate];
    [mAutoTime release];
    [super dealloc];
}
#endif

//设置滚动页面大小及contentsize
-(void)setViewFrame:(CGRect)aRect PageControlFrame:(CGRect)aPageFrame ItemsCount:(NSInteger)aCount
{
    [self.view setFrame:aRect];
    float vWidth = 30 * aCount;
    if (vWidth > 320) {
        vWidth = 320;
    }
    [mSliderPageControl setFrame:CGRectMake(aRect.origin.x, aRect.origin.y, vWidth, PAGECONTROLHEIGHT)];
    mSliderPageControl.center = CGPointMake(160, mSliderPageControl.center.y);
    [mScrollContentView setFrame:CGRectMake(0, 0, aRect.size.width, aRect.size.height)];
    [mScrollContentView setContentSize:CGSizeMake(aRect.size.width*aCount, aRect.size.height)];
}

-(void)addSlidePageControllToView:(UIView *)aView Frame:(CGRect)aFrame PagePointImage:(NSString *)aImageStr {
    if (mSliderPageControl.superview != Nil) {
        [mSliderPageControl removeFromSuperview];
    }
    [mSliderPageControl setFrame:aFrame];
    [aView addSubview:mSliderPageControl];
    [self setPageControl:mWholePages PagePointImage:aImageStr];
}

//设置pageControll
-(void)setPageControl:(NSInteger)aCount PagePointImage:(NSString *)aImageStr{
    mWholePages = aCount;
    [mSliderPageControl setNumberOfPages:aCount PagePointImage:aImageStr];
    [mSliderPageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
}
//添加界面
-(void)setViewControllers:(NSArray *)aViewControlers ViewRect:(CGRect)aRect PagePointImage:(NSString *)aImageStr{
    if (aViewControlers.count == 0) {
        return;
    }
    [self setViewFrame:aRect PageControlFrame:CGRectMake(0, 0, 320, PAGECONTROLHEIGHT) ItemsCount:aViewControlers.count];
    [self setPageControl:aViewControlers.count PagePointImage:aImageStr];
    [mScrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    for (NSInteger vVCIndex = 0; vVCIndex < aViewControlers.count;vVCIndex++) {
        
        UIViewController *vTargetVC = [aViewControlers objectAtIndex:vVCIndex];
        [vTargetVC.view setFrame:CGRectMake(aRect.size.width *vVCIndex, 0, aRect.size.width, aRect.size.height)];
        [mScrollContentView addSubview:vTargetVC.view];
        if ([vTargetVC isKindOfClass:[UIViewController class]]) {
            [self addChildViewController:vTargetVC];
        }
    }
//     if (currentPage_ == 0) {
//         if ([_delegate respondsToSelector:@selector(didScrollToPage: DiRection:)]) {
//             [_delegate didScrollToPage:currentPage_ DiRection:vsNotMove];
//         }
//     }
}

//添加View界面
-(void)setViewViews:(NSArray *)aViews ViewRect:(CGRect)aRect PagePointImage:(NSString *)aImageStr{
    if (aViews.count == 0) {
        return;
    }
    [self setViewFrame:aRect PageControlFrame:CGRectMake(50, 0, 150, PAGECONTROLHEIGHT) ItemsCount:aViews.count];
    [self setPageControl:aViews.count PagePointImage:aImageStr];
    [mScrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    for (NSInteger vVCIndex = 0; vVCIndex < aViews.count;vVCIndex++) {
        UIView *vTargetView = [aViews objectAtIndex:vVCIndex];
        [vTargetView setFrame:CGRectMake(aRect.size.width *vVCIndex, 0, aRect.size.width, aRect.size.height)];
        [mScrollContentView addSubview:vTargetView];
    }
//    if (currentPage_ == 0) {
//        if ([_delegate respondsToSelector:@selector(didScrollToPage: DiRection:)]) {
//            [_delegate didScrollToPage:currentPage_ DiRection:vsNotMove];
//        }
//    }
}

-(void)setIsAutoScroll:(BOOL)isAutoScroll{
    _isAutoScroll = isAutoScroll;
    if (isAutoScroll) {
        mAutoTime = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollAd:) userInfo:nil repeats:YES];
    }else{
        [mAutoTime invalidate];
    }
}

#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlUsed)
	{
        return;
    }
	
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[mSliderPageControl setCurrentPage:page animated:YES];
    //通知移动到第几页
    if (page != currentPage_) {
        currentPage_ = page;
        ViewAnnatationSubtype vSDirec = (currentPage_ - page) > 0 ? vsFromLeft : vsFromRight;
        if ([_delegate respondsToSelector:@selector(didScrollToPage: DiRection:)]) {
            [_delegate didScrollToPage:currentPage_ DiRection:vSDirec];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView_
{
	pageControlUsed = NO;
}


- (void)onPageChanged:(id)sender
{
	pageControlUsed = YES;
	[self slideToCurrentPage:YES];
	
}
- (void)slideToCurrentPage:(bool)animated
{
	int page = mSliderPageControl.currentPage;
	
    CGRect frame = mScrollContentView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [mScrollContentView scrollRectToVisible:frame animated:animated];
    if (currentPage_ != page) {
        currentPage_ = page;
        ViewAnnatationSubtype vSDirec = (currentPage_ - page) > 0 ? vsFromLeft : vsFromRight;
        if ([_delegate respondsToSelector:@selector(didScrollToPage: DiRection:)]) {
            [_delegate didScrollToPage:currentPage_ DiRection:vSDirec];
        }
    }
}

- (void)changeToPage:(int)page animated:(BOOL)animated
{
	[mSliderPageControl setCurrentPage:page animated:YES];
	[self slideToCurrentPage:animated];
}

#pragma mark sliderPageControlDelegate

- (NSString *)sliderPageController:(id)controller hintTitleForPage:(NSInteger)page
{
	NSString *hintTitle = [NSString stringWithFormat:@"%d",page];
	return hintTitle;
}

#pragma mark - 其他辅助功能
-(void)scrollAd:(id)sender{
    currentPage_++;
    if (currentPage_ >= mWholePages) {
        currentPage_ = 0;
    }
    if (mScrollContentView.subviews.count == 0) {
        self.isAutoScroll = NO;
    }
    pageControlUsed = NO;
    [mSliderPageControl setCurrentPage:currentPage_ animated:YES];
	[self slideToCurrentPage:YES];
}

-(void)sliderToPage:(NSInteger)aPage{
    if (aPage > mWholePages) {
        NSLog(@"移动页数出错了！");
    }
    currentPage_ = aPage;
    pageControlUsed = NO;
    [mSliderPageControl setCurrentPage:currentPage_ animated:YES];
	[self slideToCurrentPage:YES];
}

#pragma mark -
#pragma mark 内存警告处理
// 子类中去实现,释放一些需要释放的东西
- (void)viewShouldUnLoad {
    SAFE_ARC_RELEASE(mScrollContentView);
    SAFE_ARC_RELEASE(mSliderPageControl);
    mScrollContentView = nil;
    mSliderPageControl = nil;
}

// IOS6.x 不再会调到此方法
- (void)viewDidUnload {
    [super viewDidUnload];
    //统一调viewShouldUnLoad
    [self viewShouldUnLoad];
}

//收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
