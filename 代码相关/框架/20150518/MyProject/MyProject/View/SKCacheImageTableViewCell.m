//
//  SKCacheImageTableViewCell.m
//  MyProject
//
//  Created by lin on 15/5/18.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "SKCacheImageTableViewCell.h"
#import "SKDownLoadImageCacheHelper.h"
#import "MMemberIcon.h"
#import "SKSelfTravelItem.h"

@implementation SKCacheImageTableViewCell

-(void)dealloc{
    [_iconImageView release],_iconImageView = nil;
    [super dealloc];
}

-(void)addControl{
    [super addControl];
    if (_iconImageView == nil) {
        _iconImageView = [[SKImageView alloc] init];
        _iconImageView.frame = CGRectMake(20, 10, 80, 80);
        _iconImageView.backgroundColor = [UIColor orangeColor];
    }
    
    [self.moveContentView addSubview:_iconImageView];
}

-(void)setCell:(MCollaborationListItem *)aItem{
    _iconImageView.image = nil;
    if ([aItem isKindOfClass:[MCollaborationListItem class]]) {
        [[SKDownLoadImageCacheHelper helper] downloadWithUUID:aItem.icon.iconPath createDate:aItem.icon.lastModifyDate lastModifyDate:aItem.icon.lastModifyDate downloadType:aItem.icon.iconType container:_iconImageView serverIdentifier:nil onlyCache:NO];
    }else if ([aItem isKindOfClass:[SKSelfTravelItem class]]){
        SKSelfTravelItem *vItem = (SKSelfTravelItem *)aItem;
        NSString *vID = [NSString stringWithFormat:@"%@",vItem.activityId];
        [[SKDownLoadImageCacheHelper helper] downloadWithUUID:vID container:_iconImageView];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
