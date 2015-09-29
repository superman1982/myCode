//
//  TakeVPPhotoTool.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-5.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "TakeVPPhotoTool.h"


@interface TakeVPPhotoTool()
{
    UIViewController *mShowVC;
    float mMaxHeight;
}
@property (nonatomic,retain)  UIImage *chosedImage;

@end
@implementation TakeVPPhotoTool


#if __has_feature(objc_arc)
#else
-(void)dealloc{
    [mShowVC release];
    [_chosedImage release];
    [super dealloc];
}
#endif

-(void)setChosedImageData:(NSData *)chosedImage{
    _chosedImage = [[UIImage alloc] initWithData:chosedImage];
    
}

-(void)takePhoto:(UIViewController *)aVC{
    mShowVC = aVC;
    mMaxHeight = 640;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从相册", nil), nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"从相机", nil)];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showInView:mShowVC.view];
    } else {
        [actionSheet showInView:mShowVC.view];
    }
}

#pragma mark - UIPickerViewDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"从相册", nil)]) {
        [self openPhotoAlbum];
    } else if ([buttonTitle isEqualToString:NSLocalizedString(@"从相机", nil)]) {
        [self showCamera];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* pickImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:pickImage];
}

- (void)useImage:(UIImage *)image {
    @autoreleasepool {
        // Create a graphics image context
        CGSize newSize = CGSizeMake(mShowVC.view.frame.size.width,mShowVC.view.frame.size.height);
        UIGraphicsBeginImageContext(newSize);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        // End the context
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            } else {
                [mShowVC dismissViewControllerAnimated:YES completion:^{
                    [self openVPPhotoVC:newImage];
                }];
            }
        });
    }
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.8);
    if ([_delegate respondsToSelector:@selector(didTakePhotoSucces:)]) {
        [_delegate didTakePhotoSucces:imageData];
    }
    [cropperViewController dismissModalViewControllerAnimated:YES];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 其他辅助功能

-(void)openVPPhotoVC:(UIImage *)aPhotoImage{
    
    UIImage *portraitImg = [self imageByScalingToMaxSize:aPhotoImage];
    // 裁剪
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 64, mShowVC.view.frame.size.width, mShowVC.view.frame.size.width) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [mShowVC presentViewController:imgEditorVC animated:YES completion:^{
        // TO DO
    }];
}

- (void)showCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    } else {
        [mShowVC presentViewController:controller animated:YES completion:NULL];
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    } else {
        [mShowVC presentViewController:controller animated:YES completion:NULL];
    }
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < mMaxHeight) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = mMaxHeight;
        btWidth = sourceImage.size.width * (mMaxHeight / sourceImage.size.height);
    } else {
        btWidth = mMaxHeight;
        btHeight = sourceImage.size.height * (mMaxHeight / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) LOG(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


@end
