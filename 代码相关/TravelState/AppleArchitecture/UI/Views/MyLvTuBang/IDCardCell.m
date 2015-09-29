//
//  IDCardCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "IDCardCell.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "NetManager.h"
#import "PhtotoInfo.h"
#import "ImageViewHelper.h"

#define IMAGEWIDTH    50

@implementation IDCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageViewsArray:(NSMutableArray *)imageViewsArray{
    if (_imageViewsArray == Nil) {
        _imageViewsArray = [[NSMutableArray alloc] init];
    }
    [_imageViewsArray addObjectsFromArray:imageViewsArray];
}

-(void)initCell{
    NSArray *subViews = [self.imageScrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [_imageViewsArray removeAllObjects];
    self.idImagecount = 0;
    [self.imageScrollView setContentSize:CGSizeMake(0, IMAGEWIDTH)];
}

-(void)setCell:(NSMutableArray *)aImageViewsArray{
    self.imageViewsArray = aImageViewsArray;
    int sapce = 5;
    //获取scrollView最宽处的位置
    CGSize vScrollContentSize = self.imageScrollView.contentSize;
    
    for (NSInteger vIndex = 0; vIndex < aImageViewsArray.count; vIndex ++) {
        PhtotoInfo *vInfo = [aImageViewsArray objectAtIndex:vIndex];
        UIImageView *vImageView = [[UIImageView alloc] init];
        vImageView.layer.cornerRadius = 5;
        vImageView.layer.masksToBounds = YES;
        if ([vInfo isKindOfClass:[PhtotoInfo class]]) {
            //如果是用户刚刚照得照片，是没有URL的，直接添加image
            if (vInfo.photoType == ptSelfPhoto) {
                vImageView.image = vInfo.photoImage;
            }else{
                [vImageView setImageWithURL:[NSURL URLWithString:vInfo.phtotURLStr] PlaceHolder:[UIImage imageNamed:@"lvtubang.png"]];
            }

        }else{
            LOG(@"IDcardCell,setCell照片类型不是photoInfo");
        }
        //获取scrollView最宽处的位置
        [vImageView setFrame:CGRectMake((sapce + IMAGEWIDTH)*vIndex  + vScrollContentSize.width, 0, IMAGEWIDTH, IMAGEWIDTH)];
        //添加点击图片的响应事件
        UIButton *vImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [vImageButton setFrame:vImageView.frame];
        [vImageButton setTag:self.idImagecount];
        [vImageButton addTarget: self action:@selector(idCardImageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageScrollView addSubview:vImageView];
        [self.imageScrollView addSubview:vImageButton];
        [self.imageScrollView setContentSize:CGSizeMake((sapce + IMAGEWIDTH)*vIndex + IMAGEWIDTH+5, IMAGEWIDTH)];
        SAFE_ARC_RELEASE(vImageView);
        self.idImagecount++;
    }
    
    //重新设置scrollView打contentSize
    [self.imageScrollView setContentSize:CGSizeMake(vScrollContentSize.width +(sapce + IMAGEWIDTH)*aImageViewsArray.count, IMAGEWIDTH)];
}


#pragma mark 其他业务点击事件
- (IBAction)addImageButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(didIDCardCellAddImageButtonClicked:)]) {
        [_delegate didIDCardCellAddImageButtonClicked:Nil];
    }
}

-(void)idCardImageViewClicked:(UIButton *)sender{
    LOG(@"第%d张身份证图片点击了",sender.tag);
    
    [ViewControllerManager createViewController:@"PhotoBrowserVC"];
    PhotoBrowserVC *vVC = (PhotoBrowserVC *)[ViewControllerManager getBaseViewController:@"PhotoBrowserVC"];
    vVC.samplePictures = self.imageViewsArray;
    vVC.delegate = self;
    [ViewControllerManager showBaseViewController:@"PhotoBrowserVC" AnimationType:vaDefaultAnimation SubType:0];
    [vVC moveToIndex:sender.tag IsURLDataSource:NO];

}

