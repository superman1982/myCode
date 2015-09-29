//
//  WaitingView.m
//  iPad
//
//  Jackson.He
//

#import "WaitingView.h"

#define TagUIActivityIndicatorView   100
#define TagUILabel					 101
#define UIActivityIndicatorSize		 37
#define LineNumber					 5

@implementation WaitingView
@synthesize WaitingCount = mWaitingCount;

#pragma mark -
#pragma mark 系统方法
- (id) initWithFrame: (CGRect) aFrame {
    self = [super initWithFrame: aFrame];
    if (self != nil)	{
        // 初始化背景色
		self.backgroundColor = [UIColor whiteColor];
        // 初始化透明度
		self.alpha = 0.65;
		
		// 旋转进度轮
		UIActivityIndicatorView *vIndicator = [[UIActivityIndicatorView alloc]init];
        // 设置进度轮的指示器外观样式
        // UIActivityIndicatorViewStyleWhite用于深色背景
        // UIActivityIndicatorViewStyleGray只适用于白色背景       
		vIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		vIndicator.hidesWhenStopped = YES;
        // 设置进度轮的Frame
		vIndicator.frame = CGRectMake((aFrame.size.width - UIActivityIndicatorSize) / 2, 
                                      (aFrame.size.height - UIActivityIndicatorSize) / 2, 
                                      UIActivityIndicatorSize, 
                                      UIActivityIndicatorSize);
        // 设置进度轮的Tag值
		vIndicator.tag = TagUIActivityIndicatorView;
        // 设置进度轮的中心点
		vIndicator.center = self.center;
        // 加入进度轮到界面
		[self addSubview: vIndicator];
		SAFE_ARC_RELEASE(vIndicator);
		
		//下方的文字提示
		UILabel	*vLabel = [[UILabel alloc] init];
		vLabel.backgroundColor = [UIColor clearColor];
		vLabel.textColor = [UIColor whiteColor];
        // 对齐方式
		vLabel.textAlignment = UITextAlignmentCenter;	
        // 根据Pad or Phone设置字体大小
        if ([TerminalData isPad]) {
            vLabel.font = [UIFont systemFontOfSize:24.0f];
        } else {
            vLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        // 设置Label的位置
		vLabel.frame= CGRectMake(0, vIndicator.frame.origin.y + UIActivityIndicatorSize, 
								 self.frame.size.width, 21.0 * LineNumber);
		vLabel.numberOfLines = LineNumber;
		vLabel.tag = TagUILabel;
		[self addSubview: vLabel];
		SAFE_ARC_RELEASE(vLabel);
    }
    return self;
}

- (void) dealloc {
	mWaitingCount = 0;
    SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark -
#pragma mark 自定义类方法
// 设置整个等待view的Frame
- (void) setFrame:(CGRect) aFrame {
	[super setFrame: aFrame];
    // 设置旋转进度轮的位置
	UIView *vIndicatorview = [self viewWithTag: TagUIActivityIndicatorView];
	if (vIndicatorview != nil) {
		vIndicatorview.center = self.center;
	}
    
	// 设置Label的位置
	UIView *vLabel = [self viewWithTag: TagUILabel];
    if ((vLabel != nil) && (vIndicatorview != nil)) {        
        vLabel.frame = CGRectMake(0, vIndicatorview.frame.origin.y + UIActivityIndicatorSize, 
                                  self.frame.size.width, 21.0 * LineNumber);
	}
}

// 开始动画
- (void) startAnimating {	
	if(mWaitingCount <= 0) {
		[(UIActivityIndicatorView*)[self viewWithTag:TagUIActivityIndicatorView] performSelector:@selector(startAnimating)];
	}
	[self setHidden: NO];
	mWaitingCount++;
}

// 结束动画
- (void) stopAnimating {
	mWaitingCount--;
	if(mWaitingCount <= 0) {
		[(UIActivityIndicatorView*)[self viewWithTag:TagUIActivityIndicatorView] performSelector:@selector(stopAnimating)];
	}
}

// 设置提示字符串
- (void) setHintStr:(NSString*) aHintStr {
	[(UILabel*)[self viewWithTag: TagUILabel] setText: aHintStr];
}
@end
