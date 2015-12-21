//
//  SLCameraViewController.m
//  相机
//
//  Created by lin on 15-3-12.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SLCameraViewController.h"
#import "SLSessionManeger.h"
#import "SCSlider.h"
#import "SLCustomUINavigationController.h"
#import "SLPhotoContentView.h"


#define ADJUSTINT_FOCUS @"adjustingFocus"
#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

@interface SLCameraViewController ()
{
    SLSessionManeger *_takePhotoSessionManeger;
    NSMutableSet     *_buttonSets;
    UIImageView      *_focusView;
    NSInteger        _alphaTimes;
    SCSlider         *_slider;
    SLPhotoContentView   *_photoContentView;
}
@end

@implementation SLCameraViewController

-(void)dealloc{
    [_focusView release];
    [_takePhotoSessionManeger release];
    [_buttonSets removeAllObjects];
    [_buttonSets release];
    _buttonSets = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (_takePhotoSessionManeger == nil) {
        _takePhotoSessionManeger = [[SLSessionManeger alloc] init];
    }
    if (_buttonSets == nil) {
        _buttonSets = [[NSMutableSet alloc] init];
    }
    [_takePhotoSessionManeger configerSession:[UIScreen mainScreen].bounds parentView:self.view];
    
    [self addTopView];
    [self addBottomView];
    [self addFoucusView];
    [self addPinch];
    [self addSlider];
    [self addTapGesture];
    [self addPhotoContentView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated:) name:DeviceRoatedNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGPoint vCenterPoint = CGPointMake(_takePhotoSessionManeger.previewLayer.bounds.size.width/2.0, _takePhotoSessionManeger.previewLayer.bounds.size.height/ 2.0);
    [self focusCamera:vCenterPoint];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addTopView{
    UIView *vBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    vBackGroundView.backgroundColor = [UIColor blackColor];
    vBackGroundView.alpha = 0.5;
    
    //前置、后置摄像头
    UIButton *vTakePhotoButton = [self getButton:@"switch_camera" hilghtImage:@"switch_camera_h" frame:CGRectMake(0, 0, 30, 26) target:self selector:@selector(switchDeviceClicked:)];
    vTakePhotoButton.center = CGPointMake(vBackGroundView.frame.size.width - 40, vBackGroundView.frame.size.height/2);
    [vBackGroundView addSubview:vTakePhotoButton];
    [_buttonSets addObject:vTakePhotoButton];
    
    //散光灯按钮
    UIButton *vFlashButton = [self getButton:@"flashing_auto" hilghtImage:@"" frame:CGRectMake(0, 0, 30, 26) target:self selector:@selector(flashButtonClicked:)];
    vFlashButton.center = CGPointMake(40, vBackGroundView.frame.size.height/2);
    [vBackGroundView addSubview:vFlashButton];
    [_buttonSets addObject:vFlashButton];

    [self.view addSubview:vBackGroundView];
    [vBackGroundView release];
}

-(void)addBottomView{
    UIView *vBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    vBackGroundView.backgroundColor = [UIColor blackColor];
    vBackGroundView.alpha = 0.5;
    //拍照按钮
    UIButton *vTakePhotoButton = [self getButton:@"shot" hilghtImage:@"shot_h" frame:CGRectMake(0, 0, 90, 90) target:self selector:@selector(takePhotoClicked:)];
    vTakePhotoButton.center = CGPointMake(vBackGroundView.frame.size.width/2, vBackGroundView.frame.size.height/2);
    [vBackGroundView addSubview:vTakePhotoButton];
    
    //取消按钮
    UIButton *vCancelButton  = [self getButton:@"close_cha" hilghtImage:@"close_cha_h" frame:CGRectMake(0, 0, 30, 25) target:self selector:@selector(closeClicked:)];
    vCancelButton.center = CGPointMake(30, vBackGroundView.frame.size.height/2);
    [vBackGroundView addSubview:vCancelButton];
    [_buttonSets addObject:vCancelButton];
    
    [self.view addSubview:vBackGroundView];
    [vBackGroundView release];
}

-(void)addPhotoContentView{
    if (_photoContentView == nil) {
        _photoContentView = [[SLPhotoContentView alloc] initWithFrame:self.view.bounds];
        [_photoContentView.retakeButton addTarget:self action:@selector(retake:) forControlEvents:UIControlEventTouchUpInside];
        [_photoContentView.usingPhotoButton addTarget:self action:@selector(usingPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)addFoucusView{
    if (_focusView.superview) {
        [_focusView removeFromSuperview];
    }
    if (_focusView == nil) {
        _focusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
        _focusView.alpha = 0;
    }
    [self.view addSubview:_focusView];
    
    AVCaptureDevice *vDeivce = _takePhotoSessionManeger.inputDevice.device;
    if (vDeivce && [vDeivce isFocusPointOfInterestSupported]) {
//        [vDeivce removeObserver:self forKeyPath:ADJUSTINT_FOCUS];
        [vDeivce addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

-(void)addSlider{
    if (_slider == nil) {
        _slider = [[SCSlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, (self.view.frame.size.height -  200 )/2.0, 40, 200) direction:SCSliderDirectionVertical];
    }
    _slider.alpha = 0.0f;
    _slider.minValue = MIN_PINCH_SCALE_NUM;
    _slider.maxValue = MAX_PINCH_SCALE_NUM;
    
    [self.view addSubview:_slider];
}

-(void)addPinch{
    UIPinchGestureRecognizer *vPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:vPinch];
    [vPinch release];
}

-(void)addTapGesture{
    UITapGestureRecognizer *vTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:vTap];
    [vTap release];
}

-(UIButton *)getButton:(NSString *)aNormalImageStr
     hilghtImage:(NSString *)aHelightImageStr
           frame:(CGRect)aFrame
          target:(id)aTarget
        selector:(SEL)aSector{
    UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vButton setBackgroundImage:[UIImage imageNamed:aNormalImageStr] forState:UIControlStateNormal];
    [vButton setBackgroundImage:[UIImage imageNamed:aHelightImageStr] forState:UIControlStateHighlighted];
    [vButton setFrame:aFrame];
    vButton.showsTouchWhenHighlighted = YES;
    [vButton addTarget:aTarget action:aSector forControlEvents:UIControlEventTouchUpInside];
    return vButton;
}


#pragma mark 拍照
-(void)takePhotoClicked:(UIButton *)sender{
    sender.enabled = NO;
    [_takePhotoSessionManeger takePhoto:^(UIImage *aStillImage) {
        sender.enabled = YES;
        _photoContentView.photoImageView.image = aStillImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:_photoContentView];
        });
    }];
}

#pragma mark 交换前置后置摄像头设备
-(void)switchDeviceClicked:(UIButton *)sender{
     sender.selected = !sender.selected;
    [_takePhotoSessionManeger switchCamera:sender.selected];
    [self addFoucusView];
}

#pragma mark 点击闪光灯
-(void)flashButtonClicked:(UIButton *)sender{
    AVCaptureFlashMode vMode = [_takePhotoSessionManeger switchFlashMode:sender];
    switch (vMode) {
        case AVCaptureFlashModeOff:
            [sender setBackgroundImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeOn:
            [sender setBackgroundImage:[UIImage imageNamed:@"flashing_on"] forState:UIControlStateNormal];
            break;
        case AVCaptureFlashModeAuto:
            [sender setBackgroundImage:[UIImage imageNamed:@"flashing_auto"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)closeClicked:(UIButton *)aSender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)retake:(id)sender{
    if (_photoContentView.superview) {
        [_photoContentView removeFromSuperview];
    }
}

-(void)usingPhoto:(id)sender{
    __block __weak SLCameraViewController * weakSelf = self;
    SLCustomUINavigationController *navi = (SLCustomUINavigationController *)(weakSelf).navigationController;
    if ([navi.naviDelegate respondsToSelector:@selector(didTakePhotoSuccess:)]) {
        [navi.naviDelegate didTakePhotoSuccess:_photoContentView.photoImageView.image];
    }
    [self closeClicked:nil];
}
#pragma mark - 对焦
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (!isAdjustingFocus) {
            _alphaTimes = -1;
        }
    }
}

-(void)showFocusView{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        CGFloat vAlpha = _alphaTimes %2 == 0 ? 1.0 : 0.5;
        _focusView.alpha = vAlpha;
        _alphaTimes++;
    } completion:^(BOOL finished) {
        AVCaptureDevice *vDeivce = _takePhotoSessionManeger.inputDevice.device;
        if (_alphaTimes != -1 && [vDeivce isFocusPointOfInterestSupported]) {
            [self showFocusView];
        }else{
            _focusView.alpha = 0;
        }
    }];
}


