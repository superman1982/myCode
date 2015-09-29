//
//  BookHotelHouseCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BookHotelHouseCell.h"

@implementation BookHotelHouseCell

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
/*        [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
 }else{
 mIsAllowAgrement = NO;
 [sender setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];*/
- (IBAction)checkButtonClicked:(UIButton *)sender {
    if (self.isCheck) {
        self.isCheck = NO;
         [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_default"] forState:UIControlStateNormal];
    }else{
        self.isCheck = YES;
        self.lodgingMoney.text = @"0";
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"register_checkbox_btn_select"] forState:UIControlStateNormal];
    }
    if ([_delegate respondsToSelector:@selector(BookHotelHouseCellDidSeleted:)]) {
        [_delegate BookHotelHouseCellDidSeleted:self.isCheck];
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_lodgingMoney release];
    [super dealloc];
}
#endif
@end
