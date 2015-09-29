//
//  PECropRectView.h
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECropRectView : UIView

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL showsGridMajor;
@property (nonatomic,assign) BOOL showsGridMinor;

@end

@protocol PECropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView;

@end

