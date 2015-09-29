//
//  SLSessionManeger.h
//  相机
//
//  Created by lin on 15-3-11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^didCapturePhotoSuccess)(UIImage *aStillImage);

@interface SLSessionManeger : NSObject

@property (nonatomic,retain) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,assign)  CGFloat    scaleNum;

-(void)configerSession:(CGRect)aCameraFrame parentView:(UIView *)aParentView;
//拍照
-(void)takePhoto:(didCapturePhotoSuccess )complete;
//对焦
-(void)focusToThePoint:(CGPoint)aPoint;
//拉伸镜头
-(void)pinchCamera:(UIPinchGestureRecognizer *)aGesture;
//前置、后置摄像头
-(void)switchCamera:(BOOL)aFront;
// 闪光灯
-(AVCaptureFlashMode )switchFlashMode:(UIButton *)sender;
@end
