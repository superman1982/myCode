//
//  BookHotelCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BookHotelCell.h"

@implementation BookHotelCell

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
    self.isSingleRoom = [[aDic objectForKey:@"peopleNumber"] boolValue];
    self.houseNumber = [[aDic objectForKey:@"houseNumber"] intValue];
    self.housePrice = [[aDic objectForKey:@"housePrice" ] intValue];
    
    if (self.isSingleRoom) {
        self.peopleNumberLable.text = @"单人间";
    }else{
        self.peopleNumberLable.text = @"双人间";
    }
    
    self.houseNumberLable.text = [NSString stringWithFormat:@"%d",self.houseNumber];
    self.housePriceLable.text = [NSString stringWithFormat:@"房价 %d",self.housePrice *self.houseNumber];
}

- (IBAction)checkButtonClicked:(UIButton *)sender {
    if (!_isChecked) {
        _isChecked = YES;
        [sender setBackgroundColor:[UIColor redColor]];
    }else{
        _isChecked = NO;
        [sender setBackgroundColor:[UIColor blueColor]];
    }
}

- (IBAction)addHouseNumberClicked:(id)sender {
    self.houseNumber++;
    if (self.houseNumber >= 50) {
        self.houseNumber = 50;
    }
    self.houseNumberLable.text =[NSString stringWithFormat:@"%d",self.houseNumber];
    self.housePriceLable.text = [NSString stringWithFormat:@"房价 ¥%d",self.houseNumber * _housePrice];
}
- (IBAction)decreaseHouseNumberClicked:(id)sender {
    self.houseNumber--;
    if (self.houseNumber <= 0) {
        self.houseNumber = 0;
    }
    self.houseNumberLable.text =[NSString stringWithFormat:@"%d",self.houseNumber];
    self.housePriceLable.text = [NSString stringWithFormat:@"房价 ¥%d",self.houseNumber * _housePrice];
}
#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_peopleNumberLable release];
    [_houseNumberLable release];
    [_housePriceLable release];
    [super dealloc];
}
#endif
@end
