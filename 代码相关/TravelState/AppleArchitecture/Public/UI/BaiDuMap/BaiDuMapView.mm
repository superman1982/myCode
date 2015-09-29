//
//  BaiDuMapView.m
//  TestSingleMapView
//
//  Created by klbest1 on 13-11-20.
//  Copyright (c) 2013年 klbest1. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BaiDuMapView.h"
#import "AppDelegate.h"
#import "AnimationTransition.h"
#import "TerminalData.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "Macros.h"

//#define CURRENTLATITUDE                     30.630415
//#define CURRENTLONGTITUDE                   104.050654

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

//百度demo添加的路线规划类，路线规划时会调用下嘛的类和方法
BOOL isRetinaBD = FALSE;

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (isRetinaBD) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
@end
//---------------------------------------------

static BMKMapManager* _mapManager = nil;
static BaiDuMapView *shareBaiDuMapView_ = nil;

@interface BaiDuMapView ()

@end

@implementation BaiDuMapView
@synthesize province = _province;
@synthesize city = _city;
@synthesize street = _street;
@synthesize delegate = _delegate;
@synthesize currentLocation = _currentLocation;

#pragma mark -
#pragma mark 以下几个函数是单例类共用用到的，在写单例类的时候都可以直接拷贝
+ (BaiDuMapView *) shareBaiDuMapView {
	@synchronized(self) {
		if (shareBaiDuMapView_ == nil) {
#if __has_feature(objc_arc)
            shareBaiDuMapView_ = [[BaiDuMapView alloc] init];
#else
            shareBaiDuMapView_ = [NSAllocateObject([self class], 0 , NULL) init];
#endif
		}
        
		return shareBaiDuMapView_;
	}
}

#if __has_feature(objc_arc)
#else
// 每一次alloc都必须经过allocWithZone方法，覆盖allWithZone方法，
// 每次alloc都必须经过Instance方法，这样能够保证肯定只有一个实例化的对象
+ (id) allocWithZone: (NSZone *)zone {
    @synchronized(self) {
        if (shareBaiDuMapView_ == nil) {
            shareBaiDuMapView_ = [super allocWithZone:zone];
        }
        return shareBaiDuMapView_;
    }
}

// 覆盖copyWithZone方法可以保证克隆时还是同一个实例化的对象广告
+ (id) copyWithZone: (NSZone *)zone {
    return self;
}

- (id) retain {
    return self;
}

// 以下三个函数retainCount，release，autorelease保证了实例不被释放
- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

- (oneway void) release {
    
}

- (id) autorelease {
    return self;
}
// dealloc函数
- (void) dealloc {
    [_province release];
    [_city release];
    [_district release];
    if (_mapView) {
        [_mapView release];
        _mapView = nil;
    }
    if (mMapSearch) {
        [mMapSearch release];
        mMapSearch = nil;
    }
    if (_mapManager != Nil) {
        [_mapManager release];
        _mapManager = Nil;
    }
    [super dealloc];
}

#endif


-(id)init{
    self = [super init];
    if (self) {
        [self commInit];
    }
    
    return self;
}

//因为是单例，在不同的地方可能显示大小不一样。因此对大小进行重绘设置。
-(void)setMapViewFrame:(CGRect)aRect{
    CGRect vRect = CGRectMake(0, 0, aRect.size.width, aRect.size.height);
    [_mapView setFrame:vRect];
    [self.view setFrame:aRect];
    
//    [self.view setNeedsDisplay];
}

