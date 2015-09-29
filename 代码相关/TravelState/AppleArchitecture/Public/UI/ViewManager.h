//
//  ViewManager.h
//  AppleArchitecture
//
//  Jackson.He
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "Macros.h"
#import "AnimationTransition.h"

@interface ViewManager : NSObject {
    BaseViewController *mBaseViewController;
    // 所有的View的集合相当于Java中的HashMap<String, Object>
    NSMutableDictionary *mViewHashMap;
    
	// 当前显示的BaseView
	BaseView *mCurrBaseView;
    // 显示转换时，正需要显示的BaseView
    BaseView *mShowBaseView;
}

@property(nonatomic, SAFE_ARC_PROP_RETAIN) IBOutlet BaseViewController *baseViewController;

// 根据aBaseViewName创建BaseView
- (void) createView: (NSString *) aBaseViewName;
// 把名字为aBaseViewName的View放置到最顶层，aType主要动画类型，aSubType动画方向。
- (void) showBaseView: (NSString *) aBaseViewName  AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType;

// 把名字为aBaseViewName的View放置到最顶层，isBack是否是返回，animationType动画类型
- (void) showBaseView: (NSString *) aBaseViewName isBack: (BOOL) aIsBack animationDirection: (NSString *) aAnimationDirection;
// 通过ViewName取到BaseView
- (BaseView *) getBaseView: (NSString *) aBaseViewName;
// 获取当前显示的BaseView名字
- (NSString *) getCurrBaseViewName;

// 释放BaseViewController所有加载的BaseView
- (void) freeAllBaseView;
// 释放掉BaseViewController除当前显示的BaseView之外的所有BaseView
- (void) freeBaseView: (NSString *) aBaseViewName;

@end
