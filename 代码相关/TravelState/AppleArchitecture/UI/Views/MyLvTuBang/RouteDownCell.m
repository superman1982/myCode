//
//  RouteDownCell.m
//  lvtubangmember
//
//  Created by klbest1 on 14-4-26.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "RouteDownCell.h"

@implementation RouteDownCell

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

/*"signupUsers":
 [
 {
 "userId": "String:如果有,则为用户Id,否则为空",
 "phone": "String:手机号码",
 "name": "String:姓名",
 "sex": "String:性别(男、女)",
 "idNumber": "String:身份证号码",
 "QQ": "String:QQ号码",
 "email": "String:邮箱"
 }
 …
 ],
 "doubleQuantity": "int:双人间数量",
 "singleQuantity": "int:单人间数量",
 "isWishSpell": "int:愿意拼房，0不愿意，1愿意",
 "provideCar":
 {
 "carBrand": "String:车牌",
 "carModel": "String:车型",
 "driver": "String:司机",
 "phone": "String:手机号码",
 "seatQuantity": "int:可提供的座位数"
 },
 "needCar":
 {
 "provideCarId":"int:提供拼车Id",
 "needSeat": "int:需要的座位数"
 },
 "insuranceCount": "int:保险数附加购买的保险数据"
*/
-(void)setCell:(NSDictionary *)aDic Section:(NSInteger)aSection Row:(NSInteger)aRow{
    if (aDic.count == 0) {
        _firstLable.text = @"";
        _secondLable.text = @"";
        _thirdLable.text = @"";
        return;
    }
    if (aSection == 1) {
        NSArray *signupUsers = [NSArray arrayWithArray:[aDic objectForKey:@"signupUsers"] ];
        NSDictionary *vSingDic = [signupUsers objectAtIndex:aRow];
        self.firstLable.text = [vSingDic objectForKey:@"phone"];
        self.secondLable.text = [vSingDic objectForKey:@"name"];
        self.thirdLable.hidden = YES;
    }else if (aSection == 2){
        if (aRow == 0) {
            NSNumber *vSingleNumber = [aDic objectForKey:@"singleQuantity"];
            if ([vSingleNumber intValue] > 0) {
                self.firstLable.text = @"单人间";
                self.secondLable.text = [NSString stringWithFormat:@"数量: %@", vSingleNumber];
            }else{
                self.firstLable.text = @"双人间";
                self.secondLable.text = [NSString stringWithFormat:@"数量: %@",[aDic objectForKey:@"doubleQuantity"] ];
            }
            self.thirdLable.hidden = YES;
        }
    }else if (aSection == 3){
        NSArray *provideCarArray = [aDic objectForKey:@"provideCar"];
        NSDictionary *provideCar = [provideCarArray objectAtIndex:aRow];
        if (provideCar.count > 0) {
            self.firstLable.text = @"提供拼车";
            self.secondLable.text = [NSString stringWithFormat:@"%@ %@",[provideCar objectForKey:@"carModel"],[provideCar objectForKey:@"carBrand"] ];
            self.thirdLable.text = [NSString stringWithFormat:@"可拼 %@人",[provideCar objectForKey:@"seatQuantity"]];
        }else{
            NSDictionary *needCar = [aDic objectForKey:@"needCar"];
            self.firstLable.text = @"需要拼车";
            self.secondLable.text = [NSString stringWithFormat:@"需提供座位 %@",[needCar objectForKey:@"needSeat"] ];
            self.thirdLable.hidden = YES;
        }
        
    }else if (aSection == 4){
        self.firstLable.text = @"保险数量";
        self.secondLable.text = [NSString stringWithFormat:@" %@",[aDic objectForKey:@"insuranceCount"] ];
        self.thirdLable.hidden = YES;
    }
    
}

@end
