//
//  SLSessionManeger.m
//  相机
//
//  Created by lin on 15-3-11.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SLSessionManeger.h"
#import <ImageIO/ImageIO.h>
#import "UIImage+Resize.h"

#define MinimumScale 1.0
#define MaxmumScale  3.0

@interface SLSessionManeger()
{
    CGFloat    _scaleNum;
    CGFloat    _preScaleNum;
    UIView   * _preview;
}
@property (nonatomic,retain) AVCaptureSession *avCaptureSession;

@property (nonatomic,retain) AVCaptureStillImageOutput *outPutDevice;

@property (nonatomic,retain) AVCaptureDeviceInput *inputDevice;

@property (nonatomic,retain) dispatch_queue_t sessionQueue;
@end

@implementation SLSessionManeger
@synthesize scaleNum = _scaleNum;

-(id)init{
    self = [super init];
    if (self) {
        _scaleNum = 1.0;
        _preScaleNum = 1.0;
    }
    return self;
}

-(void)dealloc{
    [_avCaptureSession release];
    _avCaptureSession = nil;
    _outPutDevice = nil;
    _inputDevice = nil;
    _preview = nil;
    _previewLayer = nil;
    [super dealloc];
}

//添加前置或后置摄像机子
-(void)addInputDeviceWithFront:(BOOL)isFront{
    NSArray *vDevices = [AVCaptureDevice devices];
    AVCaptureDevice *vFrontCamera = nil;
    AVCaptureDevice *vBackCamera = nil;
    for (AVCaptureDevice *device in vDevices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                vBackCamera = device;
            }else{
                vFrontCamera = device;
            }
        }
    }
    
    if (self.inputDevice != nil) {
        [self.avCaptureSession removeInput:self.inputDevice];
    }
    
    NSError *vError;
    if (isFront) {
        AVCaptureDeviceInput *vInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:vFrontCamera error:&vError];
        if ([self.avCaptureSession canAddInput:vInputDevice]) {
            [self.avCaptureSession addInput:vInputDevice];
            self.inputDevice = vInputDevice;
        }else{
            NSLog(@"添加前置摄像头失败");
        }
    }else{
        AVCaptureDeviceInput *vInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:vBackCamera error:&vError];
        if ([self.avCaptureSession canAddInput:vInputDevice]) {
            [self.avCaptureSession addInput:vInputDevice];
            self.inputDevice = vInputDevice;
        }else{
            NSLog(@"添加后置摄像头失败");
        }
    }
}


//创建串行队列
-(void)createQueue{
    dispatch_queue_t vSessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = vSessionQueue;
}


-(void)focusWithMode:(AVCaptureFocusMode)aFocusMode
      exposeWithMode:(AVCaptureExposureMode )aExposureMode
       atDevicePoint:(CGPoint)aPoint
monitorSubjectAreaChange:(BOOL)aBool{
    dispatch_async(_sessionQueue , ^{
        AVCaptureDevice *device = [_inputDevice device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusModeSupported:aFocusMode]
                && [device isFocusPointOfInterestSupported]) {
                [device setFocusMode:aFocusMode];
                [device setFocusPointOfInterest:aPoint];
            }
            if ([device isExposureModeSupported:aExposureMode]) {
                [device setExposureMode:aExposureMode];
                [device setExposurePointOfInterest:aPoint];
            }
            [device setSubjectAreaChangeMonitoringEnabled:YES];
            [device unlockForConfiguration];
        }else{
            NSLog(@"设备设置锁失败！");
        }
    });
}

-(CGPoint)convertPointToCameraLayer:(CGPoint)aPoint{
    CGPoint vConvertedPint = CGPointMake(0.5, 0.5);
    CGSize vLayerSize = self.previewLayer.bounds.size;
    for (AVCaptureInputPort *port  in _inputDevice.ports) {
        if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
            CGSize apertureSize = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES).size;
            //Aperture 的Hight 小于width ，和View相反
            CGFloat aperTureRation = apertureSize.height / apertureSize.width;
            CGFloat cameraLayerRation = vLayerSize.width / vLayerSize.height;
            if([_previewLayer.videoGravity isEqual:AVLayerVideoGravityResizeAspectFill]){
                //相机展示界面宽width大于光圈的Height,（相机展示界面，分子分母同时乘以一个数，达到分母与光圈相同时）；
                //相机光圈Hight和Width以小的为准,即apertureSize的Hight
                if (cameraLayerRation > aperTureRation) {
                    //以以apertureSize的Height比例为准
                    //命名x是相对于相机光圈Width
                    //相机展示界面的width 应对应于 相机光圈的height
                    CGFloat x2 = apertureSize.width * (vLayerSize.width / apertureSize.height);
                    CGFloat xc =  (aPoint.y + (x2 - vLayerSize.height) / 2) / x2;
                    //相机光圈Hight要用1-x;
                    CGFloat yc = (vLayerSize.width - aPoint.x) / vLayerSize.width;
                    vConvertedPint = CGPointMake(xc, yc);
                }else{
                    //以apertureSize的Width比例为准
                    //命名y 是相对于相机光圈Hight
                    //相机展示界面的Height 应对应于 相机光圈的width
                    CGFloat y2 = apertureSize.height * (vLayerSize.height / apertureSize.width);
                    //相机光圈Hight要用1-x;
                    CGFloat yc = 1.0 - (aPoint.x + (y2 - vLayerSize.width)/2)/y2;
                    CGFloat xc = aPoint.y / vLayerSize.height;
                    vConvertedPint = CGPointMake(xc, yc);
                }
            }
        }
    }
    
    return vConvertedPint;
}

