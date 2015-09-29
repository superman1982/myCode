//
//  QCMRTableViewCell.m
//  兴途邦
//
//  Created by apple on 13-5-22.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import "CleanCarTableViewCell.h"
#import "ConstDef.h"
#import "UIImageView+AFNetworking.h"
#import "ActivityRouteManeger.h"

@implementation CleanCarTableViewCell

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

-(void)setCell:(ShangJiaInfo *)aShangJiaInfo 
{
    
    NSInteger starts = 0;
    NSInteger myDistance = 0;
    NSInteger vRenZhen = 0;
    NSString *vHeadURLStr = @"";
    if ([aShangJiaInfo isKindOfClass:[ShangJiaInfo class]]) {
        starts = aShangJiaInfo.stars;
        myDistance = aShangJiaInfo.distance;
        vRenZhen = aShangJiaInfo.isauthenticate;
        vHeadURLStr = [NSString stringWithFormat:@"%@",aShangJiaInfo.photo ];
    }
    self.starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%d",starts]];
    
    [ActivityRouteManeger addStarsToView:self.starImageView StarNumber:starts];
        
    if (myDistance > 1000) {
        NSString *distanceStr = [NSString stringWithFormat:@"%.2f公里",myDistance/1000.0];
        self.distanceLab.text = distanceStr;
    }else
    {
        NSString *distanceStr = [NSString stringWithFormat:@"%d米",myDistance];
        self.distanceLab.text = distanceStr;
    }
        
    NSString *nameStr =  aShangJiaInfo.name;
    if ([aShangJiaInfo.searchType intValue] == 2) {
        nameStr = [NSString stringWithFormat:@"%@[%@]",aShangJiaInfo.serviceName,aShangJiaInfo.name];
    }
    NSString *phoneStr = aShangJiaInfo.phone;
    NSString *addStr = aShangJiaInfo.address;
        
    self.titleNameLab.text = (nameStr != nil) ? nameStr : @"";
    self.phoneNumLab.text = (phoneStr.length > 6) ? phoneStr : @"";
    self.adressLab.text = (addStr != nil) ? addStr : @"";
        
    if (vRenZhen == 1) {
        self.vipImageView.hidden = NO;
    }else{
        self.vipImageView.hidden = YES;
    }
    
    NSURL *vHeadPicURL = [NSURL URLWithString:vHeadURLStr ];
    [self.webImage setImageWithURL:vHeadPicURL placeholderImage:[UIImage imageNamed: @"lvtubang.png" ]];

//    [self.webImage.layer setCornerRadius:5];
//    [self.webImage.layer setMasksToBounds:YES];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_vipImageView release];
    [super dealloc];
}
#endif
@end
