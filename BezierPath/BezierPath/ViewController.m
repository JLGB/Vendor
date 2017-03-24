//
//  ViewController.m
//  BezierPath
//
//  Created by jinbolu on 17/3/23.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "ViewController.h"
#import "DrawIingBesizePathView.h"

@interface ViewController ()
@property (nonatomic,strong) DrawIingBesizePathView *bezieView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DrawIingBesizePathView *view = [DrawIingBesizePathView new];
    view.lineColor = [UIColor purpleColor];
    view.lineWidth = 2;
    view.lineAlpha = 1;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    self.bezieView = view;
    
    UIButton *repeatBtn = [UIButton new];
    repeatBtn.frame = CGRectMake(0, 0, 40, 40);
    repeatBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:repeatBtn];
    
    [repeatBtn addTarget:self action:@selector(repeatClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *undoBtn = [UIButton new];
    undoBtn.frame = CGRectMake(100, 0, 40, 40);
    undoBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:undoBtn];
    
    [undoBtn addTarget:view action:@selector(undoLastStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *clearBtn = [UIButton new];
    clearBtn.frame = CGRectMake(100, 0, 40, 40);
    clearBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:clearBtn];
    
    [clearBtn addTarget:view action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];

}


- (void)repeatClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.bezieView.hidden = btn.selected;
    
    if (btn.selected) {
        NSInteger i = 0;
        NSArray *bezierPaths = [self.bezieView totalBesizePaths];
        for (UIBezierPath *bezierPath in bezierPaths) {
            [self performSelector:@selector(drawBesizePath:) withObject:bezierPath afterDelay:1*i];
            i++;
        }
    }else{
    
    }
}

- (void)drawBesizePath:(UIBezierPath *)besizerPath{
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.strokeColor = [UIColor purpleColor].CGColor;
    layer.lineDashPattern = @[@(5)];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    
    
    layer.path = besizerPath.CGPath;
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration = 1.f;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anim.fromValue = @(0);
    anim.toValue = @(1);
//    anim.autoreverses = YES;
    anim.fillMode = kCAFillModeForwards;
//    anim.repeatCount = 1;
    [layer addAnimation:anim forKey:@"strokeEndAnim"];
}



@end
