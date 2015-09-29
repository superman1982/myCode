//
//  iPadAppDelegate.h
//  iPad
//
//  Jackson.He
//

#import <UIKit/UIKit.h>
#import "TerminalData.h"

@class BaseViewController;

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
@private
    // 终端单例类
    TerminalData *mTerminalData;
    // 主要用于区分是重新激活还是重新启动
    BOOL mIsLoadData;
    // 当前程序是否是在后台运行
    BOOL mIsBackgroundRun;
    // 进入后台时的时间
    NSString *mEnterBackgroundTime;
    // 是否需要重新加载数据(根据)
    BOOL mIsReloadData;
    Reachability *mInternetReach;
}

@property (strong, nonatomic) UIWindow *window;

@end

