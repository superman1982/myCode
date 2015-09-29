//
//  CustomMenuView.m
//  测试可移动菜单项
//
//  Created by lin on 14-6-6.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import "SyLCustomMenuView.h"
#import "SyMenuScrollView.h"

#define MENU_ITEM_WIDTH 100
#define MENU_ITEM_HIGHT 100
#define MENU_ITEM_SPACE 6
#define DELETE_MAX_LEGTH -30

@interface SyLCustomMenuView()
{
    SyMenuScrollView *mScrollContentView;
    //行
    NSInteger        mRow;
    //列
    NSInteger        mCloum;
}
@end
@implementation SyLCustomMenuView

- (id)initWithFrame:(CGRect)frame withCloum:(NSInteger)aCloumn Row:(NSInteger)aRow
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mRow = aRow;
        mCloum = aCloumn;
        [self commInit];
        [self setupViews];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)dealloc{
    [_menuItemFrames removeAllObjects];
    [_menuItemFrames release],_menuItemFrames = nil;
    [_menuItemInfoArray removeAllObjects];
    [_menuItemInfoArray release],_menuItemInfoArray = nil;
    [super dealloc];
}

-(void)commInit{
    if (_menuItemFrames == nil) {
        _menuItemFrames = [[NSMutableArray alloc] init];
    }
}

-(void)setupViews{
    if (mScrollContentView == nil) {
        mScrollContentView = [[SyMenuScrollView alloc] init];
    }
    [self addSubview:mScrollContentView];
    [self initFrames];
    [self initMenuItem];
    [self layoutSubviews];
}

-(void)layoutSubviews{
    mScrollContentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    mScrollContentView.contentSize = CGSizeMake(mCloum * (MENU_ITEM_SPACE + MENU_ITEM_WIDTH), mRow *(MENU_ITEM_HIGHT + MENU_ITEM_SPACE) );
}

-(void)initFrames{
    for (int i=0; i < mRow; i++) {
        for (int j = 0; j < mCloum; j++) {
            CGRect vRect = CGRectMake((MENU_ITEM_SPACE + MENU_ITEM_WIDTH)*j+5, (MENU_ITEM_HIGHT + MENU_ITEM_SPACE) * i, MENU_ITEM_WIDTH, MENU_ITEM_HIGHT);
            [_menuItemFrames addObject:NSStringFromCGRect(vRect)];
        }
    }
}

-(void)initMenuItem{
    if (_menuItemInfoArray == nil) {
        _menuItemInfoArray = [[NSMutableArray alloc] init];
    }
    int i = 0;
    for (NSString *vFrameStr in _menuItemFrames) {
        CGRect vItemRect = CGRectFromString(vFrameStr);
        SyLMenuItem *vMenuItem = [[SyLMenuItem alloc] initWithFrame:vItemRect];
        UILabel *vTestLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 20, 21)];
        vTestLable.text = [NSString stringWithFormat:@"%d",i];
        [vMenuItem addSubview:vTestLable];
        [vMenuItem setItemIndex:i];
        [mScrollContentView addSubview:vMenuItem];
        [_menuItemInfoArray addObject:vMenuItem];
        NSLog(@"all index:%@",vTestLable.text);

        i++;
        [vMenuItem addTarget:self action:@selector(itemTouchDown:) forControlEvents:UIControlEventTouchDown];
        [vMenuItem addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [vMenuItem addTarget:self action:@selector(backToNormal:) forControlEvents:UIControlEventTouchDragOutside];
        [vMenuItem addTarget:self action:@selector(backToNormal:) forControlEvents:UIControlEventTouchDownRepeat];
        [vMenuItem addTarget:self action:@selector(backToNormal:) forControlEvents:UIControlEventTouchCancel];
        [vMenuItem release];
        [vTestLable release];
    }
}

#pragma mark 其他辅助功能
-(NSInteger)indexOfLocation:(CGPoint)aPoint{
    NSLog(@"touchPoint:%f,%f",aPoint.x,aPoint.y);
    NSInteger vRow = aPoint.y/(MENU_ITEM_HIGHT + MENU_ITEM_SPACE);
    NSInteger vCloumn = aPoint.x/(MENU_ITEM_SPACE + MENU_ITEM_WIDTH);
    NSLog(@"点击了第%d行,第%d列",vRow,vCloumn);
    NSInteger vIndex = vRow *3 + vCloumn;
    if (aPoint.y < DELETE_MAX_LEGTH) {
        return _menuItemInfoArray.count -1;
    }
    return vIndex;
}

-(void)backToNormal:(SyLMenuItem *)sender{
    sender.isDraged = NO;
    isHold = NO;
    [_holdTimer invalidate];
    _holdTimer = nil;
}

