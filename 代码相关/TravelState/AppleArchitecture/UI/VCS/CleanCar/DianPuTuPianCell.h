//
//  DianPuTuPianCell.h
//  CTBMobilePro
//
//  Created by klbest1 on 13-8-14.
//  Copyright (c) 2013年 xingde. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DianPuTuPianCellDelegate <NSObject>

-(void)tuPianChosed:(NSInteger)pIndex;

@end

@interface DianPuTuPianCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *button1;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;

@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;


@property (retain, nonatomic) IBOutlet UIButton *button3;
@property (retain, nonatomic) IBOutlet UIImageView *imageView3;


@property (retain, nonatomic) IBOutlet UIButton *button4;
@property (retain, nonatomic) IBOutlet UIImageView *iamgeView4;

@property (nonatomic,assign) id<DianPuTuPianCellDelegate> delegate;
@end
