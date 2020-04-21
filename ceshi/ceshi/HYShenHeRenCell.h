//
//  HYShenHeRenCell.h
//  HY
//
//  Created by AZJ on 2020/4/15.
//  Copyright © 2020 A. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYShenHeRenCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, strong)     NSMutableArray *tmpArr;
@property (nonatomic, strong)     NSArray *dataArray;

//+ (instancetype)shenHeRenCell:(UICollectionView *)collectionView
//                         data:(NSArray*)data
//                       indexP:(NSIndexPath *)indexP;
@end

NS_ASSUME_NONNULL_END
