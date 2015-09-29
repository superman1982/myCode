//
//  SKCacheImageTableViewCell.h
//  MyProject
//
//  Created by lin on 15/5/18.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKImageView.h"
#import "MCollaborationListItem.h"
#import "SKSlideTableViewCell.h"

@interface SKCacheImageTableViewCell : SKSlideTableViewCell

@property (nonatomic,retain) SKImageView *iconImageView;

-(void)setCell:(MCollaborationListItem *)aItem;
@end
