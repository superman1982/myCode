//
//  TakeVPPhotoTool.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPImageCropperViewController.h"

@protocol TakeVPPhotoToolDelegate <NSObject>
-(void)didTakePhotoSucces:(id)sender;
@end

@interface TakeVPPhotoTool : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>

@property (nonatomic,assign) id<TakeVPPhotoToolDelegate> delegate;

-(void)takePhoto:(UIViewController *)aVC;
@end
