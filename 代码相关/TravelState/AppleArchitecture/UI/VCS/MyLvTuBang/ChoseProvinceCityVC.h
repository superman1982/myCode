//
//  ChoseCityVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseProvinceCityVCDelegate <NSObject>
-(void)didChoseProvinceCityVCFinished:(id)sender;
@end

@interface ChoseProvinceCityVC : BaseViewController
//保存选择的省信息
@property (nonatomic,retain) NSDictionary *provinceDic;
//储存地区信息
@property (nonatomic,retain) NSMutableArray *placeArray;
//地区列表
@property (retain, nonatomic) IBOutlet UITableView *placeTableView;
//是否需要选择区
@property (nonatomic,assign) BOOL isNeedChosedDistrict;
//选择省市区的入口，以便返回到该页面
@property (nonatomic,assign) id delegate;
//选择省市区的入口，以便返回到该页面
@property (nonatomic,retain) NSString *fromVCName;

-(void)goToChosePlaceVC:(NSDictionary *)aData;

@end
