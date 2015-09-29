//
//  ProvideCar.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableTableView.h"
#import "AllMyCarVC.h"

@protocol ProvideCarDelegate <NSObject>

-(void)didProvideCarFinished:(id)sender;
@end
@interface ProvideCar : BaseViewController<UITextFieldDelegate,AllMyCarVCDelegate>

@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet ClickableTableView *carInfoTableView;

@property (nonatomic,assign) id<ProvideCarDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;
@end
