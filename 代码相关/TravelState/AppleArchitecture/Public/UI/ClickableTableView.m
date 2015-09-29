//
//  ClickableTableView.m
//  LvTuBang
//
//  Created by klbest1 on 14-2-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import "ClickableTableView.h"

@implementation ClickableTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_clickeDelegate respondsToSelector:@selector(tableTouchBegain:withEvent:)]) {
        [_clickeDelegate tableTouchBegain:touches withEvent:event];
    }
}
@end
