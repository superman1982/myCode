//
//  TerminalData.m
//  iPhone
//
//  Jackson.He
//

#import "TerminalData.h"
#import "FileManager.h"
#import "OpenUDID.h"
#import "NetManager.h"
#import "HttpDefine.h"
#import "BaiDuMapView.h"
#import "ActivityRouteManeger.h"


@interface TerminalData()
// 根据横竖屏来获取长和宽
- (void) initTerminalWidthAndHeight;
@end

@implementation TerminalData

static TerminalData *mTerminalData = nil;
// 设备ID
static NSString *mDeviceID;
// 设备系统名称
static NSString *mDeviceSys;
// 设备型号
static NSString *mDeviceModel;
// SDK
static NSString *mDeviceSDK;
// iOS版本信息，例如：3.1.3, 3.1.4, 3.2.5等等
static NSString *mDeviceVersion;
// 设备的宽度
static int mDeviceWidth;
// 设备的高度
static int mDeviceHeight;
// 屏幕Scale
static float mDeviceScale;
// 状态栏的高度
static int mStatusBarHeight;
// 判断当前设备类型是否是iPad
static BOOL mIsPad;
// 设备是否是竖屏
static BOOL mIsPortait = YES;
// 是否是高清屏 
static BOOL mIsRetina;
// 是否模拟器
static BOOL mIsSimulator; 

#pragma mark -
#pragma mark 以下几个函数是单例类共用用到的，在写单例类的时候都可以直接拷贝
+ (TerminalData *) instanceTerminalData {
	@synchronized(self) {
		if (mTerminalData == nil) {
#if __has_feature(objc_arc)
            mTerminalData = [[TerminalData alloc] init];
#else
            mTerminalData = [NSAllocateObject([self class], 0 , NULL) init];
#endif
		}
        
		return mTerminalData;
	}
}

