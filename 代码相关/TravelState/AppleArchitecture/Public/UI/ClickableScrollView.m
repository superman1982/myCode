//
//  ClickableScrollView.m
//  iPad
//
//  Jackson.He
//

#import "ClickableScrollView.h"
#import "ARCMacros.h"

@implementation ClickableScrollView

@synthesize clickDelegate = mClickDelegate;
#pragma mark -
#pragma mark 系统方法
- (id) initWithFrame: (CGRect) aFrame {
    self = [super initWithFrame: aFrame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (BOOL) touchesShouldCancelInContentView: (UIView*) aView {
//	return NO;
//}
//
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([mClickDelegate respondsToSelector:@selector(clickShouldBegin:withEvent:inContentView:)]) {
        [mClickDelegate clickShouldBegin:touches withEvent:event inContentView:view];
    }
    return YES;
}

// dealloc函数 
- (void) dealloc {
    mClickDelegate = nil;
    
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -
#pragma mark 重写touchesBegan，touchesEnded方法
- (void) touchesBegan:(NSSet*) aTouches withEvent: (UIEvent*) aEvent {
    if (mClickDelegate != nil && [mClickDelegate respondsToSelector: @selector(clickBegan: withEvent:)]) {
        [mClickDelegate clickBegan: aTouches withEvent: aEvent];
    }
    
    [super touchesBegan: aTouches withEvent: aEvent];
    if (!self.dragging) {
        [[self nextResponder] touchesBegan: aTouches withEvent: aEvent];
    }
}

- (void) touchesEnded: (NSSet*) aTouches withEvent: (UIEvent*) aEvent {
    if (mClickDelegate != nil && [mClickDelegate respondsToSelector: @selector(clickEnd: withEvent:)]) {
        [mClickDelegate clickEnd: aTouches withEvent: aEvent];
    }
    
    [super touchesEnded: aTouches withEvent: aEvent];
    if (!self.dragging) {
        [[self nextResponder] touchesEnded: aTouches withEvent: aEvent];
    }
}

@end
