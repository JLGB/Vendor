//
//  DrawBoard.m
//  Draw
//
//  Created by jinbolu on 17/3/24.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "DrawBoard.h"
#import "BezierPen.h"

@interface DrawBoard (){
    NSTimer * _timer;
}
@property (nonatomic,strong) NSMutableArray *bezierPenArray;
@property (nonatomic,strong) BezierPen *currenPen;

@property (nonatomic,strong) UIImage *snapshot;

@property (nonatomic,strong) NSMutableArray *shapLayers;
@end

@implementation DrawBoard

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 

- (void)setAnimationPaused:(BOOL)paused{
//     [_timer ];
}

- (void)replayDrawAnimation{

    NSArray *bufferBezierPenArray = [self.bezierPenArray copy];
    [self clear];
    
    NSMutableArray *delay = [NSMutableArray new];
    CGFloat duration = 0.f;
    for (BezierPen *pen in bufferBezierPenArray) {
        duration += pen.duration;
        [delay addObject:@(duration)];
    }
    [delay insertObject:@(0) atIndex:0];
    

    for (NSInteger i = 0; i < bufferBezierPenArray.count; i++) {
        BezierPen *pen = bufferBezierPenArray[i];
        NSNumber *durationNum = delay[i];
        [self performSelector:@selector(bezierAnimation:) withObject:pen afterDelay:durationNum.floatValue];
    }
    
    NSNumber *durationNum = delay.lastObject;
    [self performSelector:@selector(completAnimation:) withObject:bufferBezierPenArray afterDelay:durationNum.floatValue];
}

- (void)bezierAnimation:(BezierPen *)pen{
    CAShapeLayer *layer = [self addShapLayer];
    
    layer.path = pen.CGPath;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = pen.duration;
    //    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.fromValue = @(0);
    anim.toValue = @(1);
    //    anim.autoreverses = YES;
    anim.fillMode = kCAFillModeForwards;
    //    anim.repeatCount = 1;
    [layer addAnimation:anim forKey:@"strokeEndAnim"];
}


- (void)completAnimation:(NSArray *)bufferPaths{
    for (BezierPen *pen in bufferPaths) {
        [self.bezierPenArray addObject:pen];
    }
    for (CAShapeLayer *layer in self.shapLayers) {
        [layer removeFromSuperlayer];
    }
    [self.shapLayers removeAllObjects];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    self.snapshot = nil;
    for (BezierPen *pen in self.bezierPenArray) {
        [pen draw];
    }
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}


- (void)clear{
    [self.bezierPenArray removeAllObjects];
    [self undoLatestStep];
}

- (void)undoLatestStep
{
    if (self.bezierPenArray.count ) [self.bezierPenArray removeLastObject];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    self.snapshot = nil;
    for (BezierPen *pen in self.bezierPenArray) {
        [pen draw];
    }
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // init the bezier path
    BezierPen *pen = [BezierPen new];
    pen.lineAlpha = self.lineAlpha;
    pen.lineWidth = self.lineWidth;
    pen.lineColor = self.lineColor;
    [self.bezierPenArray addObject:pen];
    self.currenPen = pen;
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    [pen setInitialPoint:[touch locationInView:self]];
    
    // call the delegate
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
    CGPoint previousLocation = [touch previousLocationInView:self];
    [self.currenPen moveFromPoint:previousLocation toPoint:currentLocation];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    [self cacheSnapshot];
    
    // clear the current tool
    self.currenPen = nil;
    
    // clear the redo queue
//    [self.bufferArray removeAllObjects];
    
    // call the delegate
//    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
//        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
//    }
}

#pragma mark drawRect

- (void)drawRect:(CGRect)rect{
    
    [self.snapshot drawInRect:self.bounds];
    
    [self.currenPen draw];
}


- (void)cacheSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        // set the draw point
        [self.snapshot drawAtPoint:CGPointZero];
        [self.currenPen draw];
    // store the image
    self.snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark lazy load

- (NSMutableArray *)bezierPenArray{
    if (_bezierPenArray) return _bezierPenArray;
    return _bezierPenArray = [NSMutableArray new];
}

- (CAShapeLayer *)addShapLayer{

    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    [self.layer addSublayer:shapLayer];
    shapLayer.strokeColor = self.lineColor.CGColor;
    shapLayer.fillColor = [UIColor clearColor].CGColor;
    shapLayer.lineWidth = self.lineWidth;
    shapLayer.lineJoin = kCALineJoinRound;
    shapLayer.lineCap = kCALineCapRound;
    [self.shapLayers addObject:shapLayer];
    return shapLayer;
}


- (NSMutableArray *)shapLayers{
    if (_shapLayers) return _shapLayers;
    return _shapLayers = [NSMutableArray array];
}



@end
