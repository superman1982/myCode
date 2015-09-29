//
//  AgentChoseCarCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "AgentChoseCarCell.h"

@implementation AgentChoseCarCell

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

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_carLisenceLable release];
    [_checkButton release];
    [super dealloc];
}
#endif
@end
