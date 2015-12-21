//
//  SLPhotoContentView.m
//  相机
//
//  Created by lin on 15/12/21.
//  Copyright © 2015年 lin. All rights reserved.
//

#import "SLPhotoContentView.h"

@implementation SLPhotoContentView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if(_photoImageView == nil){
            _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        [self addSubview:_photoImageView];
        [self addBottomView];
    }
    return self;
}

-(void)addBottomView{
    UIView *vBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 100, self.bounds.size.width, 100)];
    vBackGroundView.backgroundColor = [UIColor blackColor];
    vBackGroundView.alpha = 0.5;
    //拍照按钮
    if (_retakeButton == nil) {
        _retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retakeButton.frame = CGRectMake(0, 0, 60, 44);
        [_retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
        [_retakeButton setTitle:@"重拍" forState:UIControlStateHighlighted];
        [_retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _retakeButton.center = CGPointMake(50, vBackGroundView.frame.size.height/2);
    }
    [vBackGroundView addSubview:_retakeButton];
    

    if (_usingPhotoButton == nil) {
        _usingPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _usingPhotoButton.frame = CGRectMake(0, 0, 100, 44);
        [_usingPhotoButton setTitle:@"使用照片" forState:UIControlStateNormal];
        [_usingPhotoButton setTitle:@"使用照片" forState:UIControlStateHighlighted];
        [_usingPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _usingPhotoButton.center = CGPointMake(self.bounds.size.width - 70, vBackGroundView.frame.size.height/2);
    }
    [vBackGroundView addSubview:_usingPhotoButton];

    [self addSubview:vBackGroundView];
    [vBackGroundView release];
}

-(void)dealloc{
    [_photoImageView release],_photoImageView = nil;
    [super dealloc];
}
@end
