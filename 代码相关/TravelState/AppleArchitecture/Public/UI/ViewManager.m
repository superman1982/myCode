//
//  ViewManager.m
//  AppleArchitecture
//
//  Jackson.He
//

#import "ViewManager.h"
#import "AnimationTransition.h"

@interface ViewManager ()
// 增加aBaseView到字典中
- (void) addBaseView: (BaseView *) aBaseView;
// 动画显示结束后要做的事情，需要配合ShowBaseView一起使用，如果子类需要扩展可以直接覆盖本函数就可以
- (void) endShowBaseView;
@end;

@implementation ViewManager

@synthesize baseViewController = mBaseViewController;

// 根据aBaseViewName创建BaseView
- (void) createView: (NSString *) aBaseViewName {
    // 根据类名取得类
    Class vVCClass = NSClassFromString(aBaseViewName);
    id vBaseView = [[vVCClass alloc] init];
    SAFE_ARC_AUTORELEASE(vBaseView);
    if (![vBaseView isKindOfClass: [BaseView class]]) {
        return;
    }
    
    // 将生成的BaseViewCoontroller加入到管理中
    [self addBaseView: vBaseView];
}

// 增加aBaseView到字典中
- (void) addBaseView: (BaseView *) aBaseView {
    if (mBaseViewController == nil) {
        return;
    }
    
    // 所有的子ViewController都是加入到主VC中
    if (aBaseView == nil) {
        return;
    }
    
    // 有可能存在线程，所以必须使用同步
    @synchronized(mViewHashMap) {
        if (mViewHashMap == nil) {
            mViewHashMap = [[NSMutableDictionary alloc] initWithDictionary: [NSMutableDictionary dictionary]];
        }
    }
    
    [aBaseView setHidden: YES];
    [mBaseViewController.view addSubview: aBaseView];
    // NSStringFromClass取某个对象的类名称
    // 以对象的类名称作为Key，以对象作为Value放入到mViewHashMap中
    [mViewHashMap setObject: aBaseView forKey: [NSStringFromClass([aBaseView class]) lowercaseString]];
}

// 改变当前显示的BaseView
- (void) showBaseView {
    // 如果当前的BaseViewController不为空，则需要先把当前的BaseView移除
    if (mCurrBaseView != nil) {
        // 先把要暂停的先停了
        [mCurrBaseView pauseRun];
        // 隐藏当前的BaseView
        [mCurrBaseView setHidden: YES];
    }
    
    // 看横竖屏状态，决定是否需要转屏操作
    // 如果当前View与终端的不一致才要求做转屏操作
    if ([mShowBaseView getIsPortait] != [TerminalData isPortait]) {
        [mShowBaseView setLayout: [TerminalData isPortait]];
    }
    
    // 然后再加入
    [mShowBaseView setHidden: NO];
    // 启动BaseView的startRun
    [mShowBaseView startRun];
}


// 把名字为aBaseViewName的View放置到最顶层，isBack是否是返回，animationType动画类型
- (void) showBaseView: (NSString *) aBaseViewName  AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType {
    mShowBaseView = [self getBaseView: aBaseViewName];
    // 非主窗口是不能加其它的ViewController的
    if (mShowBaseView == nil) {
        [self createView: aBaseViewName];
        return;
    }
    
    // 这里要对管理的栈进行处理
    
    // 如果需要动画切换，则增加相应的动画效果
    if (aType > 0) {
        [mCurrBaseView setHidden: NO];
        [mShowBaseView setHidden: NO];
        [UIView animateChangeView:mShowBaseView AnimationType:aType SubType:aSubType Duration:.4 CompletionBlock:^{}];
    } else {
        [self showBaseView];
    }
    mCurrBaseView = mShowBaseView;
}


