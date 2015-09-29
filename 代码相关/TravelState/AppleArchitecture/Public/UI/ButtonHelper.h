//
//  ButtonHelper.h
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-13.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULTBUTTONIMAGE @"defaultImage"
#define HILIGHTBUTTONIAMGE @"hightImage"
#define SHOWTEXT           @"showText"
#define BUTTONTAG          @"buttonTag"

//struct ButtonData{
//    CGSize  btShowViewFrameSize;
//    float   btButtonWidth;
//    float   btButtonSpaceWidth;
//    id      delegate;
//    SEL     selector;
//};


@interface  UIButton(Helper)
//创建横排菜单
//+(UIScrollView *)createUpMenu:(NSArray *)aProjectsArray ButtonData:(struct ButtonData)aButtonData;

-(void)createButtonWithFrame:(CGRect)aFrame
                       Title:(NSString *)aTitle
                 NormalImage:(UIImage *)aNImage
                HelightImage:(UIImage *)aHImage
                      Target:(id)delegate
                      SELTOR:(SEL)aSel;
@end
