//
//  SGFocusImageFrame.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>
#import "ImageViewHelper.h"

#define ITEM_WIDTH 320.0

@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    //    GPSimplePageView *_pageControl;
    UIPageControl *_pageControl;
}

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 4.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
    [_scrollView release];
    [_pageControl release];
    [super dealloc];
}


#pragma mark - private methods
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    float space = 0;
    CGSize size = CGSizeMake(320, 0);
    //   _pageControl = [[GPSimplePageView alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5, self.bounds.size.height - size.height, size.width, size.height)];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -16-10, 320, 10)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count>1?imageItems.count -2:imageItems.count;
    _pageControl.currentPage = 0;
    
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * imageItems.count, _scrollView.frame.size.height);
    
    for (int i = 0; i < imageItems.count; i++) {
        SGFocusImageItem *item = [imageItems objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];
        //加载图片
        [imageView setImageWithURL:[NSURL URLWithString:item.image] PlaceHolder:[UIImage imageNamed:@"index_banner_bkg"]];
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    [tapGestureRecognize release];
    if ([imageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
        
    }
    
    
    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)switchFocusImageItems
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    LOG(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        //当滑动到末尾时，移动到第一张
        if (targetX >= ITEM_WIDTH * ([imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }//滑动到第一张时，移到最后一张
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    //    LOG(@"%f %d",_scrollView.contentOffset.x,page);
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
    if (page!= _pageControl.currentPage)
    {
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
        {
            [self.delegate foucusImageFrame:self currentItem:page];
        }
    }
    _pageControl.currentPage = page;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
}


- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = [imageItems count]-3;
        }
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}

- (void)setPageControlFrame:(CGRect)aFrame{
    [_pageControl setFrame:aFrame];
}

+ (UIView *)setTopAdView:(NSInteger)aWidth
                   Hight:(NSInteger)aHight
             ImagesArray:(NSArray *)aImagesArray
                Delegate:(id)target{
    //初始化图片个数
    int length = aImagesArray.count > 0 ? aImagesArray.count : 1;
    
    //初始化4张图的Title
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++){
        NSString *vImageStr = @"";
        NSString *vhrefLocation = @"";
        //取出图片地址和外部连接了
        if (aImagesArray.count > 0) {
            NSDictionary *vImageDic = [aImagesArray objectAtIndex:i];
            vImageStr = [vImageDic objectForKey:@"image"];
            vhrefLocation = [vImageDic objectForKey:@"hrefLocation"];
        }
        //保存广告信息
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"title%d",i],@"title",
                              vImageStr,@"image",
                              vhrefLocation,@"outurl",
                              nil];
        [tempArray addObject:dict];
    }
    
    //多增加2个内容，用于添加开始和结束的循环图片
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1){
        //添加temp的最后一张图，作为滚动视图的第一张（向左滚动）
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:-1] autorelease];
        [itemArray addObject:item];
    }
    
    //添加temp中的4张图
    for (int i = 0; i < length; i++){
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:i] autorelease];
        [itemArray addObject:item];
        
    }
    //添加temp的第一张图，作为滚动视图的最后一张 用于循环 （向右滚动）
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:length] autorelease];
        [itemArray addObject:item];
    }
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, aWidth, aHight) delegate:target imageItems:itemArray isAuto:YES];
    
    [bannerView scrollToIndex:0];
    
    SAFE_ARC_AUTORELEASE(bannerView);
    return bannerView;
}

+ (SGFocusImageFrame *)setTopAdView:(CGRect)aFrame
             ViewsArray:(NSArray *)aViewsArray
                Delegate:(id)target{
    if (![aViewsArray isKindOfClass:[NSArray class]]) {
        NSLog(@"setTopAdView传入参数不对");
        return Nil;
    }
    
    int length = aViewsArray.count;
    //初始化视图
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++){
        NSDictionary *dict = [aViewsArray objectAtIndex:i];
        [tempArray addObject:dict];
    }
    
    //多增加2个内容，用于添加开始和结束的循环图片
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    if (length > 1){
        //添加temp的最后一张图，作为滚动视图的第一张（向左滚动）
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:-1] autorelease];
        [itemArray addObject:item];
    }
    
    //添加temp中的4张图
    for (int i = 0; i < length; i++){
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:i] autorelease];
        [itemArray addObject:item];
        
    }
    //添加temp的第一张图，作为滚动视图的最后一张 用于循环 （向右滚动）
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[[SGFocusImageItem alloc] initWithDict:dict tag:length] autorelease];
        [itemArray addObject:item];
    }
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:aFrame delegate:target imageItems:itemArray isAuto:YES];
    
    [bannerView scrollToIndex:0];
    
    SAFE_ARC_AUTORELEASE(bannerView);
    return bannerView;
}

@end