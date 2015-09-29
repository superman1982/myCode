//
//  ElectronicTitleCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectronicSiteInfo.h"

@protocol ElectronicTitleCellDelegate <NSObject>

-(void)didClickedComeTothePalce:(id)sender;

@end

@interface ElectronicTitleCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *name;

@property (retain, nonatomic) IBOutlet UILabel *gatherTime;
@property (retain, nonatomic) IBOutlet UILabel *stayTime;
//"int:站点标识类型(1、景点；2、就餐；3、购物；4、休息；5、步行；6、驾车)
@property (retain, nonatomic) IBOutlet UIImageView *markType;
//站点序号
@property (retain, nonatomic) IBOutlet UIButton *siteNo;
//白色背景
@property (retain, nonatomic) IBOutlet UIView *whiteContentView;
@property (nonatomic,retain) ElectronicSiteInfo *electroInfo;

-(void)setCell:(ElectronicSiteInfo *)aInfo;

@end
