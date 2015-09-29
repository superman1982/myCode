//
//  WebVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-16.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : BaseViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,retain) NSString *URLStr;
@end
