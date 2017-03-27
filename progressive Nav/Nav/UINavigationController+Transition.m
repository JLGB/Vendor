//
//  UINavigationController+Transition.m
//  Nav
//
//  Created by jinbolu on 17/3/17.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "UINavigationController+Transition.h"
#import <objc/runtime.h>



@implementation UINavigationController (Transition)

- (void)viewDidLoad{
    [UINavigationController swizzleInstanceMethod:@selector(_updateInteractiveTransition:) with:@selector(et_updateInteractiveTransition:)];
    [UINavigationController swizzleInstanceMethod:@selector(popToViewController:animated:) with:@selector(et_popToViewController:animated:)];
    [UINavigationController swizzleInstanceMethod:@selector(popToRootViewControllerAnimated:) with:@selector(et_popToRootViewControllerAnimated:)];
   
    
    [super viewDidLoad];
    self.delegate = self;
}

- (void)et_updateInteractiveTransition:(CGFloat)percentComplete{
    [self et_updateInteractiveTransition:percentComplete];
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.topViewController.transitionCoordinator;
    
    CGFloat fromAlpha = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;
    CGFloat toAlpha = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarAlpha;
    CGFloat nowAlpha = fromAlpha + (toAlpha-fromAlpha)*percentComplete;
    
    [self setNeedsNavigationBackground:nowAlpha];
    
    UIColor *fromColor = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarTintColor;
    UIColor *toColor = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarTintColor;
    UIColor *nowColor = [self averageFromColor:fromColor toColor:toColor percent:percentComplete];
    self.navigationBar.tintColor = nowColor;
}

- (NSArray<UIViewController *> *)et_popToRootViewControllerAnimated:(BOOL)animated{
    UIViewController *viewController = self.viewControllers.firstObject;
    [self setNeedsNavigationBackground:viewController.navigationBarAlpha];
    self.navigationBar.tintColor = viewController.navigationBarTintColor;
    return [self et_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)et_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self setNeedsNavigationBackground:viewController.navigationBarAlpha];
    self.navigationBar.tintColor = viewController.navigationBarTintColor;
    return [self et_popToViewController:viewController animated:animated];
}

#pragma mark Pravite



+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod([UINavigationController class],
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod([UINavigationController class],
                    newSel,
                    class_getMethodImplementation([UINavigationController class], newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod([UINavigationController class], originalSel),
                                   class_getInstanceMethod([UINavigationController class], newSel));
    return YES;
}


- (UIColor *)averageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent{
    
    CGFloat fromRed = 0.f;
    CGFloat fromGreen = 0.f;
    CGFloat fromBlue = 0.f;
    CGFloat fromAlpha = 0.f;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0.f;
    CGFloat toGreen = 0.f;
    CGFloat toBlue = 0.f;
    CGFloat toAlpha = 0.f;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat nowRed = fromRed + (toRed-fromRed)*percent;
    CGFloat nowGreen = fromGreen + (toGreen-fromGreen)*percent;
    CGFloat nowBlue = fromBlue + (toBlue-fromBlue)*percent;
    CGFloat nowAlpha =fromAlpha + (toAlpha-fromAlpha)*percent;
    
    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha{
    UIView *barBackgroundView = self.navigationBar.subviews.firstObject;
    UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
    shadowView.alpha = alpha;
    
    if (self.navigationBar.isTranslucent) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
        UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
        backgroundEffectView.alpha = alpha;
        
        return;
#else
        UIView *adaptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
        adaptiveBackdrop.alpha = alpha;
        if (adaptiveBackdrop) {
            UIView *backgroundEffectView = [adaptiveBackdrop valueForKey:@"_backdropEffectView"];
            backgroundEffectView.alpha = alpha;
        }

        return;
#endif
    }
    barBackgroundView.alpha = alpha;
    
}

#pragma mark UINavigationBarDelegate UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *topVC = navigationController.topViewController;
    
    id<UIViewControllerTransitionCoordinator> coordinator = topVC.transitionCoordinator;
    

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
        [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self dealInteractionChanges:context];
        }];
#else
        [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self dealInteractionChanges:context];
        }];

#endif
    
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id coordinator = topVC.transitionCoordinator;
        if ([coordinator initiallyInteractive]) {
            return YES;
        }
    }
    
    UIViewController *popToVC = nil;
    if (self.viewControllers.count >= navigationBar.items.count) {
        popToVC = self.viewControllers[self.viewControllers.count - 2];
    }else{
        popToVC = self.viewControllers[self.viewControllers.count - 1];
    }
    
    if (popToVC) {
        [self popToViewController:popToVC animated:YES];
        return YES;
    }
    
    return NO;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    [self setNeedsNavigationBackground:self.topViewController.navigationBarAlpha];
    navigationBar.tintColor = self.topViewController.navigationBarTintColor;
    return YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context{
    if ([context isCancelled]) {
        NSTimeInterval cancellDuration = [context transitionDuration] * [context percentComplete];
        
        [UIView animateWithDuration:cancellDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarAlpha;
            [self setNeedsNavigationBackground:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarTintColor;
        }];
    }else{
        NSTimeInterval finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [context viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarAlpha;
            [self setNeedsNavigationBackground:nowAlpha];
            self.navigationBar.tintColor = [context viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarTintColor;
        }];

    }
}

@end

@implementation UIViewController (Transition)
- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha{
    if (navigationBarAlpha > 1) {
        navigationBarAlpha = 1;
    }else if (navigationBarAlpha < 0){
        navigationBarAlpha = 0;
    }
    
    [self setAssociateValue:@(navigationBarAlpha) withKey:@"navigationBarAlpha"];
    [self.navigationController setNeedsNavigationBackground:navigationBarAlpha];
}

- (CGFloat)navigationBarAlpha{
    
    return [[self getAssociatedValueForKey:@"navigationBarAlpha"] floatValue];
}


- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor{
    self.navigationController.navigationBar.tintColor = navigationBarTintColor;
    [self setAssociateValue:navigationBarTintColor withKey:@"navigationBarTintColor"];
}

- (UIColor *)navigationBarTintColor{
    return [self getAssociatedValueForKey:@"navigationBarTintColor"];
}

- (id)getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)setAssociateValue:(id)value withKey:(void *)key {
    
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end



