//
//  QCMRTableViewCell.h
//  兴途邦
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangJiaInfo.h"

@interface CleanCarTableViewCell : UITableViewCell

//商家名
@property (strong, nonatomic) IBOutlet UILabel *titleNameLab;
//商家门头照
@property (strong, nonatomic) IBOutlet UIImageView *webImage;
//电话号码
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLab;
//商家地址
@property (strong, nonatomic) IBOutlet UILabel *adressLab;
//距离
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;
//星级
@property (strong, nonatomic) IBOutlet UIImageView *starImageView;
//认证商家
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;

-(void)setCell:(ShangJiaInfo *)aShangJiaInfo ;

@end