-(void)commInit{
    if (_mapManager == nil) {
        _mapManager = [[BMKMapManager alloc]init];
    }
    [_mapManager stop];
    BOOL ret = [_mapManager start:BaiDuMapKey generalDelegate:self];
	if (!ret) {
		LOG(@"manager start failed!");
	}else
    {
        //设置出事Zoom值
        _mapZoomLevel = 14;
        _mapView = [[BMKMapView alloc] init];
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [_mapView setZoomLevel:_mapZoomLevel];
        LOG(@"mMapViwCenter:%f,%f",[UserManager instanceUserManager].userCoord.latitude,[UserManager instanceUserManager].userCoord.longitude);
        [_mapView setCenterCoordinate:[UserManager instanceUserManager].userCoord];
        
        mMapSearch = [[BMKSearch alloc] init];
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
        _isTurnOnGPS = YES;
        
        self.province = DEFAULTPROVINCE;
        self.city = DEFAULTCITY;
        self.district = DEFAULTDISTRICT;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    mMapSearch.delegate = self;
    LOG(@"%@mMapViwCenter:%f,%f",NSStringFromSelector(_cmd),[UserManager instanceUserManager].userCoord.latitude,[UserManager instanceUserManager].userCoord.longitude);
    [_mapView setCenterCoordinate:[UserManager instanceUserManager].userCoord];
    //设置回调方便重新处理百度地图中心坐标
    if ([_delegate respondsToSelector:@selector(BaiDuMapViewViewwillAppear:)]) {
        [_delegate BaiDuMapViewViewwillAppear:animated];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    mMapSearch.delegate = nil;
    //移除地图所有信息
    [self removeAllInfoOnMap];
}

-(BOOL)isTurnOnGPS{
    if (!_isTurnOnGPS) {
        UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您没有开启GPS,不能使用地图！请到设置中开启您的GPS!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [vAlertView show];
        vAlertView = Nil;
        SAFE_ARC_RELEASE(vAlertView);
    }
    return _isTurnOnGPS;
}

//移除地图上的所有信息
-(void)removeAllInfoOnMap{
    if (_mapView.annotations.count > 0) {
        NSArray *myArray = [NSArray arrayWithArray:_mapView.annotations ];
        if (myArray.count > 0) {
            [_mapView removeAnnotations:myArray];
        }
        
        myArray = [NSArray arrayWithArray:_mapView.overlays];
        if (myArray.count > 0) {
            [_mapView removeOverlays:myArray];
        }
    }
}
//移除所有大头针的点击事件
-(void)deSelectedPointAnnotation
{
    NSArray *vAnnotationArray =  _mapView.annotations;
    for (BMKPointAnnotation *vAnnotation in vAnnotationArray) {
        [_mapView deselectAnnotation:vAnnotation animated:NO];
    }
}
//移除除aPoint之外的所有大头针
-(void)deSelectedPointAnnotationExcept:(BMKPointAnnotation *)aPoint{
    NSArray *vAnnotationArray = _mapView.annotations;
    for (BMKPointAnnotation *vAnno in vAnnotationArray) {
        if (vAnno != aPoint) {
            [_mapView deselectAnnotation:vAnno animated:NO];
        }
    }
}

-(void)driveSearchWithStartLocation:(CLLocationCoordinate2D) aStartlocation EndLocation:(CLLocationCoordinate2D) aEndLocation
{
    _isSearchNearby = NO;
    [self removeAllInfoOnMap];
    BMKPlanNode *vStart = [[BMKPlanNode alloc] init] ;
    BMKPlanNode  *vEnd = [[BMKPlanNode alloc] init];
    
    vStart.pt = aStartlocation;
    vEnd.pt = aEndLocation;
    BOOL vSearchFlag = [mMapSearch drivingSearch:@"" startNode:vStart endCity:@"" endNode:vEnd];
    mMapSearch.delegate = self;
    if (!vSearchFlag) {
        LOG(@"drive Search Field!");
    }
    SAFE_ARC_RELEASE(vStart);
    SAFE_ARC_RELEASE(vEnd);
}

//添加地图大头针
-(void)addAnnotations:(NSArray *)aPointAnnotation {
    
    if (aPointAnnotation.count == 0) {
        return;
    }
    
    [self removeAllInfoOnMap];
    [_mapView addAnnotations:aPointAnnotation];
//    [_mapView setCenterCoordinate:[UserManager instanceUserManager].userCoord];
//    LOG(@"%@mMapViwCenter:%f,%f",NSStringFromSelector(_cmd),_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
}

//查询附近信息，点击大头针不弹出自定义泡泡
-(void)searchNearBy:(NSString *)aNearStr CenterPoint:(CLLocationCoordinate2D)aCenter Radius:(NSInteger)aRadius PageIndex:(NSInteger)aPageIndex{
    _isSearchNearby = YES;
    [self removeAllInfoOnMap];
    BOOL vSearchFlag = [mMapSearch poiSearchNearBy:aNearStr center:aCenter radius:aRadius pageIndex:aPageIndex];
    if (!vSearchFlag) {
        LOG(@"附近搜索失败");
    }
}
//返回定位状态
-(BOOL)isLocateUserLocation{
    return isLocateUserLocation;
}
//开始定位
-(void)startLocateUserLocation{
    LOG(@"进入普通定位态");
    isLocateUserLocation = YES;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
//结束定位
-(void)endLocateUserLocation{
    LOG(@"关闭定位");
    isLocateUserLocation = NO;
}
//显示路况
-(void)showLuKuang{
    isShowLuKuang = YES;
    _mapView.mapType = BMKMapTypeTrafficOn;
}
//结束路况
-(void)endLuKuang{
    isShowLuKuang = NO;
    _mapView.mapType = BMKMapTypeStandard;
}
//显示路况状态
-(BOOL)isShowLuKuang{
    return isShowLuKuang;
}
//计算两坐标之间的距离
-(NSInteger)distanceFromLocation:(CLLocationCoordinate2D )aStart ToLocation:(CLLocationCoordinate2D)aEndLocation
{
    CLLocation *vStratLoation = [[CLLocation alloc] initWithLatitude:aStart.latitude longitude:aStart.longitude];
    CLLocation *vEndLocation = [[CLLocation alloc] initWithLatitude:aEndLocation.latitude longitude:aEndLocation.longitude];
    
    NSInteger vDistance = [vStratLoation distanceFromLocation:vEndLocation];
    
    SAFE_ARC_RELEASE(vStratLoation);
    vStratLoation = nil;
    SAFE_ARC_RELEASE(vEndLocation);
    vEndLocation = nil;
    
    return vDistance;
}

#pragma mark MapViewDelegate -----------

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
	}
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        NSString *AnnotationViewID = @"KJMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* bmkAnnotationView = nil;
        
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        bmkAnnotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
        ((BMKPinAnnotationView*)bmkAnnotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)bmkAnnotationView).animatesDrop = YES;
        
        // 设置位置
        bmkAnnotationView.centerOffset = CGPointMake(-50, -(bmkAnnotationView.frame.size.height * 0.5));
        bmkAnnotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        bmkAnnotationView.canShowCallout = YES;
        if ([_delegate respondsToSelector:@selector(baiDuMapViewAddAnnotationImage:viewForAnnotation:)]) {
            UIImage *vImage = [_delegate baiDuMapViewAddAnnotationImage:mapView viewForAnnotation:annotation];
            if (vImage != nil) {
                bmkAnnotationView.image = vImage;
            }
            if (_isSearchNearby) {
                bmkAnnotationView.canShowCallout = YES;
            }
        }else
        {
            bmkAnnotationView.canShowCallout = YES;
        }
        return bmkAnnotationView;
    }
    
    return nil;
}

