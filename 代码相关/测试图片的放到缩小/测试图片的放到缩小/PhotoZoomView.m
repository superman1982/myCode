//
//  PhotoZoomView.m
//  测试图片的放到缩小
//
//  Created by lin on 14-8-25.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "PhotoZoomView.h"

@implementation PhotoZoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupViews{
    self.delegate = self;
    self.imageView = nil;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *scrollViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewDoubleTap:)];
    [scrollViewDoubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:scrollViewDoubleTap];
    
    UITapGestureRecognizer *scrollViewTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTap:)];
    [scrollViewTwoFingerTap setNumberOfTouchesRequired:2];
    [self addGestureRecognizer:scrollViewTwoFingerTap];
    
    UITapGestureRecognizer *scrollViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handScrollViewSingleTap:)];
    [scrollViewTwoFingerTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:scrollViewSingleTap];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    //保持图片居中显示
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0;
    }else{
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0;
    }else{
        frameToCenter.origin.y = 0;
    }
    self.imageView.frame = frameToCenter;
    // end
    
    CGPoint contentOffset = self.contentOffset;
    if (frameToCenter.origin.x != 0.0) {
        contentOffset.x = 0.0;
    }
    
    if (frameToCenter.origin.y != 0.0) {
        contentOffset.y = 0.0;
    }
    
    self.contentOffset = contentOffset;
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

-(void)displayImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = TRUE;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *scrollViewDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewDoubleTap:)];
    [scrollViewDoubleTap setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:scrollViewDoubleTap];
    
    UITapGestureRecognizer *scrollViewTwoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTap:)];
    [scrollViewTwoFingerTap setNumberOfTouchesRequired:2];
    [self.imageView addGestureRecognizer:scrollViewTwoFingerTap];
    
    UITapGestureRecognizer *scrollViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handScrollViewSingleTap:)];
    [scrollViewTwoFingerTap setNumberOfTapsRequired:1];
    [self.imageView addGestureRecognizer:scrollViewSingleTap];
    
    self.contentSize = self.imageView.frame.size;
    [self setMaxMinZoomScale];
    [self setZoomScale:self.minimumZoomScale];
}

-(void)setMaxMinZoomScale{
    CGSize boundsSize = self.bounds.size;
    CGFloat minScale = 0.25;
    
    if (self.imageView.bounds.size.width > 0
        && self.imageView.bounds.size.height > 0) {
        CGFloat xScale = boundsSize.width / self.imageView.bounds.size.width;
        CGFloat yScale = boundsSize.height / self.imageView.bounds.size.height;
        xScale = MIN(1, xScale);
        yScale = MIN(1, yScale);
        minScale = MIN(xScale, yScale);
        if (minScale == 1) {
            minScale = 0.25;
        }
    }
    self.minimumZoomScale = 0.25;
    self.maximumZoomScale = 1.0;
}

#pragma mark - UIScrollViewDelegate Methods
#pragma mark -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
@end
