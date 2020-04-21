//
//  HYCollectionHeaderView.m
//  ceshi
//
//  Created by AZJ on 2020/4/18.
//  Copyright © 2020 A. All rights reserved.
//

#import "HYCollectionHeaderView.h"

@implementation HYCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 5; i++) {
            if (i != 2) {
                [self.layer addSublayer:[self qiDian:CGPointMake(0, 20) zhongDian:CGPointMake(self.frame.size.width, i * 40 + 20)]];                
            }
        }
    }
    return self;
}


- (CAShapeLayer *)qiDian:(CGPoint)qiDian zhongDian:(CGPoint)zhongDian{
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:qiDian];
    // 其他点
    [linePath addLineToPoint:zhongDian];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor blackColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    return lineLayer;
    
}
@end
