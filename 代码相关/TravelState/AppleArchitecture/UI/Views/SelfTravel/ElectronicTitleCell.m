//
//  ElectronicTitleCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-22.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ElectronicTitleCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UserManager.h"
#import "ActivityRouteManeger.h"

@implementation ElectronicTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell:(ElectronicSiteInfo *)aInfo{
        self.electroInfo = aInfo;
    
    self.name.text = aInfo.name;
    if (aInfo.routesType == atActiveRoutes) {
    self.gatherTime.text = [NSString stringWithFormat:@"集合时间:%@",aInfo.gatherTime ];
        self.stayTime.text = [NSString stringWithFormat:@"停留%@小时",aInfo.stayTime];
    }else if(aInfo.routesType == atRecomendRoutes){
        self.gatherTime.text = @"";
        self.stayTime.text = [NSString stringWithFormat:@"建议停留%@小时",aInfo.stayTime];
        //向上移动8个像素，因为没有集合时间
        CGRect vGatherTimeFrame = self.gatherTime.frame;
        self.stayTime.frame = CGRectMake(vGatherTimeFrame.origin.x, vGatherTimeFrame.origin.y + 5, vGatherTimeFrame.size.width, vGatherTimeFrame.size.height);
    }
    //站点序号
    NSString *vSiteNumber = [NSString stringWithFormat:@"%@",aInfo.siteNo];
    [self.siteNo setTitle:vSiteNumber forState:UIControlStateNormal];
    
    //站点左边图片介绍类型
    NSString *vMarkTypeImageStr = Nil;
    NSInteger vMarkType = [aInfo.markType intValue];
    /*(1、景点；2、就餐；3、购物；4、休息；5、步行；6、驾车)",*/
    switch (vMarkType) {
        case 1:
            vMarkTypeImageStr = @"roadBook_view_bkg";
            break;
        case 2:
            vMarkTypeImageStr = @"roadBook_food_bkg";
            break;
        case 3:
            vMarkTypeImageStr = @"roadBook_shop_bkg";
            break;
        case 4:
            vMarkTypeImageStr = @"roadBook_sleep_bkg";
            break;
        case 5:
            vMarkTypeImageStr = @"roadBook_walk_bkg";
            break;
        case 6:
            vMarkTypeImageStr = @"roadBook_drive_bkg";
            break;
        default:
            break;
    }
    [self.markType setImage:[UIImage imageNamed:vMarkTypeImageStr]];
    self.whiteContentView.layer.cornerRadius = 10;
    self.whiteContentView.layer.masksToBounds = YES;
}
- (IBAction)totherButtonClicked:(id)sender {
    CLLocationCoordinate2D vDestinaCoord = CLLocationCoordinate2DMake([self.electroInfo.latitude doubleValue], [self.electroInfo.longitude doubleValue]);
    CLLocationCoordinate2D vUserCoord = [UserManager instanceUserManager].userCoord;
    [ActivityRouteManeger gotoBaiMapApp:vUserCoord EndLocation:vDestinaCoord];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_electroInfo release];
    [_name release];
    [_gatherTime release];
    [_stayTime release];
    [_markType release];
    [_whiteContentView release];
    [super dealloc];
}
#endif
@end
