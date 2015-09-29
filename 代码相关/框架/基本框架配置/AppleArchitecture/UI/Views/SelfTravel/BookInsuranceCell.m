//
//  BookInsuranceCell.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "BookInsuranceCell.h"

@implementation BookInsuranceCell

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

- (IBAction)addButtonClicked:(id)sender {
    _numberOfInurance++;
    if (_numberOfInurance >= 50) {
        _numberOfInurance = 50;
    }
    self.numberOfInuranceLable.text = [NSString stringWithFormat:@"%d",_numberOfInurance];
    self.insurancePriceLable.text = [NSString stringWithFormat:@"%d",_numberOfInurance * _inurancePrice];
    if ([_delegate respondsToSelector:@selector(didBookInsuranceCellChanged:)]) {
        [_delegate didBookInsuranceCellChanged:[NSNumber numberWithInt:_numberOfInurance]];
    }
}

- (IBAction)decreaseButtonClicked:(id)sender {
    _numberOfInurance--;
    if (_numberOfInurance <= 0) {
        _numberOfInurance = 0;
    }
    self.numberOfInuranceLable.text = [NSString stringWithFormat:@"%d",_numberOfInurance];
    self.insurancePriceLable.text = [NSString stringWithFormat:@"%d",_numberOfInurance * _inurancePrice];
    if ([_delegate respondsToSelector:@selector(didBookInsuranceCellChanged:)]) {
        [_delegate didBookInsuranceCellChanged:[NSNumber numberWithInt:_numberOfInurance]];
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_numberOfInuranceLable release];
    [_insurancePriceLable release];
    [super dealloc];
}
#endif
@end