-(void)handleTap:(UITapGestureRecognizer *)aGesture{
    _alphaTimes = -1;
    CGPoint vTouchPoint = [aGesture locationInView:self.view];
    //顶部菜单栏点击无需对焦
    if (vTouchPoint.y < 50) {
        return;
    }
    if (!CGRectContainsPoint(_takePhotoSessionManeger.previewLayer.bounds, vTouchPoint)) {
        return;
    }
    [self focusCamera:vTouchPoint];
}

-(void)focusCamera:(CGPoint)aPoint{
    [_takePhotoSessionManeger focusToThePoint:aPoint];
    
    //设置动画及显示对焦
    _focusView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    _focusView.center = aPoint;
    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusView.alpha = 1.0;
        _focusView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusView];
    }];
}

-(void)handlePinch:(UIPinchGestureRecognizer *)aGesture{
    [_takePhotoSessionManeger pinchCamera:aGesture];
    [_slider setValue:_takePhotoSessionManeger.scaleNum shouldCallBack:NO];
    if (_slider.alpha != 1.0) {
        [UIView animateWithDuration:.3 animations:^{
            _slider.alpha = 1.0;
        }];
    }
    _slider.isSliding = YES;
    if (aGesture.state == UIGestureRecognizerStateEnded
        || aGesture.state == UIGestureRecognizerStateFailed) {
        _slider.isSliding = NO;
        [self hideSlideAnimation];
    }
}

