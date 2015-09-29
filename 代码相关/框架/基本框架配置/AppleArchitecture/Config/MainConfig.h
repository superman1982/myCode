//
//  MainConfig.h
//
//  Jackson.He/Users/adinphone/Library/Application Support/iPhone Simulator/5.1/Applications/17BEB130-F372-4EBF-9A68-A59A74BF4F97/Library/Caches/source/iChengDu/app/articleList.js
//  本文件保存对整个程序的配置值，通过该文件的配置，使客户端能够适应大多数的变化
//

#define WebMCMS                 @"mcms/"
// 模板名字
#define TEMPLATENAME            @"iChengDu"
// 主ViewController的名字
#define MAINVIEWCONTROLLERNAME  @"MainViewController"
// 装机类型
#define RUNTYPE                 @"0"    // 0下载安装，1定制安装

#import "ConstDef.h"

// 控制服务器地址
//static const char MCMSMainURL[] = "http://192.168.1.220:9090/";
static const char MCMSMainURL[] = "http://222.211.85.224:9191/";

// 主界面是否要显示消息推送栏目，现阶段主要是针对TOM的版式
static const BOOL ISSHOWPUSHSECTION = YES;

// 当前模式是否是调试模式
static const BOOL ISDEBUG = NO;

@interface MainConfig : NSObject;
// 启动页面出错时的字体颜色
+ (UIColor *) getStartHintColor;

@end


//登录界面控件项目
#define ACOUNTNAME               @"登录账号"
#define LOGINPASSWORD            @"登录密码"
#define REMEMBERPASSWORD         @"记住密码"
#define SERVICEIP                @"服务器地址设置"

//中唯养护巡检（默认首页）
#define MESSAGECENTER            @"消息中心"
#define NEEDDEALTASK             @"代办任务"
#define FIXINFORMATION           @"维修动态"
#define INSPECTINFORMATION       @"巡查动态"
#define DISASTERINFORMATION      @"灾害抢险"
#define MESSAGENOTICE            @"通知公告"

typedef enum{
    btMESSAGECENTERTag,
    btNEEDDEALTASKTag,
    btFIXINFORMATIONTag,
    btINSPECTINFORMATIONTag,
    btDISASTERINFORMATIONTag,
    btMESSAGENOTICETag,
    btDaoLuJianChaTag,
    btQiaoShuiHanTag,
    btWeiXiuDongTaiTag,
    btRenWuGuanLiTag,
    btSuiShouJiTag,
    btLuKuangDongTaiTag,
    btShouYeTag,
    btZongHeChaXunTag,
    btSheZiTag,
}DefaultHomeButtonTag;