//获取当前坐标信息
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    _isTurnOnGPS = YES;
    //通过手机gps取到当前坐标 才初始化homeview，如果是模拟器，获取的当前坐标为负数，如果没有获取到坐标也是负数。
    if (userLocation.location.coordinate.longitude > 0) { //
        LOG(@"百度地图定位成功:");
        _currentLocation = userLocation.location.coordinate;
        //先保存坐标信息，即使搜索当前位置失败，当前坐标要保存
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] forKey:@"Longitude"];
        //搜索街道信息
        BOOL vFlag = NO;
        vFlag = [mMapSearch reverseGeocode:userLocation.location.coordinate];
        mMapSearch.delegate = self;
        if (!vFlag) {
            LOG(@"search failed!");
        }
        //如果没有定位，获取到当前坐标就停止更新当前位置
        if (!isLocateUserLocation) {
            //获取到当前坐标后才停止更新当前坐标
            LOG(@"百度地图定位关闭!");
            mapView.showsUserLocation = NO;
        }
        
        //执行成功后回调
        if ([_delegate respondsToSelector:@selector(baiDuMapDidUpdateUserLocationSucces:UserLocation:)]) {
            [_delegate baiDuMapDidUpdateUserLocationSucces:_mapView UserLocation:nil];
        }
    }
    
    if ([[TerminalData instanceTerminalData] isSimulator]) {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(CURRENTLATITUDE, CURRENTLONGTITUDE)];
        mapView.showsUserLocation = NO;
        if ([_delegate respondsToSelector:@selector(baiDuMapDidFailToLocateUserLocation:didFailToLocateUserWithError:)]) {
            [_delegate baiDuMapDidFailToLocateUserLocation:_mapView didFailToLocateUserWithError:Nil];
        }
    }
    
}

