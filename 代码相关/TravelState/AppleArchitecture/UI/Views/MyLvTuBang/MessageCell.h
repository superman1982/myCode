//
//  MessagerCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-2-11.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UITextView *messageLable;
@property (retain, nonatomic) IBOutlet UILabel *timeLable;

@end
