//
//  ViewController.m
//  Nav
//
//  Created by jinbolu on 17/3/17.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+Transition.h"
#import "CollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarAlpha = 1;
    self.navigationBarTintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0];
    
    self.title = @"first";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = self.view.bounds;
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(clock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clock:(id)sender {
    CollectionViewController *vc = [[CollectionViewController alloc] initWithType:1];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
