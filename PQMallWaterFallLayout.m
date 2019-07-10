//
//  PQMallWaterFallLayout.m
//  WaterFall
//
//  Created by eassy on 2019/7/10.
//  Copyright © 2019年 eassy. All rights reserved.
//

#import "PQMallWaterFallLayout.h"

@interface PQMallWaterFallLayout()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray * attrsArr;
/** 存放所有列的当前高度 只对两行有用 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

- (NSUInteger)colunmCount;

- (CGFloat)columnMargin;

- (CGFloat)rowMargin;

@end

/** 默认的列数    */
static const CGFloat LMHDefaultColunmCount = 2;
/** 每一列之间的间距    */
static const CGFloat LMHDefaultColunmMargin = 5;

/** 每一行之间的间距    */
static const CGFloat LMHDefaultRowMargin = 5;

/** 内边距    */
static const UIEdgeInsets LMHDefaultEdgeInsets = {0,0,0,0};


@implementation PQMallWaterFallLayout


#pragma mark 懒加载
- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
}

#pragma mark - 数据处理
/**
 * 列数
 */
- (NSUInteger)colunmCount{
    
    return LMHDefaultColunmCount;
}

/**
 * 列间距
 */
- (CGFloat)columnMargin{
    return LMHDefaultColunmMargin;
}

/**
 * 行间距
 */
- (CGFloat)rowMargin{
    return LMHDefaultRowMargin;
}

/**
 * 初始化
 */
- (void)prepareLayout{
    
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清除之前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    // 设置每一列默认的高度
    for (NSInteger i = 0; i < LMHDefaultColunmCount ; i ++) {
        [self.columnHeights addObject:@(LMHDefaultEdgeInsets.top)];
    }
    
    
    // 清楚之前所有的布局属性
    [self.attrsArr removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i ++) {
        if (i == self.sectionOfTwoLine) {
            self.columnHeights[0] = @(self.contentHeight + self.insetOfTwoLine.top);
            self.columnHeights[1] = @(self.contentHeight + self.insetOfTwoLine.top);
        }
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < count; j++) {
            
            // 创建位置
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            // 获取indexPath位置上cell对应的布局属性
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            [self.attrsArr addObject:attrs];
        }
    }
    
    
    
    
}


/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (indexPath.section < self.sectionOfTwoLine) {
        CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
        CGFloat cellH = [self.delegate itemHeightForIndexPath:indexPath];
        CGFloat cellX = 0;
        CGFloat cellY = self.contentHeight;
        self.contentHeight += cellH;
        attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        return attrs;
    }
    //collectionView的宽度
    CGFloat collectionViewW = [UIScreen mainScreen].bounds.size.width;
    
    // 设置布局属性的frame
    
    CGFloat cellW = (collectionViewW - self.insetOfTwoLine.left - self.insetOfTwoLine.right - (self.colunmCount - 1) * self.columnMargin) / self.colunmCount;
    CGFloat cellH = [self.delegate itemHeightForIndexPath:indexPath];
    
    
    // 找出最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (int i = 1; i < LMHDefaultColunmCount; i++) {
        
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat cellX = self.insetOfTwoLine.left + destColumn * (cellW + self.columnMargin);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.insetOfTwoLine.top) {
        
        cellY += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    // 更新最短那一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }
    
    return attrs;
}

/**
 * 决定cell的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArr;
}

/**
 * 内容的高度
 */
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.contentHeight + self.insetOfTwoLine.bottom);
}

@end
