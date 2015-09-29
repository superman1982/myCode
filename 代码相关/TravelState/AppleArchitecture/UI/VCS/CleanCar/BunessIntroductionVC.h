//
//  BunessIntroductionVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BunessIntroductionVC : BaseViewController
@property (retain, nonatomic) IBOutlet UIWebView *introductionWebView;
@property (nonatomic,retain) NSString *introductionURLStr;
@end
