//
//  ViewControllerManager.h
//  AppleArchitecture
//
//  Jackson.He
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "AnimationTransition.h"
#import <UIKit/UIKit.h>

@interface ViewControllerManager : NSObject
@property (nonatomic,retain)   UINavigationController *navigationController;

//创建ViewController管理
+(void)createViewControllerManegaerForkeys:(NSArray *)aKeys;
//获取ViewController管理
+(ViewControllerManager *)getViewControllerManagerWithKey:(NSString *)aKey;

// 根据aBaseViewControllerName创建BaseViewController
- (void) createViewController: (NSString *) aBaseViewControllerName;
// 把名字为aBaseViewControllerName的VC放置到最顶层
- (void) showBaseViewController: (NSString *) aBaseViewControllerName AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType;

// 通过ViewControllerName取到BaseViewController
- (BaseViewController *) getBaseViewController: (NSString *) aBaseViewControllerName;
// 从字典中删除类名为aBaseViewControllerName的BaseViewController
- (void) removeBaseViewController: (NSString *) aBaseViewControllerName;
// 移除所有的BaseViewController
- (void) removeAllBaseViewController;

//获取当前显示的vc
-(NSString *)getCurrentBaseViewController;
// 释放AppDelegate所有加载的BaseViewController
- (void) freeBaseViewController;
// 释放掉除aBaseViewControllerName名字之外的所有BaseViewController
- (void) freeBaseViewController: (NSString *) aBaseViewControllerName;
//pop当前VC
- (void)backViewController:(ViewAnnatation)aViewType SubType:(ViewAnnatationSubtype)aSubType;
//POP到某一个VC
-(void)backToViewController:(NSString *)aBaseViewControllerName Animatation:(ViewAnnatation)aViewType SubType:(ViewAnnatationSubtype)aSubType;
@end
