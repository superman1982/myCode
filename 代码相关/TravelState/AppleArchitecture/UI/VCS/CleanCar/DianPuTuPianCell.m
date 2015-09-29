//
//  DianPuTuPianCell.m
//  CTBMobilePro
//
//  Created by klbest1 on 13-8-14.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import "DianPuTuPianCell.h"

@implementation DianPuTuPianCell

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

- (IBAction)cellButtonClicked:(id)sender {

    if ([self.delegate respondsToSelector:@selector(tuPianChosed:)]) {
        [self.delegate tuPianChosed:((UIButton *)sender).tag];
    }
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_imageView3 release];
    [_iamgeView4 release];
    [_button3 release];
    [_button4 release];
    [_button1 release];
    [_button2 release];
    [super dealloc];
}
#endif
@end