#pragma mark PhotoBrowserVCDelegate
#pragma mark 用户点击删除
-(void)didPhotoBrowserVCDeletePhoto:(PhtotoInfo *)sender{
    NSString *vImageURLStr = sender.phtotURLStr;
    IFISNIL(vImageURLStr);
    NSInteger vType = sender.photoType;
    NSString *businessId = sender.businessId;
    IFISNIL(businessId);
    //如果没有上传直接删除
    if (vImageURLStr.length  == 0) {
        [self deletePhoto:sender];
        return;
    }
    //先请求服务器删除照片，删除成功后，本地再删除。
    [IDCardCell postDeleteImagePhotoType:vType PhotoName:@[vImageURLStr] businessId:businessId CompletionBlock:^{
        [self deletePhoto:sender];
    }];
}

-(void)deletePhoto:(PhtotoInfo *)aInfo{
    PhotoBrowserVC *vVC = (PhotoBrowserVC *)[ViewControllerManager getBaseViewController:@"PhotoBrowserVC"];
    //删除照片
    [vVC deletePhoto];
    //删除成功，通知和照片相关的页面刷新数据
    if ([_delegate respondsToSelector:@selector(didIDCardCellDeletePhotoSuccess:)]) {
        LOG(@"fuckdeletePhoto");
        [_delegate didIDCardCellDeletePhotoSuccess:aInfo];
    }
}

#pragma mark - 其他辅助功能
#pragma mark 移动到第一个图片的位置
-(void)moveToIndexOfImage:(NSInteger)aIndex{
    if (aIndex > self.idImagecount) {
        LOG(@"移动图片越界");
        return;
    }
    if (self.idImagecount > 3) {
        aIndex -=3;
        [self.imageScrollView setContentOffset:CGPointMake((IMAGEWIDTH +5)*aIndex, 0) animated:YES];
    }
}

#pragma mark 添加照片
+ (void)postIDImages:(id )aBase64 PhtotoType:(NSInteger)aPhotoType businessType:(id)aBusinessType  CompletionBlock:(void (^)(void))block Notice:(NSString *)aNotice{
    id vUserId = [UserManager instanceUserManager].userID;
    NSDictionary *vImageParemeter = [NSDictionary dictionaryWithObjectsAndKeys:
                                     aBase64,@"photos",
                                     [NSNumber numberWithInt:aPhotoType],@"photoType",
                                     aBusinessType,@"businessType",
                                     vUserId,@"userId",
                                     nil];

    [NetManager postDataFromWebAsynchronous:APPURL910 Paremeter:vImageParemeter Success:^(NSURLResponse *response, id responseObject) {
        //        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        //        NSNumber *vReturnState = [vReturnDic objectForKey:@"stateCode"];
        if (block) {
            block();
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"添加身份证照片" Notice:aNotice];
}

#pragma mark 删除照片
+(void)postDeleteImagePhotoType:(NSInteger)aType PhotoName:(id)aPhotoName businessId:(id)businessId CompletionBlock:(void (^)(void))block{

    id vUserId = [UserManager instanceUserManager].userID;
    NSNumber *photoType = [NSNumber numberWithInt:aType];
    NSDictionary *vImageParemeter = [NSDictionary dictionaryWithObjectsAndKeys:aPhotoName,@"photoName",
                                     photoType,@"photoType",
                                     businessId,@"businessId",
                                     vUserId,@"userId",
                                     nil];
    [NetManager postDataFromWebAsynchronous:APPURL920 Paremeter:vImageParemeter Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSNumber *vReturnState = [vReturnDic objectForKey:@"stateCode"];
        if (vReturnState != Nil) {
            if ([vReturnState intValue] == 0) {
                //删除成功，回调做相应的处理
                if (block) {
                    block();
                }
                return ;
            }
        }
        [SVProgressHUD showErrorWithStatus:@"删除失败！"];
    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"删除照片" Notice:@""];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_imageViewsArray removeAllObjects];
    [_imageScrollView release];
    [_addImageButton release];
    [_cellLable release];
    [super dealloc];
}
#endif
@end
