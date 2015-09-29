//
//  PurchaseConfirmVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-4.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseHeaderCell.h"

@protocol PurchaseConfirmVCDelegate <NSObject>

-(void)didPurchaseConfirmVCSubmitSucces:(id)sender;

@end
@interface PurchaseConfirmVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray *confirmInfoArray;

@property (strong, nonatomic) IBOutlet UITableView *purchaseConfirmTableView;

@property (nonatomic,retain) NSMutableArray *headInfoArray;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *finalAcountMoneyLable;
@property (nonatomic,retain) id<PurchaseConfirmVCDelegate> delegate;

@end
