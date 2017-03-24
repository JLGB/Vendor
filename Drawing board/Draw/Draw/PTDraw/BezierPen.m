//
//  BezierPen.m
//  Draw
//
//  Created by jinbolu on 17/3/24.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "BezierPen.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@interface BezierPen ()

@end

@implementation BezierPen


- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        self.startPotins = [NSMutableArray array];
        self.endPotins = [NSMutableArray array];
    }
    return self;
}

- (CGFloat)duration{
    return self.startPotins.count * 0.05;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    
    CGPoint toPoint = midPoint(endPoint, startPoint);
    
    NSPoint *point = [NSPoint new];
    point.x = endPoint.x;
    point.y = endPoint.y;
    [_endPotins addObject:point];
    
    NSPoint *point0 = [NSPoint new];
    point0.x = startPoint.x;
    point0.y = startPoint.y;
    [_startPotins addObject:point0];

    [self addQuadCurveToPoint:toPoint controlPoint:startPoint];
}

- (void)draw
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}

@end


@implementation NSPoint



@end
