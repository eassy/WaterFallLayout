//
//  PQMallWaterFallLayout.h
//  WaterFall
//
//  Created by eassy on 2019/7/10.
//  Copyright © 2019年 eassy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PQMallWaterFallLayout;

@protocol PQMallWaterFallLayoutDelegate <NSObject>

@required;

- (CGFloat)itemHeightForIndexPath:(NSIndexPath *)indexPath;

@end

@interface PQMallWaterFallLayout : UICollectionViewLayout

/**
 delegate
 */
@property (nonatomic, weak) id <PQMallWaterFallLayoutDelegate> delegate;

/**
 变成两行的 section 
 */
@property (nonatomic, assign) NSInteger sectionOfTwoLine;

/**
 两行的 inset
 */
@property (nonatomic, assign) UIEdgeInsets insetOfTwoLine;

@end