#if __has_feature(objc_arc)
#else
// 每一次alloc都必须经过allocWithZone方法，覆盖allWithZone方法，
// 每次alloc都必须经过Instance方法，这样能够保证肯定只有一个实例化的对象
+ (id) allocWithZone: (NSZone *)zone {
    return [[self instanceTerminalData] SAFE_ARC_PROP_RETAIN];
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

- (void)dealloc{
    [self.applicationInitDic release];
    [super dealloc];
}

#endif

- (id) init {
	self = [super init];
	if (self != nil) {
        NSString *vTmpStr = nil;
        mDeviceID = [[NSString alloc] initWithString: [OpenUDID value]];
        vTmpStr = [[UIDevice currentDevice] model];
        mDeviceSys = [[NSString alloc] initWithString: vTmpStr];
        vTmpStr = [[UIDevice currentDevice] localizedModel];
        mDeviceModel = [[NSString alloc] initWithString: vTmpStr];
        vTmpStr = [[UIDevice currentDevice] systemName];
        mDeviceSDK = [[NSString alloc] initWithString: vTmpStr];
        vTmpStr = [[UIDevice currentDevice] systemVersion];
        mDeviceVersion = [[NSString alloc] initWithString: vTmpStr];   
        
        mIsPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad); 
        
        // 是否是高清屏
        mIsRetina = ([UIScreen instancesRespondToSelector: @selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
        // 是否模拟器
        mIsSimulator = (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString: @"Simulator"].location);
        // 默认是竖屏
        mIsPortait = YES;
        // 采用自己的方法，保证长和宽是正确的
        [self setIsPortait: mIsPortait];
	}
	return self;
}

// 根目录和文件, 目录结构
+ (NSString *) rootDirectory {
    NSString *vTmpStr = [NSString stringWithFormat: @"%@%@", NSHomeDirectory(), ROOTDIR];
    // 强制建立mRootDirectory
    [FileManager forceCreateDirectory: vTmpStr];
    return vTmpStr;
}

// 设备ID
+ (NSString *) deviceID {
    return mDeviceID;
}

// 设备系统名称
+ (NSString *) deviceSys {
    return mDeviceSys;
}

// 设备型号
+ (NSString *) deviceModel {
    return mDeviceModel;
}

// SDK
+ (NSString *) deviceSDK {
    return mDeviceSDK;
}

// iOS版本信息，例如：3.1.3, 3.1.4, 3.2.5等等
+ (NSString *) deviceVersion {
    return mDeviceVersion;
}

// 设备的宽度
+ (int) deviceWidth {
    return mDeviceWidth;
}

// 设备的高度
+ (int) deviceHeight {
    return mDeviceHeight;
}

// 设备的Scale，Scale分别剩以宽度及高度就是分辨率
+ (float) deviceScale {
    return mDeviceScale;
}

// 状态栏的高度
+ (int) statusBarHeight {
    return mStatusBarHeight;
}

// 当前的设备是否是Pad
+ (BOOL) isPad {
    return mIsPad;
}

// 设备是否是竖屏
+ (BOOL) isPortait {
    return mIsPortait;
}

- (void) initTerminalWidthAndHeight {
    // 总宽度及高度需要减掉上面的状态栏的高度，并且这个状态栏的高度，在横竖屏时取时是不一样的
    mStatusBarHeight = 0;
    mDeviceWidth = (int)([UIScreen mainScreen].bounds.size.width);
    mDeviceHeight = (int)([UIScreen mainScreen].bounds.size.height);
    mDeviceScale = [UIScreen mainScreen].scale;
    // 如果是竖屏的话，Height应该是最大值，如果是横屏的话，Width应该是最大值
    if (mIsPortait) {   
        mStatusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;  
        if (mDeviceHeight < mDeviceWidth) {
            int vTmpInt = mDeviceHeight;
            mDeviceHeight = mDeviceWidth - mStatusBarHeight;
            mDeviceWidth = vTmpInt;
        } else {
            mDeviceHeight -= mStatusBarHeight;
        }
    } else {   
        mStatusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.width;  
        if (mDeviceHeight > mDeviceWidth) {
            int vTmpInt = mDeviceHeight;
            mDeviceHeight = mDeviceWidth - mStatusBarHeight;
            mDeviceWidth = vTmpInt;
        } else {
            mDeviceHeight -= mStatusBarHeight;
        }
    }
}

// 设备设置是否是竖屏
- (void) setIsPortait: (BOOL) aIsPortait {
    mIsPortait = aIsPortait;    
    [self initTerminalWidthAndHeight];
}

// 是否是高清屏 
+ (BOOL) isRetina {
    return mIsRetina;
}

// 是否模拟器
- (BOOL) isSimulator {
    return mIsSimulator;
}

+(void)phoneCall:(UIView *)aView PhoneNumber:(NSString *)aNumberStr{
    UIWebView *vWeb = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [vWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",aNumberStr]]]];
    vWeb.hidden = YES;
    [aView addSubview:vWeb];
    SAFE_ARC_RELEASE(vWeb);
    vWeb = nil;
}
#pragma mark 获取当前版本信息
+(NSString *)getApplicationVersion{
    //获取plist信息
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //获取版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}

- (void)checkVersion:(BOOL)isAutoCheck{
    //请求版本信息
    [NetManager getURLDataFromWeb:APPURL101 Parameter:Nil Success:^(NSURLResponse *response, id responseObject) {
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        NSDictionary *vDataDic =[vReturnDic objectForKey:@"data"];
        NSString *appVersion = [TerminalData getApplicationVersion];

        if (vDataDic.count> 0) {
            //升级版本号
            NSString *appNewVersion = [vDataDic objectForKey:@"version_name"];
            //升级描述
            NSString *vNewVersionDesc = [vDataDic objectForKey:@"desc"];
            
            LOG(@"appNewVersion:%@,appVersion:%@",appNewVersion,appVersion);
            if (![appNewVersion isEqualToString:appVersion]) {
                NSString *vNotiveStr = [NSString stringWithFormat:@"%@",vNewVersionDesc];
                UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"有新的版本" message:vNotiveStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去升级", nil];
                [vAlertView show];
                SAFE_ARC_RELEASE(vAlertView);
            }else if (!isAutoCheck) {
                UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"当前版本已是最新版本!" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
                [vAlertView show];
                SAFE_ARC_RELEASE(vAlertView);
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务器返回版本信息为空，失败！"];
        }
    } Failure:^(NSURLResponse *response, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误获取版本信息，失败！"];
    } RequestName:@"获取版本信息" Notice:Nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else if (buttonIndex == 1){
        BOOL isOpenSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:VERSIONCHECKURLSTR]];
        if (!isOpenSuccess) {
            UIAlertView *vAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"版本更新打开失败！" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:Nil, nil];
            [vAlertView show];
            SAFE_ARC_RELEASE(vAlertView);
        }
        
    }
}

- (void)applicationInit{
    NSString *vApplicationVersion = [TerminalData getApplicationVersion];
    NSString *vDeviceSerial = [OpenUDID value];
//    NSString *vProvince = [BaiDuMapView shareBaiDuMapView].province;
//    vProvince = vProvince != Nil ? vProvince : @"";
//    NSString *vCity = [BaiDuMapView shareBaiDuMapView].city;
//    vCity = vCity != Nil ? vCity :@"";
//    NSString *vDistrict = [BaiDuMapView shareBaiDuMapView].district;
//    vDistrict = vDistrict != Nil ? vDistrict : @"";
    
    CLLocationCoordinate2D userCoord = [BaiDuMapView shareBaiDuMapView].currentLocation;
    userCoord.latitude = userCoord.latitude > 0 ? userCoord.latitude : 30.630415;
    userCoord.longitude = userCoord.longitude > 0 ? userCoord.longitude : 104.050654;
    
    NSMutableDictionary *vParemeterDic = [NSMutableDictionary dictionary];
    IFISNIL(vApplicationVersion);
    [vParemeterDic setObject:vApplicationVersion forKey:@"version"];
    IFISNIL(vDeviceSerial);
    [vParemeterDic setObject:[NSNumber numberWithInt:51] forKey:@"terminalType"];
    [vParemeterDic setObject:vDeviceSerial forKey:@"mobileSerial"];
    [vParemeterDic setObject:@"" forKey:@"province"];
    [vParemeterDic setObject:@"" forKey:@"city"];
    [vParemeterDic setObject:@"" forKey:@"district"];
    [vParemeterDic setObject:[NSNumber numberWithDouble:userCoord.longitude] forKey:@"longitude"];
    [vParemeterDic setObject:[NSNumber numberWithDouble:userCoord.latitude] forKey:@"latitude"];
    
    NSData *vReturnData = [NetManager postToURLSynchronous:APPURL102 Paremeter:vParemeterDic timeout:30 RequestName:@"程序初始化"];
    NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
    NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
    if (vDataDic.count > 0) {
        if (self.applicationInitDic == Nil) {
            self.applicationInitDic = [[NSDictionary alloc] initWithDictionary:vDataDic];
        }
        //初始化选择的地区信息
        [self initActivityChosedPlace];
    }
}

-(void)initActivityChosedPlace{
    //获取省ID省名字
    id vProvinceId = [[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"provinceId"];
    IFISNILFORNUMBER(vProvinceId);
    NSString *vName = [ActivityRouteManeger getProvinceName];
    IFISNIL(vName);
    //获取城市id
    NSNumber *vCityID = [[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"cityId"];
    IFISNILFORNUMBER(vCityID);
    //获取区域id
    NSNumber *vDistrictID = [[TerminalData instanceTerminalData].applicationInitDic objectForKey:@"districtId"];
    IFISNILFORNUMBER(vDistrictID);
    //拼接成新的字典
    NSDictionary *vProvinceDic = [NSDictionary dictionaryWithObjectsAndKeys:vProvinceId,@"id",vName,@"name",nil];
    NSDictionary *vCityDic = [NSDictionary dictionaryWithObjectsAndKeys:vCityID,@"id",@"",@"name", nil];
    NSDictionary *vDistrictDic = [NSDictionary dictionaryWithObjectsAndKeys:vDistrictID,@"id",@"",@"name",nil];
    //初始化选择的地区信息为服务器返回的地区
    NSDictionary *vChosedPlaceDic = [[NSDictionary alloc ]initWithObjectsAndKeys:vProvinceDic,@"province",vCityDic,@"city",vDistrictDic,@"district", nil];
    [ActivityRouteManeger shareActivityManeger].chosedPlaceDic = vChosedPlaceDic;
}
@end

