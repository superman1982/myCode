//
//  kZUIImageView.m
//  测试ShowPhoto
//
//  Created by lin on 14-10-13.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import "kZUIImageView.h"

@implementation kZUIImageView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self layoutSubviews];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutSubviews];
}

-(void)layoutSubviews{

}

-(void)setupViews{

}


-(void)dealloc{
    [super dealloc];
}
@end
