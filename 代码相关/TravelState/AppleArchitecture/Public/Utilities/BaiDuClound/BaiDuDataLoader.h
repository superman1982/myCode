//
//  QCMRDataLoader.h
//  兴途邦
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "ConstDef.h"

@protocol BaiDuDataLoaderDelegate <NSObject>
@optional
-(void)begainLoadBaiduCloundData:(id)sender;
-(void)LoadBaiduCloundDataFinished:(id)sender;
-(void)LoadBaiduCloundWithNoDataExist:(id)sender;
-(void)LoadBaiduCloundDataFailure:(id)sender;

-(void)LoadBaiDuSearchFinish:(id)sender;
-(void)LoadBaiDuSearchFailer:(id)sender;

@end

@class TireRoteView;

@interface BaiDuDataLoader : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate, BMKSearchDelegate>
{
    SearchType mSearchBunessType;  //搜索商家的类型
    NSMutableDictionary *mShangJiaDic; //排除重复商家,将已有商家名保存。
    CLLocationCoordinate2D myPt; //百度搜索时使用的坐标
    NSInteger mStarNumer;  //搜索的星级数量
    SortType mSortType;  //排序类型
}

@property (nonatomic,assign) id <BaiDuDataLoaderDelegate> delegate;


/***********************************************************************
 * 方法名称： // 方法名称
 * 功能描述：  搜索百度云上数据
 * 输入参数： aSearchType: stWash_Consmetology,    // 洗车美容
                        stMaintenance,              // 维修保养
                        stRefit,                    // 改装装饰
                        stChauffeur_Drive,          // 代驾
                        stMuFu,                     // 模糊搜索
            aBaiDu    星级起始数目，搜索范围，pageIndex，pageSize
            aSortFlag:  stStar,     // 星级
                        stPrice,    // 价格
                        stDistance,     // 距离
                        stAuthenticate, // 认证
            aBusinessName 模糊搜索输入的商家名
 
 ***********************************************************************/

-(void) searchBusiness: (SearchType) aSearchType
        BaiDuParemeter:(struct BaiDuCould)aBaiDu
              SortFlag: (SortType) aSortFlag
          BusinessName: (NSString *) aBusinessName;

+ (float )distanceFromLocation:(CLLocationCoordinate2D)aStartCoord
                    ToLocation:(CLLocationCoordinate2D)aEndCoord;
@end
