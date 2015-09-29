//
//  ChosePickerVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChosePickerVCDelegate <NSObject>

@optional
-(NSArray *)pickerDataSource:(id)sender;
-(void)didConfirmPicker:(id)sender;
-(void)didCanclePicker:(id)sender;
@end
@interface ChosePickerVC : BaseViewController

@property (retain, nonatomic) IBOutlet UIView *pickerContentView;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,assign) id <ChosePickerVCDelegate> delegate;
@end
