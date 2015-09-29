//
//  ClickableScrollView.h
//  iPad
//
//  Jackson.He
//

#import <UIKit/UIKit.h>


@protocol ScrollViewClickDelegate<NSObject>
// 由于UIScrollView自己处理了touchesBegan和touchesEnd这两个消息，同时并没有提供给UIScrollViewDelegate
// 因为需要支持用户点击ScrollView，处理一些事情，所以这里从UIScrollView派生出一个新的类ClickableScrollView
// 重写这两个函数，并建立一个Delegate，实现这2个方法的处理
@optional
-(BOOL)clickShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view;
- (void) clickBegan: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
- (void) clickEnd: (NSSet*) aTouches withEvent: (UIEvent*) aEvent;
@end

@interface ClickableScrollView : UIScrollView {
//    id<ScrollViewClickDelegate> mClickDelegate;
}

@property (nonatomic, assign) id<ScrollViewClickDelegate> clickDelegate;

@end
