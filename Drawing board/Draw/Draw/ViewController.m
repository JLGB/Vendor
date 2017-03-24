//
//  ViewController.m
//  Draw
//
//  Created by jinbolu on 17/3/22.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "ViewController.h"
#import "DrawBoard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    DrawBoard *view = [[DrawBoard alloc] initWithFrame:self.view.bounds];
    view.lineColor = [UIColor purpleColor];
    view.lineAlpha = 1;
    view.lineWidth = 2;
    self.view = view;
    
    UIButton *undoBtn = [UIButton new];
    [undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    undoBtn.frame = CGRectMake(30, 20, 40, 40);
    undoBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:undoBtn];
    
    [undoBtn addTarget:view action:@selector(undoLatestStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *clearBtn = [UIButton new];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.frame = CGRectMake(100, 20, 40, 40);
    clearBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:clearBtn];
    
    [clearBtn addTarget:view action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *repalyBtn = [UIButton new];
    [repalyBtn setTitle:@"播放" forState:UIControlStateNormal];
    repalyBtn.frame = CGRectMake(200, 20, 40, 40);
    repalyBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:repalyBtn];
    
    [repalyBtn addTarget:view action:@selector(replayDrawAnimation) forControlEvents:UIControlEventTouchUpInside];

}


@end
