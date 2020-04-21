//
//  HYShenHeRenCell.m
//  HY
//
//  Created by AZJ on 2020/4/15.
//  Copyright © 2020 A. All rights reserved.
//

#import "HYShenHeRenCell.h"

@implementation HYShenHeRenCell
#pragma mark - 懒加载
- (NSMutableArray *)tmpArr {
    if (!_tmpArr) {
        _tmpArr = [NSMutableArray array];
    }
    return _tmpArr;
}
//+ (instancetype)shenHeRenCell:(UICollectionView *)collectionView
//                    data:(NSArray*)data
//                  indexP:(NSIndexPath *)indexP{
//    HYShenHeRenCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"HYShenHeRenCell" forIndexPath:indexP];
//    cell.dataArray = data;
//    //    按顺序遍历数组
//    [cell.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSDictionary * d = obj;
//        if ([[d objectForKey:@"row"]integerValue] - 1 == indexP.row && [[d objectForKey:@"column"]integerValue] - 1 == indexP.section) {
//            [cell.name setTitle:d[@"approverName"] ? d[@"approverName"] : @"" forState:UIControlStateNormal];
//        }
//    }];
//
//    
//    return cell;
//}

@end
