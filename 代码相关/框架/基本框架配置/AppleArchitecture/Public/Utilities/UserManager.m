//
//  UserManager.m
//  iPad
//
//  Jackson.He
//

#import "UserManager.h"
#import "ConfigFile.h"
#import "NetManager.h"
#import "Function.h"
#import "MainConfig.h"
#import "ARCMacros.h"
#import "JasonManager.h"
#import "HttpDefine.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"

@implementation UserManager

static UserManager *mUserManager = nil;

// 登录成功返回的Jason串
static NSString *mLoginJasonStr  = nil;
// 用户名字
static NSString *mUserName = nil;
// 用户密码
static NSString *mUserPassword  = nil;
// 用户昵称
static NSString *mUserNickName = nil;
// 用户ID
static NSString *mUserID = nil;
// 部门ID
static NSString *mDeptID = nil;
// 是否已登录
static BOOL mIsLogin = NO;

static bool mIsRememberUserAcount = NO;

static bool mIsUNLogin = NO;

+ (UserManager *) instanceUserManager {
	@synchronized(self) {
		if (mUserManager == nil) {
#if __has_feature(objc_arc)
            mUserManager = [[UserManager alloc] init];
#else
            mUserManager = [NSAllocateObject([self class], 0 , NULL) init];
#endif
		}
		return mUserManager;
	}
}

#if __has_feature(objc_arc)
#else
// 每一次alloc都必须经过allocWithZone方法，覆盖allWithZone方法，
// 每次alloc都必须经过Instance方法，这样能够保证肯定只有一个实例化的对象
+ (id) allocWithZone: (NSZone *)zone {
    @synchronized(self) {
    if (mUserManager == nil) {
        mUserManager = [super allocWithZone:zone];
    }
    
    return mUserManager;
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

-(void)dealloc{
    [mUserName release];
    [mUserPassword release];
    [_userInfo release];
    [_userID release];
    [super dealloc];
}

#endif

- (id) init {
	self = [super init];
	if (self != nil) {
        mUserName = @"";
        mUserPassword = @"";
        mUserNickName = @"";
        mIsLogin = NO;
	}
	return self;
}

//用户坐标位置
-(CLLocationCoordinate2D)userCoord
{
    double vLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"] doubleValue];
    double vLongtitude = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"Longitude"]doubleValue];
    
    if (vLongtitude <= 0) {
        vLatitude = 28.251769;
        vLongtitude = 113.087488;
    }
    CLLocationCoordinate2D vUserCoord = CLLocationCoordinate2DMake(vLatitude, vLongtitude);
    
    _userCoord = vUserCoord;
    
    return _userCoord;
}
//返回用户USERID
-(id)userID{
    _userID = self.userInfo.usertId;
    IFISNIL(_userID);
    return _userID;
}

