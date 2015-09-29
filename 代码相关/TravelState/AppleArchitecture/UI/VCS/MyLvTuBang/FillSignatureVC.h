//
//  FillSignatureVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol FillSignatureVCDelegate <NSObject>
-(void)didFillSignatureFinished:(id)sender;
@end

@interface FillSignatureVC : BaseViewController<UITextFieldDelegate>
//填写签名textView
@property (retain, nonatomic) IBOutlet UITextView *signatureTextView;
@property (nonatomic,assign) id <FillSignatureVCDelegate> delegate;
@end
