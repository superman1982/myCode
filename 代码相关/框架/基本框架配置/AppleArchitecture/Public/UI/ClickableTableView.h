//
//  ClickableTableView.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-12.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickableTableViewDelegate <NSObject>

-(void)tableTouchBegain:(NSSet *)touches withEvent:(UIEvent *)event;

@end
@interface ClickableTableView : UITableView

@property (nonatomic,assign) id clickeDelegate;
@end
