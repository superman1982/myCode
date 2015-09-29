//
//  NoticeCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextView *noticeDescriptionLable;
@property (retain, nonatomic) IBOutlet UILabel *timeLable;
@property (retain, nonatomic) IBOutlet UIButton *handleImedialyButton;
@end
