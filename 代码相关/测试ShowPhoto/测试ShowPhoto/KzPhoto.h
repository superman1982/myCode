//
//  KzPhoto.h
//  测试ShowPhoto
//
//  Created by lin on 14-10-10.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KzPhoto : NSObject

@property (nonatomic,retain) NSString *smallImageURLStr;

@property (nonatomic,retain) NSString *bigImageURLStr;
//存放小图的imageView，可用来作为大图的placeHolder
@property (nonatomic,retain) UIImageView *srcImageView;

@property (nonatomic,assign) CGSize    imageSize;
@end
