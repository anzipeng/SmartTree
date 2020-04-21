//
//  FlowSheetManager.h
//  ceshi
//
//  Created by zipeng an  on 2020/4/21.
//  Copyright © 2020 A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol FlowSheetManagerDelegate <NSObject>

- (void) flowSheetReloadView:(NSArray <Item *>*)data;

@end
@interface FlowSheetManager : NSObject
@property (nonatomic,weak) id<FlowSheetManagerDelegate> delegate;

/// 划线
/// @param startPoint 起点
/// @param endPoint 终点
- (CAShapeLayer *)startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/// 添加下一节点
/// @param appendItem 要添加的节点信息
/// @param data 数据源
/// @param item 点击节点
- (void)appendNextChild:(Item *)appendItem data:(NSMutableArray <Item*>*)data tapItem:(Item *)item;

/// 添加上一节点
/// @param appendItem 要添加的节点信息
/// @param data 数据源
/// @param item 点击节点
- (void)appendLastChild:(Item *)appendItem data:(NSMutableArray <Item*>*)data tapItem:(Item *)item;

/// 删除节点
/// @param item 点击节点
/// @param data 数据源
- (void)deleteChild:(Item *)item data:(NSMutableArray <Item*>*)data;

/// 所有数据中的最大行
/// @param data 数据源
- (NSInteger) maxRow:(NSArray *)data;

/// 所有数据中的最大列
/// @param data 数据源
- (NSInteger) maxCol:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END
