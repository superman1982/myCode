//
//  BaseView.m
//  iPad
//


#import "BaseView.h"
#import "BaseViewController.h"

@implementation BaseView

#pragma mark -
#pragma mark 系统方法
- (id) initWithFrame: (CGRect) aFrame {
    self = [super initWithFrame: aFrame];
    if (self != nil) {
        mIsPortait = YES;
        
        mIsNeedTopNavBar = NO;
        mFirstTop = 0;
        // 手机需要生成上面的导航栏
        if (![TerminalData isPad]) {
            mIsNeedTopNavBar = YES;
            
            mFirstTop = 50;
        }
        
		self.backgroundColor = [UIColor whiteColor];	
    }
    return self;
}

- (id) init {
	self = [super init];
	if (self != nil) { 
        mIsPortait = YES;
        
        mIsNeedTopNavBar = NO;
        mFirstTop = 0;
        // 手机需要生成上面的导航栏
        if (![TerminalData isPad]) {
            mIsNeedTopNavBar = YES;
            
            mFirstTop = 50;
        }
        
		self.backgroundColor = [UIColor whiteColor];		
	}
	return self;
}

// dealloc函数 
- (void) dealloc {
    if (mTopNavBar != nil) {
        SAFE_ARC_RELEASE(mTopNavBar);
		mTopNavBar = nil;
    }
    
    if (mNavBarImageView != nil) {
        SAFE_ARC_RELEASE(mNavBarImageView);
		mNavBarImageView = nil;
    }
    
    if (mTopLogo != nil) {
        SAFE_ARC_RELEASE(mTopLogo);
		mTopLogo = nil;
    }
    
    if (mTopReturn != nil) {
        SAFE_ARC_RELEASE(mTopReturn);
		mTopReturn = nil;
    }
    
    if (mRedLineView != nil) {
        SAFE_ARC_RELEASE(mRedLineView);
        mRedLineView = nil;
    }
    
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -
#pragma mark 自定义类方法
// 创建顶部导航栏或是重新设置顶部导航栏的布局
- (void) initTopNavBar {	
    if (!mIsNeedTopNavBar) {
        return;
    }
    
    mWidth = [TerminalData deviceWidth];
    CGRect vFrame = CGRectMake(0, 0, mWidth, 50);
    if (mTopNavBar == nil) {
        // 生成mTopNavBar对象，并初始化Frame 
        mTopNavBar = [[UIView alloc] initWithFrame: vFrame];	 
        
        // 加载到自己的view
        [self addSubview: mTopNavBar];	
        // 设置背景图片
		mNavBarImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @""]];
        // 设置背景图片的大小
        mNavBarImageView.frame = mTopNavBar.bounds;
        mNavBarImageView.alpha = 4;
        mNavBarImageView.contentMode = UIViewContentModeScaleToFill;
        [mTopNavBar addSubview: mNavBarImageView];
    } else {
        [mTopNavBar setFrame: vFrame];
        // 设置内部ImageView的Frame
		for (UIView* vTmpImageView in mTopNavBar.subviews) {
			if ([vTmpImageView isKindOfClass: [UIImageView class]]) {
				vTmpImageView.frame = mTopNavBar.bounds;
			}
		}
    }
    
}

// 导航栏上的返回按钮事件
- (void) returnBtnTouchDown: (id) sender {
    // BaseViewController* vTmpVC = [self getOwnBaseViewController];
}

// 获取BaseView本身的BaseViewController
- (BaseViewController*) getOwnBaseViewController {
    for (UIView* vNext = [self superview]; (vNext != nil); vNext = [vNext superview]) {
        UIResponder* vNextResponder = [vNext nextResponder];
        if ([vNextResponder isKindOfClass: [BaseViewController class]]) {
            return (BaseViewController*) vNextResponder;
        }
    }
    return nil;
}

// 获取当前是否是竖屏
- (BOOL) getIsPortait {
    return mIsPortait;
}

// 根据横竖屏设置当前的布局状态
- (void) setLayout: (BOOL) aIsPortait {
    
}

// 返回事件处理
- (void) back {
    // 返回事件默认为返回到主界面
    
}

// 开始运行时的处理
- (void) startRun {
    
}

// 暂停操作时的处理
- (void) pauseRun {
    
}


@end
