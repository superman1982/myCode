//
//  PECropView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface PECropView : UIView

@property (nonatomic,retain) UIImage *image;
@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic,assign) CGFloat aspectRatio;
@property (nonatomic,assign) CGRect cropRect;

@end
