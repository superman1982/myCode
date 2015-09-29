//
//  ButtonHelper.m
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-13.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import "ButtonHelper.h"
#import "SVProgressHUD.h"
#import "NetManager.h"

@implementation UIButton(Helper)
////创建横排菜单
//+(UIScrollView *)createUpMenu:(NSArray *)aProjectsArray ButtonData:(struct ButtonData)aButtonData{
//    
//    CGSize vViewSize = aButtonData.btShowViewFrameSize;
//    if (aProjectsArray.count == 0 || vViewSize.width < 10 || vViewSize.height < 10 ) {
//        return nil;
//    }
//    
//    UIScrollView *vButtonConetScrollView = [[UIScrollView alloc] init] ;
//    SAFE_ARC_AUTORELEASE(vButtonConetScrollView);
//    
//    //button高度、宽度、间隔大小
//    float vButtonHight = vViewSize.height;
//    float vButtonWidth = aButtonData.btButtonWidth;
//    float vSpaceWidth = aButtonData.btButtonSpaceWidth;
//    //设置ScrollViewContentSize、Frame
//    float vMaxContentWidth = (vButtonWidth + vSpaceWidth) *aProjectsArray.count;
//    [vButtonConetScrollView setContentSize:CGSizeMake(vMaxContentWidth, vButtonHight)];
//    [vButtonConetScrollView setFrame:CGRectMake(0, 0, vViewSize.width, vViewSize.height)];
//    [vButtonConetScrollView setShowsHorizontalScrollIndicator:NO];
//    [vButtonConetScrollView setShowsVerticalScrollIndicator:NO];
//    [vButtonConetScrollView setBackgroundColor:[UIColor clearColor]];
//    
//    //如果contentSize的宽小于Frame的宽，那么禁止移动
//    if (vMaxContentWidth <= vViewSize.width) {
//        [vButtonConetScrollView setScrollEnabled:NO];
//    }
//    
//    for (NSInteger i = 0; i< aProjectsArray.count; i++) {
//        NSDictionary *vProjectItemDic = [aProjectsArray objectAtIndex:i];
//        NSString *vProjectDefaultImageStr = [vProjectItemDic objectForKey:DEFAULTBUTTONIMAGE];
//        NSString *vProjectHilightImageStr = [vProjectItemDic objectForKey:HILIGHTBUTTONIAMGE];
//        NSString *vProjectStr = [vProjectItemDic objectForKey:SHOWTEXT];
//        NSInteger vButtonTag = [[vProjectItemDic objectForKey:BUTTONTAG] integerValue];
//        
//        UIButton *vProjectsButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//        //设置button位置,有间隔则加上间隔
//    
//        [vProjectsButton setFrame:CGRectMake( (vButtonWidth + vSpaceWidth)*i, 0, vButtonWidth, vButtonHight)];
//        [vProjectsButton setBackgroundImage:[UIImage imageNamed:vProjectDefaultImageStr] forState:UIControlStateNormal];
//        [vProjectsButton setBackgroundImage:[UIImage imageNamed:vProjectHilightImageStr] forState:UIControlStateHighlighted];
//        [vProjectsButton setTitle:vProjectStr forState:UIControlStateNormal];
//        vProjectsButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [vProjectsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [vProjectsButton setTag:vButtonTag];
//        //如果有实现selector才添加点击事件
//        if ([aButtonData.delegate respondsToSelector:aButtonData.selector]) {
//            [vProjectsButton addTarget:aButtonData.delegate action:aButtonData.selector forControlEvents:UIControlEventTouchUpInside];
//        }else{
//            LOG(@"%@Button没有实现点击方法！",vProjectStr);
//        }
//        
//        
//        [vButtonConetScrollView addSubview:vProjectsButton];
//    }
//    
//    return vButtonConetScrollView;
//}

-(void)createButtonWithFrame:(CGRect)aFrame
                       Title:(NSString *)aTitle
                 NormalImage:(UIImage *)aNImage
                HelightImage:(UIImage *)aHImage
                      Target:(id)delegate
                      SELTOR:(SEL)aSel{
    [self setFrame:aFrame];
    [self setTitle:aTitle forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setBackgroundImage:aNImage forState:UIControlStateNormal];
    [self setBackgroundImage:aHImage forState:UIControlStateHighlighted];
    [self addTarget:delegate action:aSel forControlEvents:UIControlEventTouchUpInside];
}


@end