#define mark 点击事件
-(void)itemTouchDown:(SyLMenuItem *)sender{
    [_holdTimer invalidate];
    _holdTimer = nil;
    self.holdTimer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didTimerHold:) userInfo:sender repeats:NO];
}

-(void)itemTouchUpInside:(SyLMenuItem *)sender{

    NSString *vRectStr = [_menuItemFrames objectAtIndex:sender.itemIndex];
    sender.frame = CGRectFromString(vRectStr);

    [self backToNormal:sender];
    //删除移动到边界处的菜单项
    if (currentTouchPoint.y <= DELETE_MAX_LEGTH) {
        [sender removeFromSuperview];
        [_menuItemInfoArray removeLastObject];
    }
    
    //重新布局
//    for (int i = 0; i < _menuItemFrames.count; i++) {
//        if (_menuItemInfoArray.count <= i) {
//            return;
//        }
//        TestMenuItem *vItem = [_menuItemInfoArray objectAtIndex:i];
//        vItem.itemIndex = i;
//        NSString *vRectStr = [_menuItemFrames objectAtIndex:i];
//        CGRect vRect = CGRectFromString(vRectStr);
//        vItem.frame = vRect;
//    }
    if ([_delegate respondsToSelector:@selector(didClickedMenuItem:)]) {
        [_delegate didClickedMenuItem:sender];
    }
    NSLog(@"点击 item了");
}

-(void)itemDragOutSide:(SyLMenuItem *)sender{
    [self backToNormal:sender];
}

-(void)itemDragInside:(SyLMenuItem *)sender{
}

-(void)didTimerHold:(NSTimer *)aTimer{
    ((SyLMenuItem *)aTimer.userInfo).isDraged = YES;
    isHold = YES;
    mCurrentMenuItem = (SyLMenuItem *)aTimer.userInfo;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *vTouch = [touches anyObject];
    CGPoint vTouchPoint = [vTouch locationInView:mScrollContentView];
    if ([vTouch view] != mCurrentMenuItem) {
        return;
    }
    currentTouchPoint = vTouchPoint;
    if(isHold&& mCurrentMenuItem.isDraged){
        mCurrentMenuItem.center = vTouchPoint;

        NSInteger vIndex = [self indexOfLocation:vTouchPoint];
        NSLog(@"moving Index:%d",vIndex);
        NSLog(@"current index:%d",mCurrentMenuItem.itemIndex);
         //当前移动的Index位置大于当前holding的item的Index时，也就是向下移动
        if (vIndex > mCurrentMenuItem.itemIndex && vIndex > 0) {
            [UIView animateWithDuration:.3 animations:^{
                for (NSInteger i =  mCurrentMenuItem.itemIndex + 1; i <= vIndex; i++) {
                    if (_menuItemInfoArray.count <= i) {
                        return ;
                    }
                    //从当前holding的item 的（index+1） 到 手指移动位置的index
                    //整体向下移动一个位置
                    NSString *vItemRectStr = [_menuItemFrames objectAtIndex:i-1];
                    CGRect vItemNewFrame = CGRectFromString(vItemRectStr);
                    SyLMenuItem *vMenuItem = [_menuItemInfoArray objectAtIndex:i];
                    vMenuItem.itemIndex = i -1;
                    vMenuItem.frame = vItemNewFrame;
                }
            } completion:^(BOOL finished) {
                
            }];
            
        }else if (vIndex < mCurrentMenuItem.itemIndex && vIndex >=0){
            //当前移动的Index位置小于当前holding的item的Index时，也就是向上移动
            if (_menuItemFrames.count > vIndex) {
                [UIView animateWithDuration:.3 animations:^{
                    for (NSInteger i = vIndex; i < mCurrentMenuItem.itemIndex; i++) {
                        //从手指移动位置的（index+1） 到 当前holding的item 的（index）
                        //整体向上移动一个位置
                        if (_menuItemInfoArray.count <= i) {
                            return ;
                        }
                        NSString *vItemRectStr = [_menuItemFrames objectAtIndex:i + 1];
                        CGRect vItemFrame = CGRectFromString(vItemRectStr);
                        SyLMenuItem *vMenutItem = [_menuItemInfoArray objectAtIndex:i];
                        vMenutItem.frame = vItemFrame;
                        vMenutItem.itemIndex = i+1;
                    }
                } completion:^(BOOL finished) {
                }];
            }
        }
        //将当前holding 的item，插入到手指当前移动到的index位置
        if (vIndex >= 0 && vIndex < _menuItemInfoArray.count) {
            [_menuItemInfoArray removeObject:mCurrentMenuItem];
            [_menuItemInfoArray insertObject:mCurrentMenuItem atIndex:vIndex];
            mCurrentMenuItem.itemIndex = vIndex;
        }
    }
    
}

@end
