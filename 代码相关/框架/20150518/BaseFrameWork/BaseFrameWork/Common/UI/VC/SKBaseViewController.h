//
//  SKBaseViewController.h
//  Seework
//
//  Created by lin on 15-5-5.
//  Copyright (c) 2015年 seeyon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKBaseViewController : UIViewController

@property (nonatomic,retain) NSString *titleStr;

@property (nonatomic,retain) id       parameter;

@property (nonatomic,assign) UIView  *baseView;

@property (nonatomic,assign) float   width;
@property (nonatomic,assign) float   height;

-(void)initWithNavi;
-(void)showElertView:(NSString *)aMessage;
@end
