//
//  UserManager.h
//  iPad
//
//  Jackson.He
//  用户安全管理类，用来管理登录，注册，注销等
//

#import "ARCMacros.h"
#import "UserInfo.h"
#import <CoreLocation/CoreLocation.h>

@protocol UserManager <NSObject>


@end

@interface UserManager : NSObject
//用户坐标
@property (nonatomic,assign) CLLocationCoordinate2D userCoord;
//用户登录后返回信息
@property (nonatomic,retain) UserInfo *userInfo;
//用户ID
@property (nonatomic,retain) id userID;

+ (UserManager *) instanceUserManager;
//设置用户信息
-(void)setUserInfomation:(NSDictionary *)aDic;

// 获取用户名和用户密码
+ (void) getUserName: (NSString **) aUserName userPassword: (NSString **) aUserPassword;
// 获取用户昵称
+ (void) getUserNickName: (NSString **) aUserNickName;
// 获取用户ID以及部站ID
+ (void) getUserID: (NSString **) aUserID deptID: (NSString **) aDeptID;
// 获取当前是否登录
+ (BOOL) isLogin;
// 登录异步
+ (void) login: (NSString *) aUserName password:(NSString *) aUserPassword IsRemberUserAcount:(BOOL)aRemember  Notice:(NSString *)aNotice Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess;
// 修改密码
+ (BOOL) modifyPWD: (NSString *) aOldPWD newPWD: (NSString *) aNewPWD;
// 获取登录成功后的返回Jason
+ (NSString *) getLoginJasonStr;
// 是否是自动登录
+ (BOOL) isAutoLogin;
// 注销
+ (void) unLogin;
// 注册
+ (NSDictionary *) registerUser:(NSDictionary *)aParemeter;
// 用户反馈
+ (BOOL) userFeedback: (NSString *) aTitle
         feedbackType: (NSString *) aType
      feedbackContent: (NSString *) aContent;

//程序启动时检查是否是自动登录
+(BOOL)checkIfIsAutoLoginWithCompletionBlock:(void (^)(void))block;
@end
