//
//  FlowSheetManager.m
//  ceshi
//
//  Created by zipeng an  on 2020/4/21.
//  Copyright © 2020 A. All rights reserved.
//

#import "FlowSheetManager.h"
@interface FlowSheetManager()
@property (nonatomic,strong) NSMutableArray * childs;
@end
@implementation FlowSheetManager

/// 存储子节点及本身节点的数组
- (NSMutableArray *)childs{
    if (!_childs) {
        _childs = @[].mutableCopy;
    }
    return _childs;
}

/// 添加下一节点
/// @param appendItem 要添加的节点信息
/// @param data 数据源
/// @param item 点击节点
- (void)appendNextChild:(Item *)appendItem data:(NSMutableArray <Item*>*)data tapItem:(Item *)item{
    BOOL hasChild = [self hasChild:item data:data];
    if (hasChild) {
        NSInteger maxRowCurrent = [self maxRowWithItem:item data:data isCurrent:YES];
        if (maxRowCurrent == 1) {
            NSInteger maxRow = [self maxRow:data];
    
                appendItem.column = item.column+1;
                appendItem.row = (int)maxRow+1;
                [data addObject:appendItem];
            
        } else {
             NSInteger maxrow =  [self maxRowWithItem:item data:data isCurrent:NO];
             // 移动行数大于或等于maxRow的数据
             NSMutableArray <Item *>* tempA = [self itemsWithRowsEqualOrGrateThanRow:maxrow+1 data:data];
             [data removeObjectsInArray:tempA];
              for(int i = 0 ;i<tempA.count;i++){
                tempA[i].row ++;
              }
              [data addObjectsFromArray:tempA];
              //计算下一列的个数
              appendItem.column = item.column+1;
              appendItem.row = (int)maxrow+1;
              [data addObject:appendItem];
            }
        }else{
              appendItem.row = item.row;
              appendItem.column = item.column+1;
              [data addObject:appendItem];
        }
       
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowSheetReloadView:)]) {
        [self.delegate flowSheetReloadView:data];
    }
}
/// 添加上一节点
/// @param appendItem 要添加的节点信息
/// @param data 数据源
/// @param item 点击节点
- (void)appendLastChild:(Item *)appendItem data:(NSMutableArray <Item*>*)data tapItem:(Item *)item{
    [self.childs removeAllObjects];

    [self subItemsWithItem:item data:data];
    [data removeObjectsInArray:self.childs];
    [data removeObject:item];
    appendItem.row = item.row;
    appendItem.column = item.column;
    appendItem.parentId = item.parentId;
       item.parentId = appendItem.id;
       [data addObject:appendItem];
       [data addObject:item];
 
    for (Item * items in self.childs) {
        items.column++;
        [data addObject:items];
    }
   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowSheetReloadView:)]) {
        [self.delegate flowSheetReloadView:data];
    }
}
/// 删除节点
/// @param item 点击节点
/// @param data 数据源
- (void)deleteChild:(Item *)item data:(NSMutableArray <Item*>*)data{
    if(![self hasChild:item data:data] &&(![self isSameRowWithParentes:item data:data]||([self isSameRowWithParentes:item data:data]&&[self hasBrotherItemRowGreaterThanSelf:item data:data]))){
        
        NSMutableArray <Item *>* tempA = [self itemsWithRowsEqualOrGrateThanRow:item.row+1 data:data];
        [data removeObjectsInArray:tempA];
        for (Item * i in tempA) {
            i.row--;
            [data addObject:i];
        }
    }
    [self.childs removeAllObjects];
    [self subItemsWithItem:item data:data];
    [data removeObjectsInArray:self.childs];
    [data removeObject:item];
    
    for (Item * items in self.childs) {
           items.column--;
        if (![items.id isEqualToString:item.id]) {
            [data addObject:items];
        }
    }
    NSArray * temp = [self childsWithItem:item data:data];
    [data removeObjectsInArray:temp];
    for (Item * items in temp) {
        items.parentId = item.parentId;
        [data addObject:items];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowSheetReloadView:)]) {
        [self.delegate flowSheetReloadView:data];
    }
    
}

/// 子节点和父节点是否在一行
/// @param item 当点节点
/// @param data 数据源
- (BOOL) isSameRowWithParentes:(Item *)item data:(NSArray <Item *>*)data{
       return  [self parentItem:item data:data].row == item.row;
}

/// 获取当前节点的兄弟节点
/// @param item 当前节点
/// @param data 数据源
- (NSArray<Item *>*) brotherItems:(Item *)item data:(NSArray <Item *>*)data{
    NSMutableArray * temp = @[].mutableCopy;
    Item * parentsItem = [self parentItem:item data:data];
    for (Item * item in data) {
        if ([item.parentId isEqualToString:parentsItem.id]  ) {
            [temp addObject:item];
        }
    }
    return temp;
}