-(void)setUserInfomation:(NSDictionary *)aDic{
    if (![aDic isKindOfClass:[NSDictionary class]]) {
        LOGERROR(@"setUserInfomation");
    }
    if (_userInfo == Nil) {
        _userInfo = [[UserInfo alloc] init];
    }
    self.userInfo.provinceId = [aDic objectForKey:@"provinceId"];
    IFISNILFORNUMBER(self.userInfo.provinceId );
    self.userInfo.cityId = [aDic objectForKey:@"cityId"];
    IFISNILFORNUMBER(self.userInfo.cityId );
    self.userInfo.districtId = [aDic objectForKey:@"districtId"];
    IFISNILFORNUMBER(self.userInfo.districtId);
    self.userInfo.usertId = [aDic objectForKey:@"userId"];
    IFISNIL(self.userInfo.usertId );
    self.userInfo.realName = [aDic objectForKey:@"realName"];
    IFISNIL(self.userInfo.realName);
    self.userInfo.idNumber = [aDic objectForKey:@"idNumber"];
    IFISNILFORNUMBER(self.userInfo.idNumber);
    //获取身份证图片
    NSMutableArray *vIDArray = [NSMutableArray array];
    id vIDImages = [aDic objectForKey:@"idImgs"];
    for (id vIDStr in vIDImages) {
        [vIDArray addObject:vIDStr];
    }
    self.userInfo.idImgs = vIDArray;
    
    self.userInfo.isAudit = [aDic objectForKey:@"isAudit"];
    IFISNILFORNUMBER(self.userInfo.isAudit);
    self.userInfo.birthday = [aDic objectForKey:@"birthday"];
    IFISNIL(self.userInfo.birthday);
    self.userInfo.phone = [aDic objectForKey:@"phone"];
    IFISNIL( self.userInfo.phone);
    self.userInfo.sex = [aDic objectForKey:@"sex"];
    IFISNIL(self.userInfo.sex);
    self.userInfo.QQ = [aDic objectForKey:@"QQ"];
    IFISNIL(self.userInfo.QQ);
    self.userInfo.email = [aDic objectForKey:@"email"];
    IFISNIL(self.userInfo.email);
    self.userInfo.residence = [aDic objectForKey:@"residence"];
    IFISNIL(self.userInfo.residence);
    self.userInfo.headerImageUrl = [aDic objectForKey:@"headerImageUrl"];
    IFISNIL(self.userInfo.headerImageUrl);
    self.userInfo.nickname = [aDic objectForKey:@"nickname"];
    IFISNIL(self.userInfo.nickname);
    self.userInfo.signature = [aDic objectForKey:@"signature"];
    IFISNIL(self.userInfo.signature);
    self.userInfo.isSetPayPassword = [aDic objectForKey:@"isSetPayPassword"];
    IFISNILFORNUMBER(self.userInfo.isSetPayPassword);
    self.userInfo.directMessage = [aDic objectForKey:@"directMessage"];
    IFISNILFORNUMBER(self.userInfo.directMessage);
    self.userInfo.registerFrom  = [aDic objectForKey:@"registerFrom"];
    IFISNIL(self.userInfo.registerFrom );
    self.userInfo.isAllowInvite = [aDic objectForKey:@"isAllowInvite"];
    IFISNILFORNUMBER(self.userInfo.isAllowInvite);
    self.userInfo.rechargeMoney = [aDic objectForKey:@"rechargeMoney"];
    IFISNILFORNUMBER(self.userInfo.rechargeMoney);
    self.userInfo.giveMoney = [aDic objectForKey:@"giveMoney"];
    IFISNILFORNUMBER(self.userInfo.giveMoney);
    self.userInfo.isPaySms = [aDic objectForKey:@"isPaySms"];
    IFISNILFORNUMBER(self.userInfo.isPaySms);
    self.userInfo.alertMessage = [aDic objectForKey:@"alertMessage"];
    IFISNILFORNUMBER(self.userInfo.alertMessage);
    self.userInfo.memberTime = [aDic objectForKey:@"memberTime"];
    IFISNIL(self.userInfo.memberTime);
    self.userInfo.memberLeverId = [aDic objectForKey:@"memberLeverId"];
    IFISNILFORNUMBER(self.userInfo.memberLeverId);
    self.userInfo.memberLeverName = [aDic objectForKey:@"memberLeverName"];
    IFISNIL(self.userInfo.memberLeverName);
    self.userInfo.memberLeverImageUrl = [aDic objectForKey:@"memberLeverImageUrl"];
    IFISNIL(self.userInfo.memberLeverImageUrl);
    
    //获取会员卡
    NSMutableArray *vMemberCardArray = [NSMutableArray array];
    id vMemberCards = [aDic objectForKey:@"memberCard"];
    for (id vICardDic in vMemberCards) {
        [vMemberCardArray addObject:vICardDic];
    }
    self.userInfo.memberCard = vMemberCardArray;
}

+(BOOL)checkIfIsAutoLoginWithCompletionBlock:(void (^)(void))block{
    //读取用户信息
    NSDictionary *vConfigDic = [ConfigFile readConfigDictionary];
    NSString *vUserName = [vConfigDic objectForKey:USER];
    NSString *vPassWord = [vConfigDic objectForKey:PASSWORD];
    //是否是自动登录
    mIsUNLogin = [[vConfigDic objectForKey:ISUNLOGIN] boolValue];
    //是否记住用户密码
    mIsRememberUserAcount = [[vConfigDic objectForKey:ISREMEMBERUSERACOUNT] boolValue];
    //如果没有注销应用程序，那么就自动登录
    if (!mIsUNLogin && (vUserName.length> 0) && (vPassWord.length > 0)) {
         [UserManager login:vUserName password:vPassWord IsRemberUserAcount:mIsRememberUserAcount Notice:nil Success:^(NSURLResponse *response, id responseObject) {
             if (block) {
                 block();
             }
         }];
    }
    return mIsLogin;
}

