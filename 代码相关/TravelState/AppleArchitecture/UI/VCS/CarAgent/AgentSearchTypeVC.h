//
//  AgentSearchTypeVC.h
//  lvtubangmember
//
//  Created by klbest1 on 14-4-9.
//  Copyright (c) 2014年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TABLEROWWIDTH   73
#define TABLEROWHEIGHT 38

@protocol AgentSearchTypeVCDelegate <NSObject>
-(void)didAgentSearchTypeVCSeletedType:(NSInteger)aType Name:(NSString *)aName;

@end

@interface AgentSearchTypeVC : UITableViewController

@property (nonatomic,assign) id<AgentSearchTypeVCDelegate>  delegate;

@property (nonatomic,retain) NSMutableArray *typeArray;
@property (nonatomic,assign) float tableWidth;
@end
