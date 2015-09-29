//
//  NeedCarVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGOViewCommon.h"
#import "ActiveInfo.h"
#import "MakeCarCell.h"

@protocol NeedCarVCDelegate <NSObject>
-(void)didNeedCarFinished:(id)sender;
@end
@interface NeedCarVC : BaseViewController<EGORefreshTableDelegate,MakeCarCellDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
}
//egorefresh
@property (nonatomic, assign) BOOL reloading;
@property (retain, nonatomic) IBOutlet UITableView *needCarTableView;

@property (nonatomic,retain) NSMutableArray *needCarInfo;

@property (nonatomic,retain) ActiveInfo *activeInfo;

@property (retain, nonatomic) IBOutlet UILabel *zanWuCheliangLable;

@property (strong, nonatomic) IBOutlet UIView *agreementFooterView;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;

@property (strong, nonatomic) IBOutlet UIButton *addbutton;
@property (strong, nonatomic) IBOutlet UIButton *desclineButton;

@property (strong, nonatomic) IBOutlet UILabel *seatNumberButton;


@property (nonatomic,assign) id<NeedCarVCDelegate> delegate;

@end
