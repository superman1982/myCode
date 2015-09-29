//
//  SecrityButtonManeger.h
//  lvtubangmember
//
//  Created by klbest1 on 14-3-25.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SecrityButtonManegerDelegate <NSObject>
-(NSString *)didSecrityButtonManegerButtonClicked:(id)sender;
@end

@interface SecrityButtonManeger : NSObject
{
    NSTimer *mTimer;
    NSInteger mseconds;
    BOOL isAcounting;
}
@property (nonatomic,assign) id <SecrityButtonManegerDelegate> delegate;

-(id)init;
-(UIButton *)creatSecrityCodeButton;
+(void)getSecrityCode:(NSString *)sender;
@end
