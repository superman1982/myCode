//
//  AnimationTransition.m
//  iPad
//
//  Jackson.He
//

#import "AnimationTransition.h"
#import "TerminalData.h"
#import "AppDelegate.h"

#define DeviceHight [UIScreen mainScreen].bounds.size.height

static CGFloat kTransitionDuration = 0.45f;

@implementation  UIView (Animations)

#pragma mark -
#pragma mark UIViewAnimationTransition
+ (void) viewAnimationRemoveFromSuperView: (UIView *)superView
							  fromSubView: (UIView *)subView
						  viewContentMode: (UIViewAnimationTransition)mode {
	if (superView == nil || subView == nil) {
        return;
    }
	[UIView beginAnimations: @"View Flip" context: nil];
	[UIView setAnimationDuration: 0.71];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	////////////////////////////////////////////////////////////////////////////////
	[UIView setAnimationTransition: mode forView: superView.superview cache: YES];
	[subView removeFromSuperview];
	////////////////////////////////////////////////////////////////////////////////
	
	[UIView commitAnimations];
}
+ (void) viewAnimationAddSubView: (UIView *)subView
				   fromSuperView: (UIView *)superView
				 viewContentMode: (UIViewAnimationTransition)mode {
    if (superView == nil || subView == nil) {
        return;
    }
	[UIView beginAnimations:@"View Flip" context: nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	////////////////////////////////////////////////////////////////////////////////
	[UIView setAnimationTransition: mode forView: superView.superview cache: YES];
	[superView addSubview: subView];
	////////////////////////////////////////////////////////////////////////////////
	
	[UIView commitAnimations];
}
+ (void) viewAnimationMyself: (UIView *) view
			 viewContentMode: (UIViewAnimationTransition) mode {
	if (view == nil) {
            return;
    }
	[UIView beginAnimations: @"View Flip" context: nil];
	// 设置动画持续时间
	[UIView setAnimationDuration: 0.9];

	// UIViewAnimationCurve
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	// UIViewAnimationTransition
	[UIView setAnimationTransition: mode forView: view cache: YES];
	
	[UIView commitAnimations];
	
}

#pragma mark show bubble animation
- (void)bounce4AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
	[UIView commitAnimations];
}


- (void)bounce3AnimationStopped{
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce4AnimationStopped)];
	self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce3AnimationStopped)];
	self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/6];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)showBubble:(BOOL)show {
    if (show) {
        
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.hidden = NO;
        [UIView commitAnimations];
        
    }
    else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/3];
        self.hidden = YES;
        [UIView commitAnimations];
    }
}


+(void)animateChangeView:(UIView *)aView AnimationType:(ViewAnnatation )aType SubType:(ViewAnnatationSubtype)aSubType Duration:(float)aDuration CompletionBlock:(void (^)(void))block
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = aDuration;
//    animation.timingFunction = UIViewAnimationCurveLinear;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [CATransaction setCompletionBlock:^{
        if (block) {
            block();
        }
    }];
    switch (aType) {
        case vaFade:
            animation.type = kCATransitionFade;
            break;
        case vaReveal:
            animation.type = kCATransitionReveal; //揭开效果
            break;
        case vaMoveIn:
            animation.type = kCATransitionMoveIn; //覆盖效果
            break;
        case vaPush:
            animation.type = kCATransitionPush;
            break;
        case vaCube:
            animation.type = @"cube"; //立方体
            break;
        case vaFlip:
            animation.type = @"oglFlip"; //翻转效果
            break;
        case vaRipple:
            animation.type = @"rippleEffect"; //波纹效果
            break;
        default:
            animation.type = kCATransitionPush;
            break;
    }
    
    switch (aSubType) {
        case vsFromTop:
            animation.subtype = kCATransitionFromTop;
            break;
        case vsFromBottom:
            animation.subtype = kCATransitionFromBottom;
            break;
        case vsFromRight:
            animation.subtype = kCATransitionFromRight;
            break;
        case vsFromLeft:
            animation.subtype = kCATransitionFromLeft;;
            break;
        default:
            animation.subtype = kCATransitionFromLeft;;
            break;
    }
    
    [aView.layer addAnimation:animation forKey:@"animation"];
}


+(void)moveToView:(UIView *)aView DestRect:(CGRect)aDestRect OriginRect:(CGRect)aOrignRect duration:(NSTimeInterval)dt IsRemove:(BOOL)aRemove Completion:(void(^)(BOOL finished))aComplete
{
    [aView setFrame:aOrignRect];
    [UIView animateWithDuration:dt
                     animations:^{
                         [aView setFrame:aDestRect];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (aRemove) {
                                 [aView removeFromSuperview];
                             }
                         }
                         if(aComplete){
                             aComplete(finished);
                         }
                     }];
    
}
@end
