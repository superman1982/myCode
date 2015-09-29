//
//  WaitingView.h
//  iPad
//
//  Jackson.He
//

#import <UIKit/UIKit.h>
#import "ARCMacros.h"
#import "TerminalData.h"

@interface WaitingView : UIView {
	int mWaitingCount;
    TerminalData* mTerminalData;
}
@property (nonatomic, assign) int WaitingCount;
// 开始动画
- (void) startAnimating;
// 结束动画
- (void) stopAnimating;
// 设置提示信息
- (void) setHintStr: (NSString*) aHintStr;
// 设置Frame的大小
- (void) setFrame: (CGRect) aFrame;
@end