// 获取用户名和用户密码
+ (void) getUserName: (NSString **) aUserName userPassword: (NSString **) aUserPassword {
    *aUserName = mUserName;
    *aUserPassword = mUserPassword;
}

// 获取用户昵称
+ (void) getUserNickName: (NSString **) aUserNickName {
    *aUserNickName = mUserNickName;
}

// 获取用户ID以及部站ID
+ (void) getUserID: (NSString **) aUserID deptID: (NSString **) aDeptID {
    *aUserID = mUserID;
    *aDeptID = mDeptID;
}

// 获取当前是否登录
+ (BOOL) isLogin {
    return mIsLogin;
}

// 登录异步
+ (void) login: (NSString *) aUserName password:(NSString *) aUserPassword IsRemberUserAcount:(BOOL)aRemember  Notice:(NSString *)aNotice Success:(void (^)(NSURLResponse *response,id responseObject))aSuccess {
    if (aUserName == Nil) {
        LOGERROR(@"login:password:");
        return ;
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:aUserName forKey:@"username"];
    [dataDict setObject:aUserPassword forKey:@"password"];
 
    [NetManager postDataFromWebAsynchronous:APPURL201 Paremeter:dataDict Success:^(NSURLResponse *response, id responseObject) {
        
        NSDictionary *vReturnDic = [NetManager jsonToDic:responseObject];
        //显示登陆信息
        NSString *resMessage = [vReturnDic objectForKey:@"stateMessage"];
        //判断是否登陆成功
        NSDictionary *vDataDic = [vReturnDic objectForKey:@"data"];
        if (vDataDic.count > 0) {
            [[UserManager instanceUserManager] setUserInfomation:vDataDic];
            if (aNotice != nil) {
                [SVProgressHUD showSuccessWithStatus:resMessage];
            }
            //保存用户信息
            [ConfigFile saveUserinfo: aUserName passWord: aUserPassword isRemeberUserAcount:aRemember isUNLogin:NO];
            mUserName = [[NSString alloc ]initWithString:aUserName ];
            mUserPassword = [[NSString alloc ]initWithString:aUserPassword];
            //保存登录标致
            mIsLogin = YES;
            //是否记住密码
            mIsRememberUserAcount = aRemember;
            
            if (aSuccess) {
                aSuccess(response,responseObject);
            }
        }else{
            [SVProgressHUD showErrorWithStatus:resMessage];
        }

    } Failure:^(NSURLResponse *response, NSError *error) {
        
    } RequestName:@"登录" Notice:aNotice];

}

