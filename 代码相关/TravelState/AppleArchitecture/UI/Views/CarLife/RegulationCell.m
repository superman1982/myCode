//
//  RegulationCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RegulationCell.h"
#import "StringHelper.h"

@implementation RegulationCell

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

-(void)setCell:(id)sender{
    //计算DownMenu偏移违章，并重新计算大小
//    CGSize vXingWeiLableSize = [StringHelper caluateStrLength:self.xingWeiLable.text Front:self.xingWeiLable.font ConstrainedSize:CGSizeMake(self.xingWeiLable.frame.size.width, CGFLOAT_MAX)];
//    CGRect vXingWeiLableFrame = self.xingWeiLable.frame;
//    [self.xingWeiLable setFrame:CGRectMake(vXingWeiLableFrame.origin.x, vXingWeiLableFrame.origin.y,vXingWeiLableSize.width,vXingWeiLableSize.height)];
//    CGRect vDownMenuFrame = self.downMenuView.frame;
//
//    [self.downMenuView setFrame:CGRectMake(vDownMenuFrame.origin.x, vXingWeiLableFrame.origin.y + vXingWeiLableSize.height + 5, vDownMenuFrame.size.width, vDownMenuFrame.size.height)];
//
//    //重新设置Cell大小
//    CGRect vCellFrame = self.frame;
//    [self setFrame:CGRectMake(vCellFrame.origin.x, vCellFrame.origin.y, vCellFrame.size.width, self.downMenuView.frame.origin.y + self.downMenuView.frame.size.height)];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_kouFenLable release];
    [_faKuanLable release];
    [_ifIsDealLable release];
    [_xingWeiLable release];
    [_addressLable release];
    [_timeLable release];
    [_downMenuView release];
    [super dealloc];
}
#endif
@end
