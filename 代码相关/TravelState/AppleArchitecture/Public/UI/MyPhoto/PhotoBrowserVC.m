//
//  PhotoBrowserVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "PhotoBrowserVC.h"
#import "PhtotoInfo.h"
#import "ImageViewHelper.h"
#import "SVProgressHUD.h"

@interface PhotoBrowserVC ()
{
    NSInteger seletedIndex;
}
@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@end

@implementation PhotoBrowserVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSamplePictures:(NSMutableArray *)samplePictures{
    if (_samplePictures == Nil) {
        _samplePictures = [[NSMutableArray alloc] init];
    }
    [_samplePictures addObjectsFromArray:samplePictures];
}

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
		_browserView.delegate = self;
		_browserView.dataSource = self;
	}
	
	return _browserView;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [_browserView release];
    [_samplePictures removeAllObjects],
    [_samplePictures release];
    [super dealloc];
}
#endif

#pragma mark - AGPhotoBrowser datasource
- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
	return _samplePictures.count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
	return ((PhtotoInfo *)[_samplePictures objectAtIndex:index]).photoImage ;
}
//存放urlStr
- (PhtotoInfo *)photoBrowser:(AGPhotoBrowserView *)photoBrowser URLStringForImageAtIndex:(NSInteger)index{
    return ((PhtotoInfo *)[_samplePictures objectAtIndex:index]);
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
	return @"";
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
	return @"";
}

- (BOOL)photoBrowser:(AGPhotoBrowserView *)photoBrowser willDisplayActionButtonAtIndex:(NSInteger)index
{
    // -- For testing purposes only
    return YES;
}

#pragma mark - AGPhotoBrowser delegate

-(void)photoBrowserdidPanMoved:(AGPhotoBrowserView *)photoBrowser{
    [self back];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	LOG(@"Dismiss the photo browser here");
	[self.browserView hideWithCompletion:^(BOOL finished){
		LOG(@"Dismissed!");
        [self back];
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
    seletedIndex = index;
    PhtotoInfo *vInfo = [_samplePictures objectAtIndex:index];
    if (vInfo.photoType==ptBuness || vInfo.isAudio) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        [action showInView:self.view];
    }else{
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册",@"删除",  nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        [action showInView:self.view];
    }
	LOG(@"Action button tapped at index %d!", index);

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self savePhoto];
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        [self deletePhotoButtonClicked];
	}
}

#pragma mark - 其他辅助功能
-(void)moveToIndex:(NSInteger)aIndex IsURLDataSource:(BOOL)aIsURL{
    [self.browserView showFromIndex:aIndex];
}

#pragma mark 删除照片
-(void)deletePhoto{
    [_samplePictures removeObjectAtIndex:seletedIndex];
    [self.browserView.photoTableView reloadData];
    if (_samplePictures.count == 0) {
        LOG(@"Dismiss the photo browser here");
        [self.browserView hideWithCompletion:^(BOOL finished){
            LOG(@"Dismissed!");
            [self back];
        }];
    }
}

#pragma mark 保存照片
-(void)savePhoto{
    PhtotoInfo *vPhotoInfo = [_samplePictures objectAtIndex:seletedIndex];
    UIImage *vSaveImage = vPhotoInfo.photoImage;
    if (vSaveImage == Nil) {
        UIImageView *vImageView = [[UIImageView alloc] init];
        [vImageView setImageWithURL:[NSURL URLWithString:vPhotoInfo.phtotURLStr] PlaceHolder:[UIImage imageNamed:@""]];
        if (vImageView.image != Nil) {
            vSaveImage = vImageView.image;
        }
    }
    
    if (vSaveImage != Nil) {
        UIImageWriteToSavedPhotosAlbum(vSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), Nil);
    }
}

-(void)image:(UIImage *)aImage didFinishSavingWithError:(NSError *)aError contextInfo:(void *)contextInfo{
    // Was there an error?
    if (aError != NULL){
    }else{
        // Show message image successfully saved
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        });
    }

}

#pragma mark - 其他业务点击事件
-(void)deletePhotoButtonClicked{
    if ([_delegate respondsToSelector:@selector(didPhotoBrowserVCDeletePhoto:)]) {
        PhtotoInfo *vPhotoInfo = [_samplePictures objectAtIndex:seletedIndex];
       [_delegate didPhotoBrowserVCDeletePhoto:vPhotoInfo];
        //如果成功删除，则在相册中进行删除
    }

}


@end