// 修改密码
+ (BOOL) modifyPWD: (NSString *) aOldPWD newPWD: (NSString *) aNewPWD {
    // 这里组成字符串
    NSString *vUpdatePWDURL = [NSString stringWithFormat: @"%@/%@%@?%@%@&%@%@&%@%@",
                               @"",
                               WebMCMS,
                               @"reader!updatePassword.action",
                               @"currLoginUser=", mUserName,
                               @"oldPwd=", aOldPWD,
                               @"newPwd=", aNewPWD];
    
    NSString *vURLEncodedStr = [vUpdatePWDURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSData *vReturnData = [NetManager postToURL: vURLEncodedStr timeout: 5];
    // 返回的结果与vReturnData相关
    if (vReturnData == nil) {
        [Function showMessage: @"远端服务器返回数据出错,请检查网络！" delegate: nil];
        return NO;
    }
    
    NSString *vReturnStr = [[NSString alloc] initWithData: vReturnData encoding: NSUTF8StringEncoding];
    @try {
        if ([[vReturnStr lowercaseString] hasPrefix: @"{\"id\":"]) {
            mUserPassword = aNewPWD;
            // 将当前的用户名等信息存入到配置文件中
            [ConfigFile saveUserinfo: mUserName passWord: mUserPassword isRemeberUserAcount:mIsRememberUserAcount isUNLogin:NO];
            
            [Function showMessage: @"密码修改成功！" delegate: nil];
            return YES;    
        } else if ([[vReturnStr lowercaseString] hasPrefix: @"{\"error\":\"oldpwderror\"}"]) {        
            [Function showMessage: @"旧密码错误，密码修改不成功！" delegate: nil];
            return NO;    
        } else {
            [Function showMessage: @"其它错误，密码修改不成功！" delegate: nil];
            return NO;    
        }
    } @finally {
        SAFE_ARC_RELEASE(vReturnStr);
    }
}

// 获取登录成功后的返回Jason
+ (NSString *) getLoginJasonStr {
    return mLoginJasonStr;
}

// 是否是自动登录
+ (BOOL) isAutoLogin {
    NSDictionary *vConfigDic = [ConfigFile readConfigDictionary];
    if (vConfigDic.count > 0) {
        id vIsUnLogin = [vConfigDic objectForKey:ISUNLOGIN];
        if (vIsUnLogin != nil) {
            mIsUNLogin =[vIsUnLogin boolValue];
            return !mIsUNLogin;
        }
    }
    return NO;
}

// 注销
+ (void) unLogin {
    mUserNickName = @"";
    mLoginJasonStr = @"";
    mIsLogin = NO;
    //注销标致为YES
    mIsUNLogin = YES;
    [UserManager instanceUserManager].userInfo = Nil;
    //将当前的用户名等信息存入到配置文件中
    [ConfigFile saveUserinfo: mUserName passWord: mUserPassword isRemeberUserAcount: mIsRememberUserAcount isUNLogin:mIsUNLogin];

}

// 注册
+ (NSDictionary *) registerUser:(NSDictionary *)aParemeter{
    // 这里组成字符串
    [SVProgressHUD showWithStatus:@""];

    NSData *vReturnData = [NetManager postToURLSynchronous:APPURL202 Paremeter:aParemeter timeout:5 RequestName:@"注册"];
    NSDictionary *vReturnDic = [NetManager jsonToDic:vReturnData];
    //显示注册信息
    NSString *resMessage = [vReturnDic objectForKey:@"stateMessage"];
    //获取返回注册数据
    NSDictionary *vdataDic = [vReturnDic objectForKey:@"data"];
    if (vdataDic.count > 0) {
        mIsLogin = YES;
        [[UserManager instanceUserManager] setUserInfomation:vdataDic];
        [SVProgressHUD showSuccessWithStatus:resMessage];
        return vdataDic;
    }else{
        [SVProgressHUD showErrorWithStatus:resMessage];
        return Nil;
    }
    
    return Nil;
}

// 用户反馈
+ (BOOL) userFeedback: (NSString *) aTitle
         feedbackType: (NSString *) aType
      feedbackContent: (NSString *) aContent {
    NSString *vUserID = mUserID;
    NSString *vUserName = mUserName;
    if (mUserID == nil || mUserID.length <= 0) {
        vUserID = @"";
        vUserName = @"";
    }
    
    // 这里组成字符串
    NSString *vFeedBackURL = [NSString stringWithFormat: @"%@/%@%@?%@%@&%@%@&%@%@&%@%@&%@%@",
                              @"",
                              WebMCMS,
                              @"feedback!save.action",
                              @"entity.readerId=", vUserID, 
                              @"entity.readerName=", vUserName,
                              @"entity.title=", aTitle,
                              @"entity.type=", aType,
                              @"entity.content=", aContent];
    
    NSString *vURLEncodedStr = [vFeedBackURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSData *vReturnData = [NetManager postToURL: vURLEncodedStr timeout: 5];
    // 返回的结果与vReturnData相关
    if (vReturnData == nil) {
        [Function showMessage: @"远端服务器返回数据出错！" delegate: nil];
        return NO;
    }
    
    NSString *vReturnStr = [[NSString alloc] initWithData: vReturnData encoding: NSUTF8StringEncoding];
    @try {
        if ([[vReturnStr lowercaseString] hasPrefix: @"{\"result\":\"success\"}"]) {
            [Function showMessage: @"反馈成功！" delegate: nil];     
            return YES;
        } else {
            [Function showMessage: @"反馈过程出错，请重试！" delegate: nil];     
            return NO;
        }
    } @finally {
        SAFE_ARC_RELEASE(vReturnStr);
    }
}

@end
