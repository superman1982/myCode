//
//  ShoppingCartVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-18.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseCarCell.h"
#import "PurchaseHeaderCell.h"
#import "PurchaseConfirmVC.h"

@interface ShoppingCartVC : BaseViewController<PurchaseCarCellDelegate,PurchaseHeaderCellDelegate,PurchaseConfirmVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *purchaseTableView;
@property (nonatomic,assign)  BOOL  isNeedToResetUI;
-(void)initWebData;
-(BOOL)editButtonTouchDown;
-(void)closeAcountTouchDown;
@end
