//
//  ChosePickerVC.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ChosePickerVC.h"

@interface ChosePickerVC ()
{
    //PickerContentView要移动的位置
    CGRect mDestRect;
    //PickerView要显示的数据
    NSMutableArray *mPickerSourceArray;
    NSInteger mSelectedRow;
}
@end

@implementation ChosePickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ChosePickerVC" bundle:nibBundleOrNil];
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ChosePickerVC_2x" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mDestRect = self.pickerContentView.frame;
    mDestRect = CGRectMake(0, mDestRect.origin.y - 64, 320, mDestRect.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateChangeView:self.view AnimationType:vaFade SubType:0 Duration:.2 CompletionBlock:Nil];
    
    //移动DatePickerContenView
    CGRect vOriginRect =CGRectMake(0, mHeight, 320, mHeight);
    [UIView moveToView:self.pickerContentView DestRect:mDestRect OriginRect:vOriginRect duration:.3 IsRemove:NO Completion:Nil];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [mPickerSourceArray removeAllObjects],[mPickerSourceArray release];
    [_pickerContentView release];
    [_pickerView release];
    [super dealloc];
}
#endif

- (void)viewDidUnload {
    [self setPickerContentView:nil];
    [self setPickerView:nil];
    [super viewDidUnload];
}

#pragma mark UIPIckerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //首次使用获取Picker数据
    if (mPickerSourceArray == Nil) {
        mPickerSourceArray = [[NSMutableArray alloc] init];
        if ([_delegate respondsToSelector:@selector(pickerDataSource:)]) {
            NSArray *vPickerSource = [_delegate pickerDataSource:Nil];
            if (vPickerSource.count > 0) {
                [mPickerSourceArray addObjectsFromArray:vPickerSource];
            }
        }
        
    }

    return mPickerSourceArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [mPickerSourceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    mSelectedRow = row;
}


-(void)pickerContentViewMoveOut{
    [UIView animateChangeView:self.view AnimationType:vaFade SubType:0 Duration:.2 CompletionBlock:Nil];
    //移动DatePickerContenView
    CGRect vOriginRect =CGRectMake(0, mHeight, 320, mHeight);
    [UIView moveToView:self.pickerContentView DestRect:vOriginRect OriginRect:mDestRect duration:.2 IsRemove:NO Completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 其他业务点击事件
- (IBAction)confirmClicked:(id)sender {
    [self pickerContentViewMoveOut];
    if ([_delegate respondsToSelector:@selector(didConfirmPicker:)]) {
        id data = [mPickerSourceArray objectAtIndex:mSelectedRow];
        [_delegate didConfirmPicker:data];
    }
}

- (IBAction)cancleClicked:(id)sender {
    [self pickerContentViewMoveOut];
    if ([_delegate respondsToSelector:@selector(didCanclePicker:)]) {
        [_delegate didCanclePicker:Nil];
    }
}
@end
