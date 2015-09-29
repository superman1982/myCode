//
//  ChoseCityAeraVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseDistrictVCDelegate <NSObject>
-(void)didFinishChosedPlace:(id)sender;
@end
@interface ChoseDistrictVC : BaseViewController
//保存选择的省信息
@property (nonatomic,retain) NSDictionary *provinceDic;
//保存选择的城市信息
@property (nonatomic,retain) NSDictionary *cityDic;
//保存区域信息
@property (nonatomic,retain) NSMutableArray *placeArray;
//地区列表
@property (retain, nonatomic) IBOutlet UITableView *placeTableView;

@property (nonatomic,assign) id delegate;
//选择省市区的入口，以便返回到该页面
@property (nonatomic,retain) NSString *fromVCName;
@end
