//
//  ConstDef.h
//  iPhone
//
//  Jackson
//  一些常量的定义
//

#define START_NETWORKERROR          @"尊敬的用户，您现在没有连接互联网！请连上互联网后阅读精彩内容。"
#define START_SERVERERROR           @"尊敬的用户，您目前无法连接数据服务器(或数据服务器返回数据出错)！请稍后再阅读精彩内容。"

// 以下是与配置相关的一些常量定义
#define MCMSCONFIG_FILE                     @"mcms.config"

#define RESOURCE_VERSION_FILE               @"resourceversion.config"
#define RESOURCE_TYPE                       @"resourcetype"
#define RESOURCE_VERSION                    @"resourceversion"

#define DEVICETOKEN_FILE                    @"devicetoken.config"
#define DEVICETOKEN                         @"devicetoken"

#define USER                                @"user"
#define PASSWORD							@"password"
#define ISREMEMBERUSERACOUNT                @"rememberUserAcount"
#define ISUNLOGIN                           @"isunlogin"

#define SHARE                               @"share"

#define ACTIVE_TERMINALID                   @"activeterminalid"
#define START_CLEAR_CACHE                   @"startclearcache"
#define AUTO_PUSH_NEWS                      @"autopushnews"

#define FAVLIST_FILE                        @"favlist.config"
#define FAV_TITLE                           @"favtitle"
#define FAV_URL                             @"favurl"

#define MAX_CACHE                           @"maxcache"

#define PUSH_MESSAGE_FILE                   @"PushMessage.pm"
#define PUSH_TYPE                           @"PushType"
#define PUSH_KEY                            @"PushKey"
#define PUSH_CONTENT                        @"PushContent"


#define ROOTDIR                             @"/Library/Caches/source/"
//当前模拟坐标
#define CURRENTLATITUDE                     28.251769
#define CURRENTLONGTITUDE                   113.087488
//-------------

//百度地图key
#define BaiDuMapKey                         @"AMimqW7myRiUMei82076Y2gP"
//百度云表key
#define     BAIDUAK                    @"betzfsyidvDLhUG5uvH5vucC"
//百度云地址
#define     BAIDUCLOUNDURL             @"http://api.map.baidu.com/geosearch/v3/"
//版本检测地址
#define     VERSIONCHECKURLSTR            @"http://www.hnqlhr.com/services/ios/iosdownload.html"
//百度搜索
#define     BAIDUSEARCHURL             @"http://api.map.baidu.com/place/v2/search?"
//搜索半径
#define     BAIDURADIUS                5000
//-----------------------
//图片缓存目录
#define CACHEFILEPATH                       @"testcache.com"

#define ELETRONICZIPEDFILENAME                   @"/EletronicBookData/Ziped"
#define ELETRONICUNZIPEDFILENAME                 @"/EletronicBookData/UNZiped"
// 自定义排序类型
typedef enum {
    stStar = 0,     // 星级
    stPrice,        // 价格
    stDistance,     // 距离
    stAuthenticate, // 认证
} SortType;

// 自定义搜索类型
typedef enum {
    stWash_Consmetology = 1,    // 洗车美容
    stMaintenance,              // 维修保养
    stRefit,                    // 改装装饰
    stChauffeur_Drive,          // 代驾
    stMuFu,                     // 模糊搜索
    stTyre,                     // 轮胎
    stAssist,                   // 救援
    stGasstation,               // 加油站
    stStopstation,              // 停车场
    stViewPoint,                //景点
    stFood,                     //美食
    stHotel,                    //酒店
    stCasula,                    //休闲
    stLive,                       //生活
    stOther,                     //其他
    stAgent,                     //代办
    stSceneSite,                 //景点站点
} SearchType;

// 照片类型
typedef enum {
    ptIDCard = 1,           // 身份证
    ptDriveLisence,         // 驾照
    ptRoadLisence,      // 行驶证
    ptBunessInsurance,        // 商业险
    ptJiaoQiangInsurance,    //交强险
    ptBuness = 9,            //商家
    ptSelfPhoto,
} PhotoType;

struct BaiDuCould{
    NSInteger bdBeginStar;
    NSInteger bdDistance;
    NSInteger bdPageIndex;
    NSInteger bdPageSize;
};

// 下载数据的状态
typedef enum {
    dsOK = 0,           // 下载成功
    dsNetError,         // 无网络
    dsServerError,      // 网络正常，远端服务器有问题
    dsDataError,        // 下载的数据有问题
} DownloadState;

// 下载数据的状态
typedef enum {
    atActiveRoutes = 1,           // 活动路书
    atRecomendRoutes,         // 推荐路书
} ActiveType;


