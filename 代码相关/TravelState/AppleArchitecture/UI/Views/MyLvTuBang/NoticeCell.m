//
//  NoticeCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

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

- (IBAction)handleImedialyButtonClicked:(id)sender {
    [ViewControllerManager createViewController:@"ChoseAgentCar"];
    [ViewControllerManager showBaseViewController:@"ChoseAgentCar" AnimationType:vaDefaultAnimation SubType:0];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_noticeDescriptionLable release];
    [_timeLable release];
    [_handleImedialyButton release];
    [super dealloc];
}
#endif
@end
