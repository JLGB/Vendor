//
//  UINavigationController+Transition.h
//  Nav
//
//  Created by jinbolu on 17/3/17.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Transition)

@end


@interface UIViewController (Transition)<UINavigationControllerDelegate,UINavigationBarDelegate>
@property (nonatomic,assign) CGFloat navigationBarAlpha;
@property (nonatomic,strong) UIColor *navigationBarTintColor;
@end