// 把名字为aBaseViewName的View放置到最顶层，isBack是否是返回，animationType动画类型
- (void) showBaseView: (NSString *) aBaseViewName isBack: (BOOL) aIsBack animationDirection: (NSString *) aAnimationDirection {
    mShowBaseView = [self getBaseView: aBaseViewName];
    // 非主窗口是不能加其它的ViewController的
    if (mShowBaseView == nil) {
        [self createView: aBaseViewName];
        return;
    }
    
    // 这里要对管理的栈进行处理
    // 如果需要动画切换，则增加相应的动画效果
    if (aAnimationDirection != nil) {
        [mCurrBaseView setHidden: NO];
        [mShowBaseView setHidden: NO];
        
        [UIView transitionFromCurrentView: mCurrBaseView
                                              nextView: mShowBaseView
                                    animationDirection: aAnimationDirection
                                                target: self
                                                  time: 0.4f
                                           endfunction: @selector(endShowBaseView)];
    } else {
        [self showBaseView];
    }
    mCurrBaseView = mShowBaseView;
}

// 动画显示结束后要做的事情，需要配合ShowBaseView一起使用
- (void) endShowBaseView {
    [self showBaseView];
}

// 通过ViewName取到BaseView
- (BaseView *) getBaseView: (NSString *) aBaseViewName {
    id vTmpObject = [mViewHashMap objectForKey: [aBaseViewName lowercaseString]];
    if ([vTmpObject isKindOfClass: [BaseView class]]) {
        return (BaseView *) vTmpObject;
    }
    return nil;
}

// 获取当前显示的BaseView名字
- (NSString *) getCurrBaseViewName {
    if (mCurrBaseView != nil) {
        return NSStringFromClass([mCurrBaseView class]);
    }
    return nil;
}

// 释放BaseViewController所有加载的BaseView
- (void) freeAllBaseView {
    // 释放mViewHashMap前，必须把容器中的所有的东西先释放掉
    NSMutableArray *vDeleteValues = [[NSMutableArray alloc] init];
    @try {
        // 得到词典中所有Key值
        NSArray *vAllKeys = [mViewHashMap allKeys];
        // 遍历所有的Value，释放掉非当前的View
        for (NSString *vKey in vAllKeys) {
            NSObject *vObject = [mViewHashMap objectForKey: vKey];
            if ([vObject isKindOfClass: [BaseView class]]) {
                NSString *vTmpObjectName = [NSStringFromClass([vObject class]) lowercaseString];
                // 将类名放入到对应的可变数组中，这里不能直接删除，否则字典会变乱
                [vDeleteValues addObject: vTmpObjectName];
                // 释放内存
                SAFE_ARC_RELEASE(vObject);
                vObject = nil;
            }
        }
        
        int vCount = [vDeleteValues count];
        for (int vIndex = 0; vIndex < vCount; vIndex++) {
            NSString *vTmpStr = (NSString *) [vDeleteValues objectAtIndex: vIndex];
            // 从mViewHashMap中移除掉
            [mViewHashMap removeObjectForKey: vTmpStr];
        }
    } @finally {
        SAFE_ARC_RELEASE(vDeleteValues);
    }
}

// 释放掉BaseView除当前显示的BaseView之外的所有BaseView
- (void) freeBaseView: (NSString *) aBaseViewName {
    // 如果出现内存警告，则把非当前的View释放掉
    NSMutableArray *vDeleteValues = [[NSMutableArray alloc] init];
    @try {
        // 得到词典中所有Key值
        NSArray *vAllKeys = [mViewHashMap  allKeys];
        // 遍历所有的Value，释放掉非当前的View
        for (NSString *vKey in vAllKeys) {
            NSObject *vObject = [mViewHashMap  objectForKey: vKey];
            if ([vObject isKindOfClass: [BaseView class]]) {
                NSString *vTmpObjectName = [NSStringFromClass([vObject class]) lowercaseString];
                if (![vTmpObjectName isEqualToString: [aBaseViewName lowercaseString]]) {
                    // 将类名放入到对应的可变数组中，这里不能直接删除，否则字典会变乱
                    [vDeleteValues addObject: vTmpObjectName];
                    // 释放内存
                    SAFE_ARC_RELEASE(vObject);
                    vObject = nil;
                }
            }
        }
        
        int vCount = [vDeleteValues count];
        for (int vIndex = 0; vIndex < vCount; vIndex++) {
            NSString* vTmpStr = (NSString*) [vDeleteValues objectAtIndex: vIndex];
            // 从mViewHashMap中移除掉
            [mViewHashMap removeObjectForKey: vTmpStr];
        }
    } @finally {
        SAFE_ARC_RELEASE(vDeleteValues);
    }
}

@end
