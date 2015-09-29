//
//  SlideTableViewCell.h
//  测试滑动删除Cell
//
//  Created by lin on 14-8-7.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideTableViewCellDelegate <NSObject>

-(void)didCellWillHide:(id)aSender;
-(void)didCellHided:(id)aSender;
-(void)didCellWillShow:(id)aSender;
-(void)didCellShowed:(id)aSender;
-(void)didCellClickedDeleteButton:(id)aSender;
-(void)didCellClickedMoreButton:(id)aSender;
@end

@interface SKSlideTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    CGFloat startLocation;
    BOOL    hideMenuView;
}



@property (retain, nonatomic) IBOutlet UIView *moveContentView;

@property (nonatomic,assign) id<SlideTableViewCellDelegate> delegate;

-(void)hideMenuView:(BOOL)aHide Animated:(BOOL)aAnimate;
-(void)addControl;
@end
