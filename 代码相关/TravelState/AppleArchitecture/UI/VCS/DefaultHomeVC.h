//
//  DefaultHomeViewController.h
//  ZHMS-PDA
//
//  Created by klbest1 on 13-12-13.
//  Copyright (c) 2013年 Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "AdView.h"

@protocol DefaultHomeVCDelegate <NSObject>
-(void)didChosedSelfDrive:(id)sender;
-(void)didChosedMyLvtuBang:(id)sender;
-(void)didChosedInsureAndAgent:(id)sender;
@end
@interface DefaultHomeVC : BaseViewController<SGFocusImageFrameDelegate,AdViewDelegate>

@property (nonatomic,assign) id <DefaultHomeVCDelegate> delegate;

@property (nonatomic,retain) NSMutableArray *adInfoArray;

@property (nonatomic,retain) NSMutableArray *noticeArray;

@end
