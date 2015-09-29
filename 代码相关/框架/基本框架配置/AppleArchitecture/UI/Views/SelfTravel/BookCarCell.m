//
//  BookCarCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BookCarCell.h"

@implementation BookCarCell

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
    [_carBrandLable release];
    [_carLisenceLable release];
    [_peopleNumberLable release];
    [_produceCarOrNeedCarLable release];
    [super dealloc];
}
#endif
@end
