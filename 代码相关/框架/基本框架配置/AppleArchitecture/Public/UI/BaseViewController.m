//
//  BaseViewController.m
//  iPad
//
//  Jackson.He

#import "BaseViewController.h"
#import "AnimationTransition.h"
#import "ViewControllerManager.h"
#import "MainConfig.h"

@interface BaseViewController ()
// 顶部状态栏返回事件
- (void) returnBtnTouchDown: (id) sender;
@end;

@implementation BaseViewController
@synthesize popoverDelegate = mPopoverDelegate;

#pragma mark -
#pragma mark 系统方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     if (IS_IOS7)
        self.edgesForExtendedLayout = UIRectEdgeNone ;

		mTerminalData = [TerminalData instanceTerminalData];
		mWidth = [TerminalData deviceWidth];
		mHeight = [TerminalData deviceHeight];
		mIsPortait = [TerminalData isPortait];
        [self initTopNavBar];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (self.showWelCome) {
        BOOL vIsEverLanched = [[NSUserDefaults standardUserDefaults] boolForKey:@"isEverLanched"];
        if (!vIsEverLanched) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isEverLanched"];
            WelcomeVC *vWelcomeVC = [[WelcomeVC alloc] init];
            vWelcomeVC.delegate = self;
            [self presentModalViewController:vWelcomeVC animated:YES];
            SAFE_ARC_AUTORELEASE(vWelcomeVC);
        }else{
            [self runThings];
        }
    }
    //初始化基类View,设置好宽度和高度，以及自动初始化
    NSString *vBaseViewClassName = NSStringFromClass([self class]);
    vBaseViewClassName = [vBaseViewClassName stringByReplacingOccurrencesOfString:@"ViewController" withString:@"View"];
    UIView *vContentView = [[NSClassFromString(vBaseViewClassName) alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
    if (vContentView == nil) {
        vContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
    }
    vContentView.backgroundColor = [UIColor whiteColor];
    self.view = vContentView;
    SAFE_ARC_RELEASE(vContentView);
}

//注册键盘通知
-(void)viewWillAppear:(BOOL)animated{
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)runThings{
}

#pragma mark -
#pragma mark 开始等待状态
- (void) startWaitingAnimation: (NSString*) aHintStr {
	// mNavigationBar的Frame
	CGRect vFrame = CGRectMake(0, -44, mWidth, mHeight);
	if (mWaitingView == nil) {
		mWaitingView = [[WaitingView alloc] initWithFrame: vFrame];
		[self.view addSubview: mWaitingView];
        mWaitingView.backgroundColor = [UIColor blackColor];
        [mWaitingView setAlpha: 0.6];
	}
	[self.view bringSubviewToFront: mWaitingView];
	[mWaitingView setHidden: NO];
	[mWaitingView startAnimating];	
	[mWaitingView setHintStr: aHintStr]; 
	[mWaitingView setFrame: vFrame];
}

#pragma mark -
#pragma mark 结束等待状态
- (void) stopWaitingAnimation {
	if (mWaitingView != nil) {
		[mWaitingView setHintStr: nil];
		[mWaitingView stopAnimating];
		[self.view sendSubviewToBack: mWaitingView];
		[mWaitingView setHidden:YES];
	}
}

#pragma mark -
#pragma mark 初始化Navbar
- (void) initTopNavBar {
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];
    self.title = @"默认标题";
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"top_bg.png"];
//    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:0.5]];
    if (IS_IOS7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:65.0/255.0 blue:230/255.0 alpha:0.6]];
    }
    UIButton *vBackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [vBackButton setBackgroundImage:[UIImage imageNamed:self.backButtonNormalImageStr] forState:UIControlStateNormal];
    [vBackButton setBackgroundImage:[UIImage imageNamed:self.backButtonHelightImageStr] forState:UIControlStateHighlighted];
    [vBackButton setFrame:CGRectMake(0, 0, 32, 32)];
    [vBackButton addTarget:self action:@selector(returnBtnTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *vBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:vBackButton];
    self.navigationItem.leftBarButtonItem = vBarButtonItem;
    
    SAFE_ARC_RELEASE(vBarButtonItem);
}

-(NSString *)backButtonNormalImageStr{
    return @"back_btn_default";
}

-(NSString *)backButtonHelightImageStr{
    return @"back_btn_select";
}

-(void)setShowBackButton:(BOOL)aShow{
    [mTopBackButton setHidden:aShow];
}
// 顶部状态栏返回事件
- (void) returnBtnTouchDown: (id) sender {
    [self back];
}

- (void) dealloc {
    SAFE_ARC_SUPER_DEALLOC();
}

