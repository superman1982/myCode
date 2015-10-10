//
//  kZPageViewItem.m
//  测试ShowPhoto
//
//  Created by lin on 14-9-29.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "kZPageViewItem.h"
#import "kZUIImageView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface kZPageViewItem()
{
    NSInteger _index;
}
@end

@implementation kZPageViewItem

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self layOutSubviewsForPhone];
    }
    return self;
}

-(void)setupView{
    _imageView = nil;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *vDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTaped:)];
    vDoubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:vDoubleTap];
    [vDoubleTap release];
    
    if (_downLoadProgressHUD == nil) {
        _downLoadProgressHUD = [[MJPhotoProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    _downLoadProgressHUD.hidden = YES;
    [self addSubview:_downLoadProgressHUD];
}

-(void)dealloc{
    [_downLoadProgressHUD release];
    [_pageIndexLabel release];
    [_imageView release];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layOutSubviewsForPhone];
}

-(void)layOutSubviewsForPhone{
    self.pageIndexLabel.frame = CGRectMake(172.5, 323, 30, 21);
    _downLoadProgressHUD.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

-(void)setImageViewFrame{
    _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    [self setmaxiMinZoomScale];
    //不设置这个的化，放大到一定程度，就会滑动出现问题。
    self.contentSize = _imageView.frame.size;
}

-(void)setDownLoadProgress:(float)aProgress{
    if (aProgress == 1.0) {
        _downLoadProgressHUD.hidden = YES;
    }else{
        _downLoadProgressHUD.hidden = NO;
    }
    _downLoadProgressHUD.progress = aProgress;

}

-(void)setmaxiMinZoomScale{
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 0.25;

    if (_imageView.frame.size.width > 0) {

        CGSize imageSize = _imageView.image.size;
        CGFloat xZoomScale = self.bounds.size.width / imageSize.width;
        CGFloat yZoomScale = self.bounds.size.height / imageSize.height;
        CGFloat minScale = MIN(yZoomScale, xZoomScale);
        minScale = MIN(1, minScale);
        self.maximumZoomScale =1.0 + (1.0- minScale);
        self.minimumZoomScale = 1.0;
        NSLog(@"miniScale:%f",minScale);
        
        CGFloat xWidth = imageSize.width * minScale;
        CGFloat yHight = imageSize.height * minScale;
        CGRect  imageScaledFrame = _imageView.frame;
        imageScaledFrame.size = CGSizeMake(xWidth, yHight);
        _imageView.frame = imageScaledFrame;
        
        [self centerTheImageView];
        
        NSLog(@"self.bounds:%@",NSStringFromCGRect(self.bounds));
    }
}

-(void)centerTheImageView{
    CGRect centerRect;
    CGRect imageViewRect = _imageView.frame;
    if (imageViewRect.size.width < self.bounds.size.width) {
        centerRect.origin.x = (self.bounds.size.width - imageViewRect.size.width)/2.0;
    }else{
        centerRect.origin.x = 0.0;
    }
    
    if (imageViewRect.size.height < self.bounds.size.height) {
        centerRect.origin.y = (self.bounds.size.height - imageViewRect.size.height)/2.0;
    }else{
        centerRect.origin.y = 0.0;
    }
    centerRect.size = imageViewRect.size;

    _imageView.frame = centerRect;
}

//先调用这个方法初始化控件，再设置self.frame设置位置
-(void)disPlayIndex:(NSInteger)aIndex WithImage:(UIImage *)aImage{
    
    if (_imageView) {
        [_imageView removeFromSuperview];
        [_imageView release];
        _imageView = nil;
    }
    
    UIImageView *vImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, aImage.size.width, aImage.size.height)];
    vImageView.image = aImage;
    [self addSubview:vImageView];
    self.imageView = vImageView;
    [vImageView release];
    
    if (_pageIndexLabel) {
        [_pageIndexLabel removeFromSuperview];
        [_pageIndexLabel release];
        _pageIndexLabel = nil;
    }
    UILabel *indexLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 21)];
    indexLable.text = [NSString stringWithFormat:@"%ld",(long)aIndex];
    [self addSubview:indexLable];
    self.pageIndexLabel = indexLable;
    [indexLable release];
}

//先调用这个方法初始化控件，再设置self.frame设置位置
-(void)disPlayIndex:(NSInteger)aIndex WithKZPhoto:(KzPhoto *)aPhoto{
    
    if (_imageView) {
        [_imageView removeFromSuperview];
        [_imageView release];
        _imageView = nil;
    }
    _index =aIndex;
    kZUIImageView *vImageView = [[kZUIImageView alloc] init];
    [self addSubview:vImageView];
    self.imageView = vImageView;
    [vImageView release];
    
    //将小图片作为placeHolder
    UIImage *vPlaceHolderImage = aPhoto.srcImageView.image;
    if (vPlaceHolderImage == nil) {
        vPlaceHolderImage = [UIImage imageNamed:@"timeline_image_loading"];
    }
    
    [self bringSubviewToFront:_downLoadProgressHUD];
    //请求大图片
    [vImageView sd_setImageWithURL:[NSURL URLWithString:aPhoto.bigImageURLStr] placeholderImage:vPlaceHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setDownLoadProgress:(float)receivedSize/ expectedSize];
            NSLog(@"receivedSize:%lu",(unsigned long)receivedSize);
        });

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self setImageViewFrame];
    }];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerTheImageView];
}

-(void)doubleTaped:(UITapGestureRecognizer *)aTap{
    if (self.zoomScale != self.maximumZoomScale) {
        [self setZoomScale:self.maximumZoomScale animated:YES];
    }else{
         [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

@end
