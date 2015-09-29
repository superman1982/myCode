//
//  ChoseDateVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-14.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseDateVCDelegate <NSObject>
-(void)didConfirmDate:(id)sender;
-(void)didCancleDate:(id)sender;
-(void)valueDidChange:(id)sender;

@end
@interface ChoseDateVC : BaseViewController
{
    NSDateFormatter *mDateformate;
}
//datePicker背景VIEW
@property (retain, nonatomic) IBOutlet UIView *datePickerContentView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (nonatomic,assign) id delegate;

@end
