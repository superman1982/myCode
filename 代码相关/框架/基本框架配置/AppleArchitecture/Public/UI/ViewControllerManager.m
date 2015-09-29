//
//  ViewControllerManager.m
//  AppleArchitecture
//
//  Jackson.He
//

#import "ViewControllerManager.h"
#import "Macros.h"

@interface ViewControllerManager()
{
    // 所有的ViewController的集合相当于Java中的HashMap<String, Object>
    NSMutableDictionary *sViewControllerHashMap;
    // 当前显示的BaseViewController
    BaseViewController *sCurrBaseViewController;
    //加入到堆栈中的所有VC名字
    NSMutableArray *sVCNameArray;
}
// 获取当前的ViewControllerName
- (NSString *) getCurrBaseViewControllerName;
// 获取当前显示的ViewController
- (BaseViewController *) getCurrBaseViewController;
// 增加BaseViewController到字典中
- (void) addBaseViewController: (BaseViewController *) aBaseViewController;

@end

static NSMutableDictionary *viewControllerManegers = nil;

@implementation ViewControllerManager

+(void)createViewControllerManegaerForkeys:(NSArray *)aKeys{
    if (viewControllerManegers == nil) {
        viewControllerManegers = [[NSMutableDictionary alloc] init];
    }
    for (NSString *key in aKeys) {
        if ([viewControllerManegers objectForKey:key] != nil) {
            continue;
        }
        ViewControllerManager *vManeger = [[ViewControllerManager alloc] init];
        [viewControllerManegers setObject:vManeger forKey:key];
        SAFE_ARC_RELEASE(vManeger);
    }
}

+(ViewControllerManager *)getViewControllerManagerWithKey:(NSString *)aKey{
    return [viewControllerManegers objectForKey:aKey];
}

-(id)init{
    self = [super init];
    if (self) {
        if (_navigationController == nil) {
            _navigationController = [[UINavigationController alloc] init];
        }
    }
    return self;
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [sVCNameArray removeAllObjects];
    [sViewControllerHashMap removeAllObjects];
    SAFE_ARC_RELEASE(sVCNameArray);
    SAFE_ARC_RELEASE(sViewControllerHashMap);
    SAFE_ARC_RELEASE(_navigationController);
    [super dealloc];
}
#endif

// 增加BaseViewController到字典中
- (void) addBaseViewController: (BaseViewController *) aBaseViewController {
    // 所有的子ViewController都是加入到主VC中
    if (aBaseViewController == nil) {
        return;
    }
    
    // 有可能存在线程，所以必须使用同步
    @synchronized(sViewControllerHashMap) {
        if (sViewControllerHashMap == nil) {
            sViewControllerHashMap = [[NSMutableDictionary alloc] initWithDictionary: [NSMutableDictionary dictionary]];
        }
        if (sVCNameArray == nil) {
            sVCNameArray = [[NSMutableArray alloc] init];
        }
    }
    
    // NSStringFromClass取某个对象的类名称
    // 以对象的类名称作为Key，以对象作为Value放入到mViewControllerHashMap中
    [sViewControllerHashMap setObject: aBaseViewController forKey: [NSStringFromClass([aBaseViewController class]) lowercaseString]];
    //储存好key值以便以后批量移除
    [sVCNameArray addObject:[NSStringFromClass([aBaseViewController class]) lowercaseString]];
}

// 根据aBaseViewControllerName创建BaseViewController
- (void) createViewController: (NSString *) aBaseViewControllerName {
   
    //先判断是否已存在该VC
    id vBaseViewController = [self getBaseViewController:aBaseViewControllerName];
    if (vBaseViewController == nil) {
        // 根据类名取得类
        Class vVCClass = NSClassFromString(aBaseViewControllerName);
        vBaseViewController = [[vVCClass alloc] init];
        SAFE_ARC_AUTORELEASE(vBaseViewController);
        if (![vBaseViewController isKindOfClass:[BaseViewController class]]) {
            return;
        }
    }
    
    // 将生成的BaseViewCoontroller加入到管理中
    [self addBaseViewController: vBaseViewController];
}

// 获取当前显示的ViewController
- (BaseViewController *) getCurrBaseViewController {
    return sCurrBaseViewController;
}

// 获取当前的ViewControllerName
- (NSString *) getCurrBaseViewControllerName {
    if (sCurrBaseViewController == nil) {
        return @"";
    } else {
        return NSStringFromClass([sCurrBaseViewController class]);
    }
}

