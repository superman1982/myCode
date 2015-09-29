//
//  SliderViewController.h
//  SliderPageControlDemo
//
//  Created by klbest1 on 14-1-26.
//
//

#import <UIKit/UIKit.h>
#import "SliderPageControl.h"
#import "ClickableScrollView.h"
#import "AnimationTransition.h"

@protocol  SliderViewControllerDelegate <NSObject>
@optional
-(void)didScrollToPage:(NSInteger)aPage DiRection:(ViewAnnatationSubtype)aDirec;
@end

@interface SliderViewController : UIViewController<UIScrollViewDelegate,SliderPageControlDelegate>

@property (nonatomic,retain) ClickableScrollView *scrolloContentView;
@property (nonatomic,assign) BOOL isAutoScroll;
@property (nonatomic,assign) id<SliderViewControllerDelegate> delegate;
//添加ViewController界面
-(void)setViewControllers:(NSArray *)aViewControlers ViewRect:(CGRect)aRect PagePointImage:(NSString *)aImageStr;
//添加View界面
-(void)setViewViews:(NSArray *)aViews ViewRect:(CGRect)aRect PagePointImage:(NSString *)aImageStr;
//重新加载SlidePageControll到自定义View上
-(void)addSlidePageControllToView:(UIView *)aView Frame:(CGRect)aFrame PagePointImage:(NSString *)aImageStr;
//移动到某页
-(void)sliderToPage:(NSInteger)aPage;
@end
