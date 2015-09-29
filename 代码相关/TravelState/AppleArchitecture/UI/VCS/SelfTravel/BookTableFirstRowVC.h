//
//  BookTableFirstRowVC.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-19.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FillPeopleInfoVC.h"
#import "ActiveInfo.h"

@protocol BookTableFirstRowVCDelegate <NSObject>

-(void)didFinishFillFirstRow:(id)sender;
@end
@interface BookTableFirstRowVC : UIViewController<FillPeopleInfoVCDelegate>

@property (retain, nonatomic) IBOutlet UITableView *firstRowTableView;
@property (nonatomic,retain) id<BookTableFirstRowVCDelegate> delegate;
@property (nonatomic,retain) ActiveInfo *activeInfo;

@property (nonatomic,assign) NSInteger  signupType;

-(void)setViewFrame;

@end