// 把名字为aBaseViewControllerName的VC放置到最顶层
- (void) showBaseViewController: (NSString *) aBaseViewControllerName AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType{
    if (_navigationController == nil) {
        return;
    }
    
    if (aBaseViewControllerName == nil || [aBaseViewControllerName length] <= 0) {
        return;
    }
    
    NSString *vCurrBaseViewControllerName = [self getCurrBaseViewControllerName];
    // 如果和当前显示的BaseViewController名字一样，则直接返回
    if ([[aBaseViewControllerName lowercaseString] isEqualToString: [vCurrBaseViewControllerName lowercaseString]]) {
        return;
    }
    
    BaseViewController *vBaseViewController = [self getBaseViewController: aBaseViewControllerName];
    // 如果为空，则先创建
    if (vBaseViewController == nil) {
        // 先创建
        [self  createViewController: aBaseViewControllerName];
        
        // 创建后还为空的话，则要求直接返回
        vBaseViewController = [self getBaseViewController: aBaseViewControllerName];;
        if (vBaseViewController == nil) {
            return;
        }
    }
    
    // 如果当前的BaseViewController不为空，则需要先把当前的BaseViewController移除
    if (sCurrBaseViewController != nil) {
        // 先暂停运行
        [sCurrBaseViewController pauseRun];
    }
	
    // 看横竖屏状态，决定是否需要转屏操作
    // 如果当前ViewController与终端的不一致才要求做转屏操作
    if ([vBaseViewController getIsPortait] != [TerminalData isPortait]) {
        [vBaseViewController setLayout: [TerminalData isPortait]];
    }
    
    [self showAnimationViewController:vBaseViewController AnimationType:aType SubType:aSubType];
    // 启动BaseViewController的startRun事件
    [vBaseViewController startRun];
    sCurrBaseViewController = vBaseViewController;
}
//显示VC时动画设置
-(void)showAnimationViewController:(BaseViewController *) aBaseViewControllerName AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType{
    if (aType != vaDefaultAnimation && aType != vaNoAnimation) {
        //自定义动画
        [_navigationController pushViewController:aBaseViewControllerName animated:NO];
        [UIView animateChangeView:_navigationController.view AnimationType:aType SubType:aSubType Duration:.4 CompletionBlock:^{}];
    }else if(aType == vaDefaultAnimation){
        // 默认动画
        [_navigationController pushViewController: aBaseViewControllerName animated: YES];
    }else if (aType == vaNoAnimation){
        // 没有动画
        [_navigationController pushViewController: aBaseViewControllerName animated: NO];
    }
}

// 通过ViewControllerName取到BaseViewController
- (BaseViewController *) getBaseViewController: (NSString *) aBaseViewControllerName {
    id vTmpObject = [sViewControllerHashMap objectForKey: [aBaseViewControllerName lowercaseString]];
    if ([vTmpObject isKindOfClass: [BaseViewController class]]) {
        return (BaseViewController*) vTmpObject;
    }
    return nil;
}

// 从字典中删除类名为aBaseViewControllerName的BaseViewController，并释放
- (void) removeBaseViewController: (NSString *) aBaseViewControllerName {
    BaseViewController* vTmpVC = [self getBaseViewController: aBaseViewControllerName];
    if (vTmpVC != nil) {
        [sViewControllerHashMap removeObjectForKey: [aBaseViewControllerName lowercaseString]];
        vTmpVC = nil;
    }
}

// 移除所有的BaseViewController
- (void) removeAllBaseViewController {
    //得到词典中所有Value值
    NSEnumerator* vEnumeratorValue = [sViewControllerHashMap objectEnumerator];
    //快速枚举遍历所有Value的值
    for (NSObject* vTmpObject in vEnumeratorValue) {
        if ([vTmpObject isKindOfClass: [BaseViewController class]]) {
            BaseViewController* vTmpVC = (BaseViewController*) vTmpObject;
            if (vTmpVC != nil) {
                SAFE_ARC_RELEASE(vTmpVC);
                vTmpVC = nil;
            }
        }
    }
    [sViewControllerHashMap removeAllObjects];
    sCurrBaseViewController = nil;
}

- (void) freeBaseViewController {
    // 释放mViewControllerHashMap前，必须把容器中的所有的东西先释放掉
    NSMutableArray *vDeleteValues = [[NSMutableArray alloc] init];
    @try {
        // 得到词典中所有Key值
        NSArray *vAllKeys = [sViewControllerHashMap allKeys];
        // 遍历所有的Value，释放掉非当前的View
        for (NSString *vKey in vAllKeys) {
            NSObject *vObject = [sViewControllerHashMap objectForKey: [vKey lowercaseString]];
            if ([vObject isKindOfClass: [BaseViewController class]]) {
                NSString *vObjectName = [NSStringFromClass([vObject class]) lowercaseString];
                // 将类名放入到对应的可变数组中，这里不能直接删除，否则字典会变乱
                [vDeleteValues addObject: vObjectName];
                // 释放内存
                SAFE_ARC_RELEASE(vObject);
                vObject = nil;
            }
        }
        
        int vCount = [vDeleteValues count];
        for (int vIndex = 0; vIndex < vCount; vIndex++) {
            NSString* vTmpStr = (NSString *) [vDeleteValues objectAtIndex: vIndex];
            // 从mViewHashMap中移除掉
            [sViewControllerHashMap removeObjectForKey: vTmpStr];
        }
    } @finally {
        SAFE_ARC_RELEASE(vDeleteValues);
    }
}

