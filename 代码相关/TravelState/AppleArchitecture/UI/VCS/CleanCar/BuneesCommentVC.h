//
//  BuneesCommentVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangJiaInfo.h"

@interface BuneesCommentVC : BaseViewController

@property (nonatomic,retain) ShangJiaInfo *shangJiaInfo;
//全部的title
@property (retain, nonatomic) IBOutlet UILabel *allTitleLable;
//全部的数量
@property (retain, nonatomic) IBOutlet UILabel *allNumerLable;
//好评的title
@property (retain, nonatomic) IBOutlet UILabel *bestLable;
//好评的数量
@property (retain, nonatomic) IBOutlet UILabel *bestTitleLable;
//中评的title
@property (retain, nonatomic) IBOutlet UILabel *middleTitleLable;
//中评的数量
@property (retain, nonatomic) IBOutlet UILabel *middleLable;
//差评的title
@property (retain, nonatomic) IBOutlet UILabel *badTitleLable;
//差评的数量
@property (retain, nonatomic) IBOutlet UILabel *badLable;

@property (retain, nonatomic) IBOutlet UITableView *commtentTableView;
//所有评论的button
@property (retain, nonatomic) IBOutlet UIButton *allButton;
//好评button
@property (retain, nonatomic) IBOutlet UIButton *bestButton;
//中评button
@property (retain, nonatomic) IBOutlet UIButton *middleButton;
//差评button
@property (retain, nonatomic) IBOutlet UIButton *badButton;


@end
