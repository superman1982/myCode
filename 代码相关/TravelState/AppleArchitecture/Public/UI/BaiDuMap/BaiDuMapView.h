//
//  BaiDuMapView.h
//  TestSingleMapView
//
//  Created by klbest1 on 13-11-20.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "CustomOverlayView.h"
#import "CustomOverlay.h"

@protocol BaiDuMapViewDelegate <NSObject>

@optional
-(void)BaiDuMapViewViewwillAppear:(BOOL)animated;
//百度地图定位成功
-(void)baiDuMapDidUpdateUserLocationSucces:(BMKMapView *)mapView UserLocation:(BMKUserLocation *)userLocation;
//百度地图定位失败
-(void)baiDuMapDidFailToLocateUserLocation:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;
//添加Annotation图片回调,传回显示的图片即可
-(UIImage *)baiDuMapViewAddAnnotationImage:(BMKMapView *)mapView viewForAnnotation:(id)annotation;
//点击Annotation时的回调,在aView上添加想要设置的弹出泡泡就行。（[aview addsubview:]）
-(void )baiDuMapViewdidSelectAnnotationView:(BMKMapView *)aMapView PaoPaoView:(BMKAnnotationView *)aView;
//移动地图改变时调用
-(void)baiDuMapViewDidChangeAnimated:(BMKMapView *)aMapView regionDidChangeAnimated:(BOOL)aAnimated;
//点击百度地图空白处时调用
-(void)baiDuMapdidSelectBlank:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate;
@end

@interface BaiDuMapView : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,BMKGeneralDelegate>
{

    BMKSearch *mMapSearch;
    BOOL isLocateUserLocation;  //是否定位用户位置
    BOOL isShowLuKuang;       //是否显示路况
}

//是否是查询附近信息(如加油站)，如果是点击大头针不弹出自定义泡泡,
@property (nonatomic,assign) BOOL isSearchNearby;
//当前坐标位置
@property (nonatomic,assign) CLLocationCoordinate2D currentLocation;
//当前地图放大倍数
@property (nonatomic,assign) NSInteger mapZoomLevel;
//当前地址
@property (nonatomic,retain) NSString *address;
//当前省
@property (nonatomic,retain) NSString *province;
//当前城市
@property (nonatomic,retain) NSString *city;
//区县
@property (nonatomic,retain) NSString *district;
//当前街道
@property (nonatomic,retain) NSString *street;

@property (nonatomic,assign) BMKMapView *mapView;

@property (nonatomic,assign) id<BaiDuMapViewDelegate> delegate;
//是否开启了GPS，注意:若没有开启GPS不能对百度地图进行实例化,哪怕就简单的[self.view addSubview]也不行，否则用户开启GPS再启动应用，会发生崩溃，该死的baidu
@property (nonatomic,assign) BOOL isTurnOnGPS;

+(BaiDuMapView *)shareBaiDuMapView;


//重设地图大小
-(void)setMapViewFrame:(CGRect)aRect;
//移除地图所有信息
-(void)removeAllInfoOnMap;
//添加自定义Annotation
-(void)addAnnotations:(NSArray *)aPointAnnotation;
//返回定位状态
-(BOOL)isLocateUserLocation;
//定位当前位置
-(void)startLocateUserLocation;
//停止当前定位
-(void)endLocateUserLocation;
//显示路况
-(void)showLuKuang;
//结束路况
-(void)endLuKuang;
//显示路况状态
-(BOOL)isShowLuKuang;
//线路规划，传入起点坐标和终点坐标
-(void)driveSearchWithStartLocation:(CLLocationCoordinate2D) aStartlocation EndLocation:(CLLocationCoordinate2D) aEndLocation;

/*搜索附近加油站，停车场等，
 aNearstr :加油站，停车场等
 aCenter:中心坐标
 aRadius:搜索半径
 */
-(void)searchNearBy:(NSString *)aNearStr CenterPoint:(CLLocationCoordinate2D)aCenter Radius:(NSInteger)aRadius PageIndex:(NSInteger)aPageIndex;
@end
