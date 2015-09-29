//
//  IDCardCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-8.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserVC.h"

@protocol IDCardCellDelegate <NSObject>
@required
-(void)didIDCardCellAddImageButtonClicked:(id)sender;
-(void)didIDCardCellDeletePhotoSuccess:(id)sender;
@end

@interface IDCardCell : UITableViewCell<PhotoBrowserVCDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (retain, nonatomic) IBOutlet UIButton *addImageButton;
@property (nonatomic,assign)  id<IDCardCellDelegate>  delegate;
//添加图片介绍
@property (retain, nonatomic) IBOutlet UILabel *cellLable;
@property (nonatomic,assign)  NSInteger idImagecount;
//保存所有的身份证照片
@property (nonatomic,retain)  NSMutableArray *imageViewsArray;

-(void)initCell;
-(void)setCell:(NSArray *)aImageArray;
-(void)moveToIndexOfImage:(NSInteger)aIndex;
//上传照片到服务器
+ (void)postIDImages:(id )aBase64 PhtotoType:(NSInteger)aPhotoType businessType:(id)aBusinessType  CompletionBlock:(void (^)(void))block Notice:(NSString *)aNotice;
//删除照片
+(void)postDeleteImagePhotoType:(NSInteger)aType PhotoName:(id)aPhotoName businessId:(id)businessId CompletionBlock:(void (^)(void))bloc;
@end
