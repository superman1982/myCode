//
//  SKDownLoadExtendParameter.h
//  BaseFrameWork
//
//  Created by lin on 15/5/26.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKDownLoadRequestParam.h"
#import <UIKit/UIKit.h>
#import "SKImageView.h"
@interface SKDownLoadExtendParam : SKDownLoadRequestParam

@property (nonatomic,retain) NSMutableArray   *imageViewArray;

@property (nonatomic,retain) NSString      *downLoadFilePath;

@property (nonatomic,assign)  BOOL         isAreadyDownLoad;

@property (nonatomic,assign) BOOL          isNeedDeleteDataBase;

@end
