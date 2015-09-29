//
//  ChosePlaceVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-27.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseProvinceVCDelegate <NSObject>
-(void)didChoseProvinceFinished:(id)sender;
@end

@interface ChoseProvinceVC : BaseViewController
//保存省信息
@property (nonatomic,retain) NSMutableArray *placeArray;
//地区列表
@property (retain, nonatomic) IBOutlet UITableView *placeTableView;
//是否需求选择区
@property (nonatomic,assign) BOOL isNeedChosedDistrict;
//选择省市区的入口，以便返回到该页面
@property (nonatomic,retain) NSString *fromVCName;

@property (nonatomic,assign) id delegate;
@end
