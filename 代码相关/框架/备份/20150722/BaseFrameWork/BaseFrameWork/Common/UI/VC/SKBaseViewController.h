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

-(void)initWithNavi;
-(void)showElertView:(NSString *)aMessage;
@end
