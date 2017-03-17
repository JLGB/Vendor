//
//  TableViewController.m
//  Nav
//
//  Created by jinbolu on 17/3/17.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "TableViewController.h"
#import "UINavigationController+Transition.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarAlpha = 0;
    
    self.navigationBarTintColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.1 alpha:1];
    
    
    
    
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor orangeColor];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor orangeColor];
    headerView.bounds = CGRectMake(0, 0, 0, 100);
    UIView *headIcon = [UIView new];
    headIcon.backgroundColor = [UIColor whiteColor];
    headIcon.frame = CGRectMake(130, 0, 90, 90);
    [headerView addSubview:headIcon];
    self.tableView.tableHeaderView = headerView;
    
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat showNavBarOffsetY = 100 - self.topLayoutGuide.length;
    
    
    if (yOffset > showNavBarOffsetY) {
        CGFloat alpha = (yOffset - showNavBarOffsetY)/40.f;
    
        if (alpha > 1) {
            alpha = 1;
        }
        self.navigationBarAlpha = alpha;
        self.navigationBarTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
    }else{
        self.navigationBarAlpha = 0;
        self.navigationBarTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}




@end