//slider动画
-(void)hideSlideAnimation{
    if (!_slider.isSliding) {
        CGFloat vDelaySecond = 4;
        dispatch_time_t vTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(vDelaySecond * NSEC_PER_SEC));
        dispatch_after(vTime, dispatch_get_main_queue(), ^{
            //隐藏时，必须是在没有滑动的情况下，若3秒内，用户再次滑动，不会被隐藏
            if (!_slider.isSliding) {
                _slider.alpha = 0.0;
            }
        });
    }
}

#pragma mark - 屏幕旋转
-(void)deviceRotated:(NSNotification *)aNoti{
    [_buttonSets enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UIButton *vButton = [obj isKindOfClass:[UIButton class]]? obj :nil;
        if (vButton == nil) {
            *stop = YES;
            return ;
        }
        vButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        UIDeviceOrientation  orientation = [UIDevice currentDevice].orientation;
        CGAffineTransform vTransform = CGAffineTransformMakeRotation(0);
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                vTransform = CGAffineTransformMakeRotation(0);
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                vTransform = CGAffineTransformMakeRotation(M_PI);
                break;
            case UIDeviceOrientationLandscapeLeft:
                vTransform = CGAffineTransformMakeRotation(M_PI/2);
                break;
            case UIDeviceOrientationLandscapeRight:
                vTransform = CGAffineTransformMakeRotation(-M_PI/2);
                break;
            default:
                break;
        }

        [UIView animateWithDuration:0.3 animations:^{
            vButton.transform = vTransform;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
