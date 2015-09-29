//
//  ElectronicBunessDetailCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BunessDetailProductInfo.h"

@protocol ElectronicBunessDetailCellDelegate <NSObject>

-(void)didElectronicBunessDetailCellOrderAmountChanged:(BunessDetailProductInfo *)aInfo;
@end

@interface ElectronicBunessDetailCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *servicePhoto;

@property (retain, nonatomic) IBOutlet UILabel *serviceName;

@property (retain, nonatomic) IBOutlet UILabel *vipPrice;

@property (retain, nonatomic) IBOutlet UILabel *price;

@property (retain, nonatomic) IBOutlet UILabel *returnMoney;

@property (retain, nonatomic) IBOutlet UILabel *serviceDesc;

@property (retain, nonatomic) IBOutlet UILabel *beginDateTimeendDateTime;

@property (retain, nonatomic) IBOutlet UILabel *amoutsLable;
//订购数量ContentView
@property (strong, nonatomic) IBOutlet UIView *acountContentCiew;
//加载订购数量和时间的contentView
@property (strong, nonatomic) IBOutlet UIView *downContentView;
//加入购物车Button
@property (strong, nonatomic) IBOutlet UIButton *addToPurchaseCarButton;

@property (nonatomic,assign) NSInteger oderAmount;

@property (nonatomic,assign) id<ElectronicBunessDetailCellDelegate> delegate;

@property (nonatomic,retain) BunessDetailProductInfo *bunessProductInfo;

-(void)setCell:(BunessDetailProductInfo *)aInfo;
//重设Cell高度
-(float )setHeigtOfCell:(BunessDetailProductInfo *)aInfo;
@end
