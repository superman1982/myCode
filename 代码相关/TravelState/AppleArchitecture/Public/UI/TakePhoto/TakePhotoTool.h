//
//  TakePhotoTool.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TakePhotoToolDelegate <NSObject>
-(void)didTakePhotoSucces:(id)sender;
@end

@interface TakePhotoTool : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) id<TakePhotoToolDelegate> delegate;

-(void)takePhoto:(UIViewController *)aVC;
@end