// 释放掉除aViewControllerType类型之外的所有BaseViewController
- (void) freeBaseViewController: (NSString *) aBaseViewControllerName {
    // 释放mViewControllerHashMap前，必须把容器中的所有的东西先释放掉
    NSMutableArray *vDeleteValues = [[NSMutableArray alloc] init];
    @try {
        // 得到词典中所有Key值
        NSArray *vAllKeys = [sViewControllerHashMap allKeys];
        // 遍历所有的Value，释放掉非当前的View
        for (NSString *vKey in vAllKeys) {
            NSObject *vObject = [sViewControllerHashMap objectForKey: [vKey lowercaseString]];
            if ([vObject isKindOfClass: [BaseViewController class]]) {
                NSString *vObjectName = [NSStringFromClass([vObject class]) lowercaseString];
                if (![vObjectName isEqualToString: [aBaseViewControllerName lowercaseString]]) {
                    // 将类名放入到对应的可变数组中，这里不能直接删除，否则字典会变乱
                    [vDeleteValues addObject: vObjectName];
                    // 释放内存
                    SAFE_ARC_RELEASE(vObject);
                    vObject = nil;
                }
            }
        }
        
        int vCount = [vDeleteValues count];
        for (int vIndex = 0; vIndex < vCount; vIndex++) {
            NSString *vTmpStr = (NSString*) [vDeleteValues objectAtIndex: vIndex];
            // 从mViewHashMap中移除掉
            [sViewControllerHashMap removeObjectForKey: vTmpStr];
        }
    } @finally {
        SAFE_ARC_RELEASE(vDeleteValues);
    }
}

-(void)showPopAnimation:(ViewAnnatation)aViewType SubType:(ViewAnnatationSubtype)aSubType
{
    //设置返回动画
    if (aViewType != vaDefaultAnimation && aViewType != vaNoAnimation) {
        //自定义动画
        [UIView animateChangeView:_navigationController.view AnimationType:aViewType SubType:aSubType Duration:.3 CompletionBlock:nil];
        [_navigationController popViewControllerAnimated:NO];
    }else if(aViewType == vaDefaultAnimation){
        //默认动画
        [_navigationController popViewControllerAnimated:YES];
    }else if (aViewType == vaNoAnimation){
        //取消动画
        [_navigationController popViewControllerAnimated:NO];
    }

}
- (void)backViewController:(ViewAnnatation)aViewType SubType:(ViewAnnatationSubtype)aSubType
{
    BaseViewController *vTopVC = (BaseViewController *)_navigationController.topViewController;
    //从字典中移除不需要的VC
    [self removeBaseViewController:[NSStringFromClass([vTopVC class]) lowercaseString]];
    [sVCNameArray removeObject:[NSStringFromClass([vTopVC class]) lowercaseString]];
    //设置返回动画
    [self showPopAnimation:aViewType SubType:aSubType];
    //重新改变当前显示的VC
    sCurrBaseViewController = (BaseViewController *)_navigationController.topViewController;
}

-(void)backToViewController:(NSString *)aBaseViewControllerName Animatation:(ViewAnnatation)aViewType SubType:(ViewAnnatationSubtype)aSubType{
    
    BaseViewController *vNeedRemovedVC = [sViewControllerHashMap objectForKey:[aBaseViewControllerName lowercaseString]];
    if (aViewType != vaDefaultAnimation && aViewType != vaNoAnimation) {
        //移除时加载的动画
        [UIView animateChangeView:_navigationController.view AnimationType:aViewType SubType:aSubType Duration:.3 CompletionBlock:nil];
        [_navigationController popToViewController:vNeedRemovedVC animated:NO];
    }else if(aViewType == vaDefaultAnimation){
        [_navigationController  popToViewController:vNeedRemovedVC animated:YES];
    }else if (aViewType == vaNoAnimation){
        [_navigationController  popToViewController:vNeedRemovedVC animated:NO];
    }
    //移除掉字典中的VC
    NSInteger vVCLocation = [sVCNameArray indexOfObject:[aBaseViewControllerName lowercaseString]];
    for (NSInteger vIndex = vVCLocation + 1; vIndex < sVCNameArray.count; vIndex++) {
        NSString *vVCKey = [sVCNameArray objectAtIndex:vIndex];
        [sViewControllerHashMap removeObjectForKey:vVCKey];
    }
    
    [sVCNameArray removeObjectsInRange:NSMakeRange(vVCLocation +1, sVCNameArray.count  - vVCLocation-1)];
    //重新改变当前显示的VC
    sCurrBaseViewController = (BaseViewController *)_navigationController.topViewController;
}

-(NSString *)getCurrentBaseViewController{
    if (sCurrBaseViewController != nil) {
        return NSStringFromClass([sCurrBaseViewController class]);
    }
    return nil;
}

@end
