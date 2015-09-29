//
//  BaseView.h
//  iPad
//
//  Jackson.He
//  所有View的基类，提供back，startRun，pauseRun，setLayout等方法，
//  为了支持横竖屏转换，建议直接使用TerminalData中的高度、宽度来绝对布局
//

#import <UIKit/UIKit.h>
#import "TerminalData.h"
#import "Function.h"

@class BaseViewController;
@interface BaseView : UIView {
    // 宽度
    int mWidth;
    // 高度
    int mHeight;
    // 当前是否是竖屏
    BOOL mIsPortait;
    
    // 由于手机和Pad的版本不一样，手机上这几个View是有最上面的状态栏，而Pad的状态栏由于是放在弹出窗口上来处理，所以不太一样
    BOOL mIsNeedTopNavBar;
    // 顶部导航栏
    UIView *mTopNavBar;
    UIImageView *mNavBarImageView;
    // 顶部TopLogo
    UIView *mTopLogo; 
    // 顶部返回按钮
    UIButton *mTopReturn; 
    
    // 除了TopNavBar后的第一个控件离顶部的高度 
    int mFirstTop;
    
    // 顶部工具栏下的那条红线
    UIView* mRedLineView;
}

// 创建顶部导航栏或是重新设置顶部导航栏的布局
- (void) initTopNavBar;
// 导航栏上的返回按钮事件
- (void) returnBtnTouchDown: (id) sender;

// 获取BaseView本身的BaseViewController
- (BaseViewController*) getOwnBaseViewController;

// 获取当前是否是竖屏
- (BOOL) getIsPortait;

// 设置当前的布局状态
- (void) setLayout: (BOOL) aPortait;

// 返回事件处理
- (void) back;

// 开始运行时的处理
- (void) startRun;

// 暂停操作时的处理
- (void) pauseRun;
@end
