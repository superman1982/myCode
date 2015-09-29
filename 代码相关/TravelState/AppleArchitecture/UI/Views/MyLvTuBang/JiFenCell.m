//
//  JiFenCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-1.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "JiFenCell.h"

@implementation JiFenCell

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
-(void)setCell:(NSDictionary *)aDic{
    NSString *vScoreID  = [aDic objectForKey:@"scoreId"];
    IFISNIL(vScoreID);
    vScoreID = [NSString stringWithFormat:@"订单编号: %@",vScoreID];
    self.scoreId.text = vScoreID;
    
    NSString *vScreDate = [aDic objectForKey:@"scoreDate"];
    IFISNIL(vScreDate);
    vScreDate = [NSString stringWithFormat:@"订单日期: %@",vScreDate];
    self.scoreDate.text = vScreDate;
    
    NSString *vdescStr = [aDic objectForKey:@"desc"];
    IFISNIL(vdescStr);
    vdescStr = [NSString stringWithFormat:@"订单描述: %@",vdescStr];
    self.desc.text = vdescStr;

    
    NSString *vscoreStr = [aDic objectForKey:@"score"];
    IFISNIL(vscoreStr);
    vscoreStr = [NSString stringWithFormat:@"获得途币: %@",vscoreStr];
    self.score.text = vscoreStr;
}
#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_scoreId release];
    [_scoreDate release];
    [_desc release];
    [_score release];
    [super dealloc];
}
#endif
@end
