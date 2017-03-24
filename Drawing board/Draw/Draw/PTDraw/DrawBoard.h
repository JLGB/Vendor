//
//  DrawBoard.h
//  Draw
//
//  Created by jinbolu on 17/3/24.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawBoard : UIView
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineAlpha;

- (void)undoLatestStep;
- (void)clear;

- (void)replayDrawAnimation;
- (void)setAnimationPaused:(BOOL)paused;
@end
