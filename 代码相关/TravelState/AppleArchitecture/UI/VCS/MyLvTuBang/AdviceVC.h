//
//  AdviceVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-13.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceVC : BaseViewController<UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic,retain)  NSString *placeHolder;
@property (nonatomic,assign) BOOL needToMove;
@end
