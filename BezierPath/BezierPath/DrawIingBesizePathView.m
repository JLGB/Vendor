//
//  DrawIingBesizePathView.m
//  BezierPath
//
//  Created by jinbolu on 17/3/23.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "DrawIingBesizePathView.h"

@interface DrawIingBesizePathView()
@property (nonatomic,assign) BOOL shouldSnap;
@property (nonatomic,strong) UIImage *snapshot;

@property (nonatomic,assign) CGPoint firstPoint;
@property (nonatomic,assign) CGPoint lastPoint;

@property (nonatomic,assign) BOOL isPathAdjusting;
@property (nonatomic,strong) UIView *anchorView;

@property (nonatomic,strong) NSMutableArray *besizePaths;
//@property (nonatomic,strong) NSMutableArray *bufferBesizePaths;
@property (nonatomic,strong) UIBezierPath *lastBezierPath;

@property (nonatomic,assign) BOOL isFirstTouch;
@property (nonatomic,assign) BOOL haveBackStep;//回退步数
@end

@implementation DrawIingBesizePathView

- (NSMutableArray *)totalBesizePaths{
    NSMutableArray *array = [NSMutableArray array];
    
    for (id obj in self.besizePaths) {
        [array addObject:obj];
    }
    if (self.lastBezierPath) {
        [array addObject:self.lastBezierPath];
    }
    return array;
}

- (void)clear{
    [self.besizePaths removeAllObjects];
    [self undoLastStep];
}

- (void)undoLastStep{
    
    self.isFirstTouch = YES;
    self.firstPoint = CGPointZero;
    self.lastPoint = CGPointZero;
    
    if (self.lastBezierPath == nil) return;
    
    if (_haveBackStep) {
        [self.besizePaths removeLastObject];
    }else{
        self.haveBackStep = YES;
    }
   
    NSLog(@"besizePaths :%ld",_besizePaths.count);
    

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        // erase the previous image
        self.snapshot = nil;
        
        // I need to redraw all the lines
        for (UIBezierPath *bPath in self.besizePaths) {
            [bPath strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
            [self setNeedsDisplay];
        }
    // store the image
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}

#pragma mark View Touch
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.isFirstTouch = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // add the first touch
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    self.haveBackStep = NO;
    self.isPathAdjusting = NO;
    
    
    if (self.anchorView) {
        if (CGRectContainsPoint(self.anchorView.frame, point)) {
            self.isPathAdjusting = YES;
        }
    }

    if (self.isPathAdjusting) {
        
        
    }else{
        //缓存图片
        if (self.isFirstTouch == NO) {
            [self cacheSnapshot];
        }
        self.isFirstTouch = NO;
        

        self.firstPoint = point;
        [self.anchorView removeFromSuperview];
        self.anchorView = nil;
        
    }
    
//    // call the delegate
//    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
//        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
//    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
//    CGPoint previousLocation = [touch previousLocationInView:self];
    
    
    if (self.isPathAdjusting) {
        self.anchorView.center = currentLocation;
    }else{
        self.lastPoint = currentLocation;
    }

    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    
    if (self.isPathAdjusting == NO) {
        [self addAnchorPoint];
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark -

- (void)addAnchorPoint{
    CGFloat firstX = self.firstPoint.x ;
    CGFloat firstY = self.firstPoint.y ;
    
    CGFloat lastX = self.lastPoint.x ;
    CGFloat lastY = self.lastPoint.y ;
    
    CGFloat distanceX = lastX - firstX;
    CGFloat distanceY = lastY - firstY;
    
    NSInteger pointCount = 3;
    
    CGFloat x = firstX + distanceX * 1 / (pointCount -1);
    CGFloat y = firstY + distanceY * 1 / (pointCount -1);
    CGPoint point = CGPointMake(x, y);
    
    CGFloat btnW = 20.f;
    
    UIView *anchorView = [UIView new];
    anchorView.userInteractionEnabled = NO;
    anchorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    anchorView.layer.cornerRadius = btnW / 2;
    anchorView.layer.masksToBounds = YES;
    anchorView.bounds = CGRectMake(0, 0, btnW, btnW);
    anchorView.center = CGPointMake(point.x, point.y);
    [self addSubview:anchorView];
    self.anchorView = anchorView;
}


#pragma mark -

- (void)drawRect:(CGRect)rect{
    
    [self.snapshot drawInRect:self.bounds];
    
    [self drawiWithControl:self.isPathAdjusting];
}


- (void)cacheSnapshot
{
    // init a context
    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsGetCurrentContext();
    
    [self.snapshot drawAtPoint:CGPointZero];
    UIBezierPath *bezierPath = [self drawiWithControl:YES];
    [self.besizePaths addObject:bezierPath];
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}




- (UIBezierPath *)drawiWithControl:(BOOL)isControl{
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = self.lineWidth;//宽度
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineJoinRound;  //终点处理
    
    [self.lineColor set];
    
    //起始点
    [aPath moveToPoint:self.firstPoint];
    if (isControl == NO) {
        [aPath addLineToPoint:self.lastPoint];
    }else{
        //添加两个控制点
        [aPath addQuadCurveToPoint:self.lastPoint controlPoint:self.anchorView.center];
    }
        //划线
    //    [self.lineColor setStroke];
    [aPath stroke];
    self.lastBezierPath = aPath;
    return aPath;
}

#pragma mark lazy load
- (NSMutableArray *)besizePaths{
    if (_besizePaths) return _besizePaths;
    return _besizePaths = [NSMutableArray array];
}


@end
