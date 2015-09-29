//
//  AnimationTransition.h
//  iPad
//
//  Jackson.He
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef  enum{
    vaFade = 1,
    vaReveal,
    vaMoveIn,
    vaPush,
    vaCube,
    vaFlip,
    vaRipple,
    vaDefaultAnimation,
    vaNoAnimation,
}ViewAnnatation;

typedef enum {
    vsFromTop = 1,
    vsFromBottom,
    vsFromRight,
    vsFromLeft,
    vsNotMove,
}ViewAnnatationSubtype;


@interface UIView (Animations)
{

}

#pragma mark for UIViewAnimationCurve
+ (void) viewAnimationRemoveFromSuperView: (UIView *)superView
							  fromSubView: (UIView *)subView
						  viewContentMode: (UIViewAnimationTransition)mode;

+ (void) viewAnimationAddSubView: (UIView *)subView
					 fromSuperView: (UIView *)superView
				 viewContentMode: (UIViewAnimationTransition)mode;

+ (void) viewAnimationMyself: (UIView *)view
			 viewContentMode: (UIViewAnimationTransition)mode;

/***********************************************************************
 * 功能描述： UIView的切换动画
 * 输入参数： aType:
 传入vaFade:淡入效果;
 vaReveal:揭开效果;
 vaMoveIn:移入效果
 vaPush :Push效果;
 vaCube:立方体效果;
 vaFlip: 翻转效果；
 vaRipple ：波纹效果
 aSubType:
 传入vsFromTop：FromTop
 传入vsFromBottom:FromBottom
 传入vsFromRight:FromRight
 vsFromLeft:FromLeft
 ***********************************************************************/

+(void)animateChangeView:(UIView *)aView AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType Duration:(float)aDuration CompletionBlock:(void (^)(void))block;
//移动功能
+(void)moveToView:(UIView *)aView DestRect:(CGRect)aDestRect OriginRect:(CGRect)aOrignRect duration:(NSTimeInterval)dt IsRemove:(BOOL)aRemove Completion:(void(^)(BOOL finished))aComplete;
//泡泡动画
- (void)showBubble:(BOOL)show;
@end
