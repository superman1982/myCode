//
//  UpGrandVipCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-3-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "UpGrandVipCell.h"

@implementation UpGrandVipCell

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
    
    self.cardMame.text = [aDic objectForKey:@"cardMame"];
    IFISNIL(self.cardMame.text);
    
    NSString *vMoney = [aDic objectForKey:@"cardMoney"];
    IFISNIL(vMoney);
    self.cardMoney.text = [NSString stringWithFormat:@"%@/年",vMoney];
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_cardMame release];
    [_cardMoney release];
    [_cardBackImageView release];
    [super dealloc];
}
#endif
@end
