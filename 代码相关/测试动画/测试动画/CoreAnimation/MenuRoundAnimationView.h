//
//  MenuRoundAnimationView.h
//  测试动画
//
//  Created by lin on 14-6-4.
//  Copyright (c) 2014年 北京致远. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOMAL_KEY         @"normalImage"
#define SELETED_KEY       @"selectedImage"
#define IMAGE_WIDTH_KEY   @"image_width"

@interface MenuRoundAnimationView : UIView
{
    NSMutableArray *mButtonArrays;
    CGRect          mCenterRect;
    CGPoint         mCenterPoint;
    BOOL            isOpen;
}
-(void)setMenuInfo:(NSArray *)aItemsInfo CenterItem:(NSDictionary *)aDic;

@end
