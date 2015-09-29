//
//  MakeCarCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-20.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "MakeCarCell.h"

@implementation MakeCarCell

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

-(void)setCell:(NSDictionary *)aDic chosedIndex:(NSNumber *)aIndex{
    
    if (![aDic isKindOfClass:[NSDictionary class]]) {
        LOGERROR(@"setCell");
        return;
    }
    id vDriverStr = [aDic objectForKey:@"driver"];
    IFISNIL(vDriverStr);
    IFISSTR(vDriverStr);
    self.driver.text = vDriverStr;
    
    id vPhoneStr = [aDic objectForKey:@"phone"];
    IFISNIL(vPhoneStr);
    IFISSTR(vDriverStr);
    self.phone.text = vPhoneStr;
    
    id vCarBrandStr = [aDic objectForKey:@"carBrand"];
    IFISNIL(vCarBrandStr);
    self.carBrand.text = vCarBrandStr;
    
    id vCarModeStr = [aDic objectForKey:@"carModel"];
    IFISNIL(vCarModeStr);
    self.carModel.text = vCarModeStr;
    
    id vSeatStr = [aDic objectForKey:@"seatQuantity"];
    IFISNIL(vSeatStr);
    IFISSTR(vSeatStr);
    self.seatQuantity.text = vSeatStr;
    [self setCheckState:aIndex];
}

-(void)setCheckState:(NSNumber *)aIndex{
    if (aIndex == Nil) {
        return;
    }
    if (self.index == [aIndex intValue]) {
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_select"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkButtonClicked:(UIButton *)sender {
    if (![_isChecked intValue]) {
        _isChecked = [NSNumber numberWithInt:1];
        [_delegate clearOtherCheckButton];
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_select"] forState:UIControlStateNormal];
        if ([_delegate respondsToSelector:@selector(didMakeCarCellChecked:)]) {
            [_delegate didMakeCarCellChecked:[NSNumber numberWithInt:self.index]];
        }
    }else{
        _isChecked = [NSNumber numberWithInt:0];
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_default.png"] forState:UIControlStateNormal];
    }
}

-(void)clearCheck{
    _isChecked = NO;
    [self.checkButton  setBackgroundImage:[UIImage imageNamed:@"needShare_check_btn_default.png"] forState:UIControlStateNormal]; 
}
#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [super dealloc];
}
#endif
@end
