//
//  ActiveBookVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookTableFirstRowVC.h"
#import "ProvideCar.h"
#import "ActiveInfo.h"
#import "NeedCarVC.h"
#import "BookHotelHouseCell.h"
#import "BookInsuranceCell.h"

@protocol ActiveBookVCDelegate <NSObject>

-(void)didActiveBookVCSucess:(id)sender;
@end
@interface ActiveBookVC : BaseViewController<BookTableFirstRowVCDelegate,ProvideCarDelegate,NeedCarVCDelegate,BookHotelHouseCellDelegate,BookInsuranceCellDelegate,UIAlertViewDelegate>
//FooterView
@property (retain, nonatomic) IBOutlet UIView *footerViewForBookTable;
@property (retain, nonatomic) IBOutlet UIView *headerViewFormakeHotel;
@property (retain, nonatomic) IBOutlet UITableView *activeBookTableView;
@property (nonatomic,assign)   id<ActiveBookVCDelegate> delegate;
//活动信息
@property (nonatomic,retain) ActiveInfo *activinfo;

@property (nonatomic,assign) NSInteger signupType;
//支付密码
@end
