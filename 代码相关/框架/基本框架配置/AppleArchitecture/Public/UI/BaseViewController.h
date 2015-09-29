//
//  BaseViewController.h
//  iPad
//
//  Jackson.He
//  所有ViewController的基类，与BaseView配合使用，完成View的显示
//  提供了一个方法showBaseViw用来加载View，加载过程中会处理一些事情，并且自动的完成横竖屏的切换
//

/*
 init/loadView/viewDidLoad/viewDidUnload/dealloc 
 
 init方法：
 在init方法中实例化必要的对象(遵从LazyLoad思想),‍init方法中初始化ViewController本身
 
 loadView方法：
 当view需要被展示而它却是nil时，viewController会调用该方法。不要直接调用该方法。
 如果手工维护views，必须重载重写该方法；如果使用NIB维护views，必须不能重载重写该方法
 loadView和NIB构建view
 如果在控制器中实现了loadView方法，那么可能会在应用运行的某个时候被内存管理控制调用。如果设备内存不足的时候，view 控制器会收到didReceiveMemoryWarning的消息。默认的实现是检查当前控制器的view是否在使用。如果它的view不在当前正在使用的 view hierarchy里面，且你的控制器实现了loadView方法，那么这个view将被release, loadView方法将被再次调用来创建一个新的view。
 
 viewDidLoad方法：
 viewDidLoad 此方法只有当view从nib文件初始化的时候才被调用。在iPhone OS 3.0及之后的版本中，还应该重载重写viewDidUnload来释放对view的任何索引
 ‍
 viewDidUnload方法‍
 当系统内存吃紧的时候会调用该方法(注：viewController没有被dealloc)
 内存吃紧时，在iPhone OS 3.0之前didReceiveMemoryWarning是释放无用内存的唯一方式，但是OS 3.0及以后viewDidUnload方法是更好的方式
 在该方法中将所有IBOutlet(无论是property还是实例变量)置为nil(系统release view时已经将其release掉了)
 在该方法中释放其他与view有关的对象、其他在运行时创建(但非系统必须)的对象、在viewDidLoad中被创建的对象、缓存数据等 release对象后，将对象置为nil(IBOutlet只需要将其置为nil，系统release view时已经将其release掉了)
 一般认为viewDidUnload是viewDidLoad的镜像，因为当view被重新请求时，viewDidLoad还会重新被执行,viewDidUnload中被release的对象必须是很容易被重新创建的对象(比如在viewDidLoad或其他方法中创建的对象)，不要release用户数据或其他很难被重新创建的对象
 
 dealloc方法:
 viewDidUnload和dealloc方法没有关联，dealloc还是继续做它该做的事情
 */

#import <UIKit/UIKit.h>
#import "TerminalData.h"
#import "WaitingView.h"
#import "AnimationTransition.h"
#import "ViewControllerManager.h"
#import "MainConfig.h"
#import "Macros.h"
#import "ClickableTableView.h"
#import "WelcomeVC.h"


#define  NAVIBARHIGHT              44

@class BaseViewController;

@protocol PopoverControllerCloseDelegate<NSObject>
// 弹出窗口关闭时做的一些事件
- (void) popoverControllerCloseAction: (BaseViewController *) aBaseViewController;

// 弹出窗口根据View类型，调整自己的大小
- (void) popoverControllerAdjustSize: (NSString *) aViewName;
@end

@class ViewManager;

@interface BaseViewController : UIViewController<ClickableTableViewDelegate,WelcomeVCDeleate> {
    // 宽度
    int mWidth;
    // 高度
    int mHeight;
    // 当前是否是竖屏
    BOOL mIsPortait;
    // 终端单例类
    TerminalData* mTerminalData;
    
    // 导航栏
    UIView *mTopNavigationBar;
    UIImageView* mTopNaBarImageView;
    // 返回按钮
    UIButton *mTopBackButton;
    // 顶部TopLogo
    UIView *mTopLogo;
    
    // PopoverControllerCloseDelegate代理
//    id mPopoverDelegate;
	
    ViewManager *mViewManager;
    WaitingView *mWaitingView;
    //是否显示中文键盘
    BOOL isShowChanese;
    //是否需要移动ViewFrame
    BOOL isNeedToMoveFrame;
}

@property(nonatomic, assign) id<PopoverControllerCloseDelegate> popoverDelegate;

@property (nonatomic,retain) NSString *backButtonNormalImageStr;
@property (nonatomic,retain) NSString *backButtonHelightImageStr;
@property (nonatomic,assign) BOOL      showWelCome;
// 开始等待状态
- (void) startWaitingAnimation: (NSString *) aHintStr;
// 结束等待状态
- (void) stopWaitingAnimation;

// 初始化Navbar
- (void) initTopNavBar;
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

// 将弹出窗体显示在对应的UIView中间
- (void) showPopoverController: (UIPopoverController *) aPopoverController onView: (UIView *) aUIView;

-(void)setShowBackButton:(BOOL)aShow;

- (void)viewShouldUnLoad;

- (void)textFieldDidBeginEditing:(UITextField *)textField;
//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField;
//收到内存警告
- (void)didReceiveMemoryWarning;
@end


