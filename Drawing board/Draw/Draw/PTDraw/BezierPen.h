//
//  BezierPen.h
//  Draw
//
//  Created by jinbolu on 17/3/24.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSPoint : NSObject
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@end

@interface BezierPen : UIBezierPath
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign, readonly) CGFloat duration;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
- (void)draw;

@property (nonatomic,strong) NSMutableArray *startPotins;
@property (nonatomic,strong) NSMutableArray *endPotins;
@end
