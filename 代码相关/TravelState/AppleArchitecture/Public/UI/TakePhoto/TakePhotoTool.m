//
//  TakePhotoTool.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "TakePhotoTool.h"
#import "PECropViewController.h"

@interface TakePhotoTool ()
{
    UIViewController *mShowVC;
}
@property (nonatomic,retain)  UIImage *chosedImage;

@end

@implementation TakePhotoTool

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

- (void)openEditor:(UIImage *)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = sender;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [mShowVC presentViewController:navigationController animated:YES completion:NULL];
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
                    [self openEditor:newImage];
                }];
            }
        });
    }
    
}

#pragma mark - PECropViewControllerDelegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
    if ([_delegate respondsToSelector:@selector(didTakePhotoSucces:)]) {
        [_delegate didTakePhotoSucces:imageData];
    }
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
@end
