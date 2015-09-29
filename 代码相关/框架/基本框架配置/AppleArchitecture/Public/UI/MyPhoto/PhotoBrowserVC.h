//
//  PhotoBrowserVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPhotoBrowserView.h"

@protocol PhotoBrowserVCDelegate <NSObject>
-(void)didPhotoBrowserVCDeletePhoto:(id)sender;
@end

@interface PhotoBrowserVC : BaseViewController<AGPhotoBrowserDelegate, AGPhotoBrowserDataSource,UIActionSheetDelegate>

@property (nonatomic,assign) id<PhotoBrowserVCDelegate>  delegate;
@property (nonatomic,retain) NSMutableArray *samplePictures;
//移动相册到某页
-(void)moveToIndex:(NSInteger)aIndex IsURLDataSource:(BOOL)aIsURL;
#pragma mark 删除照片
-(void)deletePhoto;
@end