//获取当前位置信息
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error{
	if (error == 0) {
        self.province = result.addressComponent.province;
        self.city = result.addressComponent.city;
        self.street = result.addressComponent.streetName;
        self.district = result.addressComponent.district;
        self.address = result.strAddr;
        
	}
}

//定位失败，提醒打开GPS或网络
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    _isTurnOnGPS = NO;
    UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您没有开启GPS,为了给您提供更精确的服务，请在设置中开启您的GPS！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [vAlertView show];
    vAlertView = Nil;
    SAFE_ARC_RELEASE(vAlertView);
    
    if ([_delegate respondsToSelector:@selector(baiDuMapDidFailToLocateUserLocation:didFailToLocateUserWithError:)]) {
        [_delegate baiDuMapDidFailToLocateUserLocation:_mapView didFailToLocateUserWithError:error];
    }
    LOG(@"%@mMapViwCenter:%f,%f",NSStringFromSelector(_cmd),[UserManager instanceUserManager].userCoord.latitude,[UserManager instanceUserManager].userCoord.longitude);
    [_mapView setCenterCoordinate:[UserManager instanceUserManager].userCoord];
}

//添加自定义泡泡,利用百度的paoPaoView属性
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    //移除其他大头针点击事件
    [self deSelectedPointAnnotationExcept:view.annotation];
    if ([_delegate respondsToSelector:@selector(baiDuMapViewdidSelectAnnotationView:PaoPaoView:)] && _isSearchNearby == NO) {
        [_delegate baiDuMapViewdidSelectAnnotationView:mapView PaoPaoView:view];
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if ([_delegate respondsToSelector:@selector(baiDuMapViewDidChangeAnimated:regionDidChangeAnimated:)]) {
        [_delegate baiDuMapViewDidChangeAnimated:mapView regionDidChangeAnimated:animated];
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    if ([_delegate respondsToSelector:@selector(baiDuMapdidSelectBlank:onClickedMapBlank:)]) {
        [_delegate baiDuMapdidSelectBlank:mapView onClickedMapBlank:coordinate];
    }
}

#pragma mark 路线规划相关方法 -------

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		LOG ( @"%@" ,s);
		return s;
	}
	return nil ;
}


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
                SAFE_ARC_AUTORELEASE(view);
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
                SAFE_ARC_AUTORELEASE(view);
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
                SAFE_ARC_AUTORELEASE(view);
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
                SAFE_ARC_AUTORELEASE(view);
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
                SAFE_ARC_AUTORELEASE(view);
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}

#pragma mark MapViewDelegate -----------

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[[CustomOverlayView alloc] initWithOverlay:overlay] autorelease];
        cutomView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 3.0;
        return cutomView;
        
        
    }
	return nil;
}

#pragma mark BMKSearchDelegate ----------

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error{
	LOG(@"onGetDrivingRouteResult:error:%d", error);
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
		
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		[item release];
		
		int index = 0;
		int size = 0;
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
				[item release];
			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
		[item release];
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
	
}


- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; i++) {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
			BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
			item.coordinate = poi.pt;
			item.title = poi.name;
			[_mapView addAnnotation:item];
            [item release];
		}
	}
    
}

@end