/// 兄弟节点是否有比自己高的行数
/// @param item 当前节点
/// @param data 数据源
- (BOOL) hasBrotherItemRowGreaterThanSelf:(Item *)item data:(NSArray<Item *>*)data{
    NSArray * brothers = [self brotherItems:item data:data];
    for (Item * items in brothers) {
        if(items.row>item.row){
             return YES;
        }
    }
    return NO;
}

/// *****核心代码***** 获取当前节点下的所有子节点
/// @param item 当前节点
/// @param data 数据源
- (void) subItemsWithItem:(Item *)item data:(NSArray <Item *>*) data{
        
        for (int i = 0;i< data.count ; i++) {
            if ([self hasChild:item data:data]) {
                for (Item * ii in [self childsWithItem:item data:data]) {
                     [self subItemsWithItem:ii data:data];
                    if (![self.childs containsObject:ii]) {
                        [self.childs addObject:ii];
                    }
                }
            }
            if (![self.childs containsObject:item]) {
                    [self.childs addObject:item];
            }
            
        }
}

/// 获取当前节点的父节点
/// @param item 当前节点
/// @param data 数据源
- (Item *) parentItem:(Item *)item data:(NSArray <Item *>*)data{
    for (Item *i in data) {
        if([item.parentId isEqualToString:i.id]){
            return i;
        }
    }
    return nil;
}

/// 所有数据源中的最大列
/// @param data 数据源
- (NSInteger) maxCol:(NSArray *)data {
    NSInteger i = 0;
    for (Item * item in data) {
        if (item.column > i) {
           i = item.column;
        }
    }
    return i;
}

/// 所有数据源中的最大行
/// @param data 数据源
- (NSInteger) maxRow:(NSArray *)data {
    NSInteger i = 0;
    for (Item * obj in data) {
        if (obj.row > i) {
           i = obj.row;
        }
    }
    return i;
}

/// 获取比某行大的所有数据节点
/// @param row 所选节点行
/// @param data 数据源
- (NSMutableArray *) itemsWithRowsEqualOrGrateThanRow:(NSInteger) row data:(NSArray<Item *>*)data{
    NSMutableArray * tempA = @[].mutableCopy;
    for (Item * item in data) {
        if (item.row >= row) {
            [tempA addObject:item];
        }
    }
    return tempA;
}

/// 获取当前节点的所有列节点
/// @param item 点前节点
/// @param data 数据源
- (NSMutableArray *) itemsWithCol:(Item *)item data:(NSArray <Item *>*)data{
    NSMutableArray * tempA = @[].mutableCopy;
    for (Item * items in data) {
        if (items.column == item.column+1) {
            [tempA addObject:item];
        }
    }
    return tempA;
}

/// 判断当前节点所在列&&当前节点下一级所在列的最大行
/// @param item 当前节点
/// @param data 数据源
/// @param isCurrent 查找的是当前节点还是下一级节点  YES 当前节点所在列  NO 下一级节点所在列 
- (NSInteger) maxRowWithItem:(Item *)item data:(NSArray <Item *>*)data isCurrent:(BOOL) isCurrent{
    NSInteger maxRow = 0;
    for (Item * childItem in data) {
        if (isCurrent) {
            if (childItem.column == item.column) {
                if(childItem.row > maxRow){
                    maxRow = childItem.row;
                }
            }
        }else{
            if ([childItem.parentId isEqualToString:item.id]) {
                if(childItem.row > maxRow){
                    maxRow = childItem.row;
                }
            }
        }
       
    }
    return maxRow;
}

/// 是否有子节点
/// @param item 当前节点
/// @param data 数据源
- (BOOL) hasChild:(Item *)item data:(NSArray<Item *> *)data{
    BOOL r = NO;
    
    for (Item * obj in data) {
        if([obj.parentId isEqualToString:item.id]){
            
            return YES;
        }}
    return r;
}

/// 当前节点的子节点
/// @param item 当前节点
/// @param data 数据源
- (NSArray <Item *>*) childsWithItem:(Item *)item data:(NSArray <Item *>*)data{
    NSMutableArray * temp = @[].mutableCopy;
    for (Item * i in data) {
        if ([i.parentId isEqualToString:item.id]) {
            [temp addObject:i];
        }
    }
    return temp;
}

/// CALAyer工具类
/// @param startPoint 起点
/// @param endPoint 终点
- (CAShapeLayer *)startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:startPoint];
    // 其他点
    [linePath addLineToPoint:endPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    return lineLayer;
}

@end
