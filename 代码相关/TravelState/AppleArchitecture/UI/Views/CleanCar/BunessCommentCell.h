//
//  BunessCommentCell.h
//  LvTuBang
//
//  Created by klbest1 on 14-3-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BunessCommentCell : UITableViewCell
//头像
@property (retain, nonatomic) IBOutlet UIImageView *headerImageUrl;
//时间
@property (retain, nonatomic) IBOutlet UILabel *date;
//评论内容
@property (retain, nonatomic) IBOutlet UILabel *content;
//昵称
@property (retain, nonatomic) IBOutlet UILabel *nickName;

@property (retain, nonatomic) IBOutlet UILabel *memberLevelLable;
//添加星星
@property (retain, nonatomic) IBOutlet UIImageView *starImageView;
//星级
@property (nonatomic,retain) NSNumber *stars;

-(void)setCell:(NSDictionary *)aDic;
-(void)setHightOfCell:(NSString *)aContentStr;
@end
