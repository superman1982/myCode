//
//  SkBaseView.m
//  BaseFrameWork
//
//  Created by lin on 15-1-14.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKBaseView.h"
#import "UIDevice-Hardware.h"

@implementation SKBaseView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self layout];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layout];
}


-(void)layout{
    self.width = self.frame.size.width;
    self.height = self.frame.size.height;
    UIDeviceFamily vDeviceType = [UIDevice currentDevice].deviceFamily;
    UIInterfaceOrientation vOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (vDeviceType == UIDeviceFamilyiPhone
        || vDeviceType == UIDeviceFamilyiPod) {
        if (UIInterfaceOrientationIsPortrait(vOrientation)) {
            [self layoutForPhonePoraitWithFrame:self.frame];
        }else{
            [self layouForPhoneLandScapeWithFrame:self.frame];
        }
    }else if (vDeviceType == UIDeviceFamilyiPad){
        if (UIInterfaceOrientationIsPortrait(vOrientation)) {
            [self layoutForPadPoraitWithFrame:self.frame];
        }else{
            [self layouForPadLandScapeWithFrame:self.frame];
        }
    }
}

-(void)setup{
    [self setupViews];
    UIDeviceFamily vDeviceType = [UIDevice currentDevice].deviceFamily;
    if (vDeviceType == UIDeviceFamilyiPhone
        || vDeviceType == UIDeviceFamilyiPod) {
        [self setupForPhone];
    }else if (vDeviceType == UIDeviceFamilyiPad){
        [self setupForPad];
    }
}

-(void)setupViews{}

-(void)setupForPhone{}

-(void)setupForPad{
}

-(void)layoutWithFrame:(CGRect)aFrame{
}

-(void)layoutForPhonePoraitWithFrame:(CGRect)aFrame{}

-(void)layouForPhoneLandScapeWithFrame:(CGRect)aFrame{}

-(void)layoutForPadPoraitWithFrame:(CGRect)aFrame{}

-(void)layouForPadLandScapeWithFrame:(CGRect)aFrame{}
@end
