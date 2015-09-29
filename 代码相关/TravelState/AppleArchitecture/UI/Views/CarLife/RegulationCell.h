//
//  RegulationCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegulationCell : UITableViewCell
//时间
@property (retain, nonatomic) IBOutlet UILabel *timeLable;
//地点
@property (retain, nonatomic) IBOutlet UILabel *addressLable;
//行为
@property (retain, nonatomic) IBOutlet UILabel *xingWeiLable;
//下面的菜单contentView包括：扣分、罚款、是否处理
@property (retain, nonatomic) IBOutlet UIView *downMenuView;
//扣分
@property (retain, nonatomic) IBOutlet UILabel *kouFenLable;
//罚款
@property (retain, nonatomic) IBOutlet UILabel *faKuanLable;
//是否处理
@property (retain, nonatomic) IBOutlet UILabel *ifIsDealLable;

-(void)setCell:(id)sender;
@end
