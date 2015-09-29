//
//  BunessDetailStorePhotoVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DianPuTuPianCell.h"
#import "ShangJiaInfo.h"

@interface BunessDetailStorePhotoVC : BaseViewController<DianPuTuPianCellDelegate>
{

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) ShangJiaInfo * shangJiaInfo;
@end
