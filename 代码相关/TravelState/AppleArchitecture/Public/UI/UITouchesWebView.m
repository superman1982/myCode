//
//  UITouchesWebView.m
//  iPad
//
//  Jackson.He
//

#import "UITouchesWebView.h"
#import <objc/runtime.h>

const char *mUIWebDocumentView= "UIWebDocumentView";

@interface UIView (UIViewTappingDelegate)
- (void) touchesBegan: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) touchesMoved: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) touchesEnded: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) touchesCancelled: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
@end

@interface NSObject (UIWebViewTappingDelegate)
- (void) touchesBegan: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*) aEvent;
- (void) touchesMoved: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*) aEvent;
- (void) touchesEnded: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*) aEvent;
- (void) touchesCancelled: (NSSet*) aTouches inWebView: (UIWebView*) sender withEvent: (UIEvent*) aEvent;
@end

@interface UITouchesWebView (private)
- (void) hookedTouchesBegan: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) hookedTouchesMoved: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) hookedTouchesEnded: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) hookedTouchesCancelled: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
@end

@implementation UIView (__TapHook)

- (void) __replacedTouchesBegan: (NSSet*) aTouches withEvent: (UIEvent*) aEvent {
	if([self.superview.superview isMemberOfClass: [UITouchesWebView class]] ) {
		[(UITouchesWebView*) self.superview.superview hookedTouchesBegan: aTouches withEvent: aEvent];
	} else {
		[self.superview touchesBegan: aTouches withEvent: aEvent];
	}
}
 
- (void) __replacedTouchesMoved: (NSSet*) aTouches withEvent:(UIEvent*) aEvent{
    if([self.superview.superview isMemberOfClass: [UITouchesWebView class]]) {
		[(UITouchesWebView*) self.superview.superview hookedTouchesMoved: aTouches withEvent: aEvent];
	} else {
		[self.superview touchesMoved: aTouches withEvent: aEvent];
	}
}

- (void) __replacedTouchesEnded: (NSSet*) aTouches withEvent:(UIEvent*) aEvent {
    if([self.superview.superview isMemberOfClass: [UITouchesWebView class]]) {
		[(UITouchesWebView*) self.superview.superview hookedTouchesEnded: aTouches withEvent: aEvent];
	} else {
		[self.superview touchesEnded: aTouches withEvent: aEvent];
	}
}

- (void) __replacedTouchesCancelled: (NSSet*) aTouches withEvent:(UIEvent*) aEvent {
	if([self.superview.superview isMemberOfClass: [UITouchesWebView class]]) {
		[(UITouchesWebView*) self.superview.superview hookedTouchesCancelled: aTouches withEvent: aEvent];
	} else {
		[self.superview touchesCancelled: aTouches withEvent: aEvent];
	}
}

@end
static BOOL mHookIsInstalled = NO;
@implementation UITouchesWebView

#pragma mark Class method setup hookmethod for UIWebDocumentView

+ (void) unInstallHook {
	if (mHookIsInstalled)	{
		mHookIsInstalled = NO;
		[UITouchesWebView installHook];
	}
}

+ (void) installHook {
	if(mHookIsInstalled) {
		return;
    }
    
	mHookIsInstalled = YES;
	Class vTmpClass = objc_getClass(mUIWebDocumentView);
	if (vTmpClass == nil) {
		return;         // if there is no UIWebDocumentView in the future.
    }
	
	// 交换2个操作的实际实作
	// replace touch began event
	method_exchangeImplementations(
								   class_getInstanceMethod(vTmpClass, @selector(touchesBegan: withEvent:)), 
								   class_getInstanceMethod(vTmpClass, @selector(__replacedTouchesBegan:withEvent:)) );
	
	// replace touch moved event
	method_exchangeImplementations(
								   class_getInstanceMethod(vTmpClass, @selector(touchesMoved: withEvent:)), 
								   class_getInstanceMethod(vTmpClass, @selector(__replacedTouchesMoved:withEvent:))
								   );
	
	// replace touch ended event
	method_exchangeImplementations(
								   class_getInstanceMethod(vTmpClass, @selector(touchesEnded: withEvent:)), 
								   class_getInstanceMethod(vTmpClass, @selector(__replacedTouchesEnded:withEvent:))
								   );
	
	// replace touch cancelled event
	method_exchangeImplementations(
								   class_getInstanceMethod(vTmpClass, @selector(touchesCancelled:withEvent:)), 
								   class_getInstanceMethod(vTmpClass, @selector(__replacedTouchesCancelled: withEvent:))
								   );
}

#pragma mark Original method for call delegate method
- (void) hookedTouchesBegan: (NSSet *) aTouches withEvent: (UIEvent *) aEvent {
	if([self.delegate respondsToSelector: @selector(touchesBegan: inWebView: withEvent:)]) {
		[(NSObject*)self.delegate touchesBegan: aTouches inWebView: self withEvent: aEvent];
    }
}

- (void) hookedTouchesMoved:(NSSet *) aTouches withEvent: (UIEvent *) aEvent {
	if([self.delegate respondsToSelector: @selector(touchesMoved: inWebView: withEvent:)]) {
        [(NSObject*)self.delegate touchesMoved: aTouches inWebView: self withEvent: aEvent];
    }		
}

- (void) hookedTouchesEnded:(NSSet *) aTouches withEvent: (UIEvent *) aEvent {
	if([self.delegate respondsToSelector: @selector(touchesEnded: inWebView: withEvent:)]) {
		[(NSObject*)self.delegate touchesEnded: aTouches inWebView: self withEvent: aEvent];
    }
}

- (void) hookedTouchesCancelled: (NSSet *) aTouches withEvent: (UIEvent *) aEvent {
	if([self.delegate respondsToSelector: @selector(touchesCancelled: inWebView: withEvent:)]) {
		[(NSObject*)self.delegate touchesCancelled: aTouches inWebView: self withEvent: aEvent];
    }
}

- (id) initWithFrame: (CGRect) aFrame {
    self = [super initWithFrame: aFrame];
    if (self != nil) {
		[UITouchesWebView installHook];
    }
    return self;
}

- (id) initWithCoder: (NSCoder*) aCoder {
    self = [super initWithCoder: aCoder];
    if (self != nil) {
		[UITouchesWebView installHook];
    }
    return self;
}

@end
