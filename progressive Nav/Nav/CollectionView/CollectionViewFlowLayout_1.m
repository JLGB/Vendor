//
//  CollectionViewFlowLayout_1.m
//  Nav
//
//  Created by jinbolu on 17/3/22.
//  Copyright © 2017年 ___jb___. All rights reserved.
//

#import "CollectionViewFlowLayout_1.h"

@implementation CollectionViewFlowLayout_1


/*基本使用布局*/
- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat inset = 10.f;
    
    self.minimumLineSpacing = inset;//水平间距
    self.minimumInteritemSpacing = 0;//垂直间距
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);//缩进
    self.itemSize = CGSizeMake(200, 300);//每个item大小
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
}


/*动态布局*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.frame.size.width/2 + self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat distance = ABS(attr.center.x - centerX);
        CGFloat scal = 1.2 - distance/self.collectionView.frame.size.width;
        attr.transform = CGAffineTransformMakeScale(scal, scal);
    }
    
    return attrs;
}

@end