// 镜头拉伸
-(void)pinchAnimation{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    _previewLayer.affineTransform = CGAffineTransformMakeScale(_scaleNum, _scaleNum);
    [CATransaction commit];
}

#pragma mark - 初始化相机
-(void)configerSession:(CGRect)aCameraFrame parentView:(UIView *)aParentView{
    _preview = aParentView;
    [self createQueue];
    //初始化session
    AVCaptureSession *vSession = [[AVCaptureSession alloc] init];
    vSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.avCaptureSession = vSession;
    
    NSArray *vDevices = [AVCaptureDevice devices];
    //打印所有设备
    for (AVCaptureDevice * device in vDevices) {
        NSLog(@"device name:%@",[device localizedName]);
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"device position:back");
            }else{
                NSLog(@"device postion:front");
            }
        }
    }
    //配置输入设备
    [self addInputDeviceWithFront:NO];
    
    //配置输出设备
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *vOutputSet = @{ AVVideoCodecKey : AVVideoCodecJPEG};
    [imageOutput setOutputSettings:vOutputSet];
    self.outPutDevice = imageOutput;
    [vSession addOutput:imageOutput];
    [imageOutput release];
    
    //添加相机显示
    AVCaptureVideoPreviewLayer *vPreview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:vSession];
    vPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer = vPreview;
    vPreview.frame = aCameraFrame;
    [aParentView.layer addSublayer:vPreview];
    [vPreview release];
    [vSession release];
    
    //默认闪光灯
    [self switchFlashMode:nil];
    [self.avCaptureSession startRunning];
}


#pragma mark 拍照
-(void)takePhoto:(didCapturePhotoSuccess )complete{
    AVCaptureConnection *vVideoConnection = [_outPutDevice connectionWithMediaType:AVMediaTypeVideo];
    if (vVideoConnection == nil) {
        NSLog(@"没有视频设备");
        return;
    }
    
    //设置缩放倍数省略
    //拍照
    [_outPutDevice captureStillImageAsynchronouslyFromConnection:vVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        CFDictionaryRef vExifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (vExifAttachments) {
            NSLog(@"attachment:%@",vExifAttachments);
        }else {
            NSLog(@"no attachment!");
        }
        
        NSData *vImageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *vImage = [[UIImage alloc] initWithData:vImageData];
        NSLog(@"originImage:%@",[NSValue valueWithCGSize:vImage.size]);
        
        CGSize vBoundsSize = _previewLayer.bounds.size;
        UIImage *vScaledImage = [vImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:vBoundsSize interpolationQuality:kCGInterpolationHigh];
        NSLog(@"scaledImage:%@",[NSValue valueWithCGSize:vScaledImage.size]);
        
        if (complete) {
            complete(vScaledImage);
        }
    }];
}

#pragma mark - 对焦
-(void)focusToThePoint:(CGPoint)aPoint{
    CGPoint vCameraScreenPoint =  [self convertPointToCameraLayer:aPoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:vCameraScreenPoint monitorSubjectAreaChange:YES];
}

#pragma mark 切换前置、后置相机
-(void)switchCamera:(BOOL)aFront{
    [self addInputDeviceWithFront:aFront];
}

#pragma mark 镜头拉伸
-(void)pinchCamera:(UIPinchGestureRecognizer *)aGesture{
    
    BOOL isAllTouchInPreview = YES;
    NSInteger vTouchNumber = [aGesture numberOfTouches];
    for (NSInteger i = 0; i < vTouchNumber; i++) {
        CGPoint point = [aGesture locationOfTouch:i inView:_preview];
        //转换外层View的layer中的点到preViewLayer
        CGPoint convertedPoint = [_previewLayer convertPoint:point fromLayer:_previewLayer.superlayer];
        if (![_previewLayer containsPoint:convertedPoint]) {
            isAllTouchInPreview = NO;
            break;
        }
    }
    if (isAllTouchInPreview) {
        _scaleNum = aGesture.scale * _preScaleNum;
        AVCaptureConnection *videoConnection = [_outPutDevice  connectionWithMediaType:AVMediaTypeVideo];
        CGFloat vMaxMumScale = videoConnection.videoMaxScaleAndCropFactor;
        
        _scaleNum =  MIN(MaxmumScale, _scaleNum);
        _scaleNum = MAX(MinimumScale, _scaleNum);
        if (_scaleNum > vMaxMumScale) {
            _scaleNum = vMaxMumScale;
        }
        NSLog(@"_scaleNum:%f",_scaleNum);
        [self pinchAnimation];
    }
    
    if (aGesture.state == UIGestureRecognizerStateEnded
        || aGesture.state == UIGestureRecognizerStateFailed) {
        _preScaleNum = _scaleNum;
    }
}

#pragma mark 闪光灯
-(AVCaptureFlashMode )switchFlashMode:(UIButton *)sender{
    Class captureDevice = NSClassFromString(@"AVCaptureDevice");
    if (!captureDevice) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return -1;
    }
    
    AVCaptureDevice *vDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [vDevice lockForConfiguration:nil];
    if ([vDevice hasFlash]) {
        if (vDevice.flashMode == AVCaptureFlashModeOff) {
            vDevice.flashMode = AVCaptureFlashModeOn;
        }else if (vDevice.flashMode == AVCaptureFlashModeOn){
            vDevice.flashMode = AVCaptureFlashModeAuto;
        }else if (vDevice.flashMode == AVCaptureFlashModeAuto){
            vDevice.flashMode = AVCaptureFlashModeOff;
        }
        if (!sender) {
            vDevice.flashMode = AVCaptureFlashModeAuto;
        }
    }
    
    [vDevice unlockForConfiguration];
    
    return vDevice.flashMode;
}
@end
