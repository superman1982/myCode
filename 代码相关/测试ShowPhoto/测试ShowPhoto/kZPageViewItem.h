//
//  kZPageViewItem.h
//  测试ShowPhoto
//
//  Created by lin on 14-9-29.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KzPhoto.h"
#import "MJPhotoProgressView.h"

@interface kZPageViewItem : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,retain) UILabel *pageIndexLabel;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) MJPhotoProgressView *downLoadProgressHUD;

-(void)setDownLoadProgress:(float)aProgress;

-(void)disPlayIndex:(NSInteger)aIndex WithImage:(UIImage *)aImage;
//先调用这个方法初始化控件，再设置self.frame设置位置
-(void)disPlayIndex:(NSInteger)aIndex WithKZPhoto:(KzPhoto *)aPhoto;
//旋转屏幕时，重新设置ImageView位置
-(void)setImageViewFrame;
@end