// 旋转屏幕时做的事情
- (void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration: (NSTimeInterval) duration {
    // 这里的时候需要设置一下当前的终端的横竖屏状态
    if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) ||
        (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        [mTerminalData setIsPortait: YES];
		[self setLayout: YES];
    } else {
        [mTerminalData setIsPortait: NO];
		[self setLayout: NO];      
    }	
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation {
    // iPhone客户端不能够横竖屏切换
    return [TerminalData isPad];
}

#pragma mark -
#pragma mark 自定义类方法
// 获取当前是否是竖屏
- (BOOL) getIsPortait {
    return mIsPortait;
}

// 设置当前的布局状态
- (void) setLayout: (BOOL) aPortait {
    mIsPortait = aPortait;
	// mWaitingView的Frame
	CGRect vFrame = CGRectMake(0, 0, mWidth, mHeight);
	if (mWaitingView != nil) {
        mWaitingView.frame = vFrame;
    }
}

// 返回事件处理,默认直接把当前的ViewController移除
- (void) back {
    [[ViewControllerManager getViewControllerManagerWithKey:NOMAL_MANEGER] backViewController:vaDefaultAnimation SubType:vsFromLeft];
}

// 开始运行时的处理
- (void) startRun {
}

// 暂停操作时的处理
- (void) pauseRun {
}

// 将弹出窗体显示在对应的UIView中间
- (void) showPopoverController: (UIPopoverController*) aPopoverController onView: (UIView*) aUIView {
    if (aPopoverController == nil || aUIView == nil) {
        return;
    }
    // popoverRect的中心点是用来画箭头的，如果中心点如果出了屏幕，系统会优化到窗口边缘
    [aPopoverController presentPopoverFromRect: [aUIView bounds]
                                        inView: aUIView		    // 上面的矩形坐标是以这个view为参考的
                      permittedArrowDirections: UIPopoverArrowDirectionUp	// 箭头方向
                                    animated: YES];
}

#pragma mark -
#pragma mark 内存警告处理
// 子类中去实现,释放一些需要释放的东西
- (void)viewShouldUnLoad {
    if (mTopNavigationBar != nil) {
        SAFE_ARC_RELEASE(mTopNavigationBar);
		mTopNavigationBar = nil;
    }
    
    if (mTopNaBarImageView != nil) {
        SAFE_ARC_RELEASE(mTopNaBarImageView);
		mTopNaBarImageView = nil;
    }
    
    if (mTopBackButton != nil) {
        SAFE_ARC_RELEASE(mTopBackButton);
		mTopBackButton = nil;
    }
    
    if (mTopLogo != nil) {
        SAFE_ARC_RELEASE(mTopLogo);
		mTopLogo = nil;
    }
    
    if (mViewManager != nil) {
        SAFE_ARC_RELEASE(mViewManager);
		mViewManager = nil;
    }
    mPopoverDelegate = nil;
}

// IOS6.x 不再会调到此方法
- (void)viewDidUnload {
    [super viewDidUnload];
    //统一调viewShouldUnLoad
    [self viewShouldUnLoad];
}

//收到内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //如果view还没生成，不用做任何事
    if (![self isViewLoaded]) {
        return;
    }
    //6.0以上，判断如果不是当前使用的controller，就把view释放（这个判断函数大家可以自己写）
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        if (self.view.window == nil)// 是否是正在使用的视图
        {
            [self viewShouldUnLoad];
            self.view = nil;// 目的是再次进入时能够重新加载loadview
        }
    }
}

#pragma mark - 其他辅助功能
//当前激活控件，弹出键盘
- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#define CARENGINFILDHIGHT 70
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //转换View位置坐标，因为IOS7取消View自动伸缩时，View位置坐标与IOS5不相同
    CGRect frame = [textField convertRect:textField.frame toView:self.view.window];
    //计算TextField多出键盘的高度，以中文键盘为标准
    int offset = frame.origin.y + 32 - (mHeight + 20 - 216.0-36);//键盘高度216
    NSLog(@"Height:%d",mHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    isNeedToMoveFrame = NO;
    if(offset > 0){
        //移动后的View位置
        CGRect vViewFrame = self.view.frame;
        CGRect rect = CGRectMake(0.0f,vViewFrame.origin.y -offset ,vViewFrame.size.width,vViewFrame.size.height);
        if (!isShowChanese){
            //不是中文键盘时，向下多移动36个像素，
            rect.origin.y = rect.origin.y + 36;
            //设置isNeedToMoveFrame = YES，英文变中文键盘时移动;
            isNeedToMoveFrame = YES;
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

//结束输入
- (void)textFieldDidEndEditing:(UITextField *)textField{
}

#pragma mark ClickeableTableView 屏幕点击事件
//点击非输入框时，关闭取消键盘
-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    UIView *vTouchControl = [self findFirstResponderBeneathView:self.view];
    if (!CGRectContainsPoint(vTouchControl.frame,vTouchPoint)) {
        [vTouchControl resignFirstResponder];
    }
}

#pragma mark 点击屏幕 缩回键盘
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    NSInteger vTouchCount = vTouch.tapCount;
    CGPoint vTouchPoint = [vTouch locationInView:self.view];
    if (vTouchCount == 1) {
        UIView *vTouchControl = [self findFirstResponderBeneathView:self.view];
        if (!CGRectContainsPoint(vTouchControl.frame,vTouchPoint)) {
            [vTouchControl resignFirstResponder];
        }
    }
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置_talkBarView的frame跟随键盘的frame , 对中文键盘处理
    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    //如果显示了中文，则变为英文输入时，重新移动
    if (isShowChanese) {
        isShowChanese = NO;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 36, self.view.frame.size.width, self.view.frame.size.height);
        }];
        return;
    }
    //英文键盘变中文键盘时，View向上移动
    if (isNeedToMoveFrame && distanceToMove > 0 ) {
        isShowChanese = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - distanceToMove, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

//隐藏键盘时，将View恢复为原样式
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    if (IS_IOS7) {
        rect = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

@end
