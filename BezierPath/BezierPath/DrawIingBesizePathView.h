//
//  DrawIingBesizePathView.h
//  BezierPath
//
//  Created by jinbolu on 17/3/23.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawIingBesizePathView : UIView
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineAlpha;

- (NSMutableArray *)totalBesizePaths;
- (void)undoLastStep;
- (void)clear;
@end
