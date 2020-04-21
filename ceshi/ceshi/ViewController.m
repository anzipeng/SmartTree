//
//  ViewController.m
//  ceshi
//
//  Created by AZJ on 2020/4/18.
//  Copyright © 2020 A. All rights reserved.
//

#import "ViewController.h"
#import "HYShenHeRenCell.h"
#import "UIBezierPath+WNPoints.h"
#import "HYCollectionHeaderView.h"
#import "Item.h"
#import "UIBezierPath+WNPoints.h"
#import <MJExtension/MJExtension.h>
#import "FlowSheetManager.h"
static NSString *collettionSectionHeader = @"HYCollectionHeaderView";
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FlowSheetManagerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)     NSMutableArray *dataArray;
@property (nonatomic, strong)     NSMutableArray *muArray;
@property (nonatomic,strong) Item * currentItem;
@property (nonatomic,strong) NSMutableArray * layers;
@property (nonatomic,strong) FlowSheetManager *manager;
@end

@implementation ViewController
int idNum = 0;
#pragma mark - 懒加载
- (NSMutableArray *)muArray {
    if (!_muArray) {
        _muArray = [NSMutableArray array];
    }
    return _muArray;
}
- (FlowSheetManager *)manager{
    if (!_manager) {
        _manager = [[FlowSheetManager alloc]init];
        _manager.delegate = (id)self;
    }
    return  _manager;
}
- (NSMutableArray *)layers{
    if(!_layers){
        _layers = @[].mutableCopy;
    }
    return _layers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCollection];
    [self addRoot:self.dataArray];
    [self reloadView];
}
- (void)reloadView{
    [self.collectionView reloadData];
    [self drawLayer];
}
- (void) addRoot:(NSMutableArray *) data{
    if (data.count == 0) {
        self.dataArray = @[].mutableCopy;
        Item * i = [Item new];
        i.parentId = @"c0r0";
        i.column = 1;
        i.row = 1;
        i.id = [NSString stringWithFormat:@"c%dr%d",i.column,i.row];
        i.approverName =  [NSString stringWithFormat:@"c%dr%d",i.column,i.row];
        [self.dataArray addObject:i];
    }
}

- (IBAction)add1:(id)sender {
    
    Item * i = [Item new];
    i.parentId = self.currentItem.id;
    int x = arc4random() % 100000000000000;
    i.id = [NSString stringWithFormat:@"%d",x];
    i.approverName =  [self getRandomName];
    [self.manager appendNextChild:i data:self.dataArray tapItem:self.currentItem];
}

- (IBAction)add2:(id)sender {
     Item * i = [Item new];
     i.parentId = self.currentItem.id;
     int x = arc4random() % 100000000000000;
     i.id = [NSString stringWithFormat:@"%d",x];
     i.approverName =  [self getRandomName];
    [self.manager appendLastChild:i data:self.dataArray tapItem:self.currentItem];
}

- (IBAction)jian:(id)sender {
    [self.manager deleteChild:self.currentItem data:self.dataArray];
}
- (NSString *) getRandomName{
    NSArray *  a  = @[@"王",@"安",@"周",@"赵",@"钱",@"孙"];
    NSArray * b = @[@"古",@"木",@"山",@"和",@"水",@"钟",@"才",@"毛"];
    return  [NSString stringWithFormat:@"%@%@%@",a[arc4random()%a.count],b[arc4random()%b.count],b[arc4random()%b.count]];
}
- (void) drawLayer{
    for (CALayer * layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    [self.layers removeAllObjects];
    for (Item * item in self.dataArray) {
        CGRect rect0 = [self cellRectWithItem:item];
        for (Item * obj in self.dataArray) {
            if([obj.id isEqualToString:item.parentId]){
                CGRect rect1 = [self cellRectWithItem:obj];
                CAShapeLayer * layer =  [self.manager startPoint: CGPointMake((CGRectGetMaxX(rect1)), rect1.origin.y+rect1.size.height/2) endPoint:CGPointMake(CGRectGetMinX(rect0), CGRectGetMinY(rect0)+rect0.size.height/2)];
                [self.layers addObject:layer];
            }
        }
    }
    for (CALayer * layer in self.layers) {
        [self.collectionView.layer addSublayer:layer];
    }
}
- (CGRect) cellRectWithItem:(Item *)item{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item.row-1 inSection:item.column-1];
    HYShenHeRenCell *cell =[self.collectionView dequeueReusableCellWithReuseIdentifier:@"HYShenHeRenCell" forIndexPath:indexPath];

    return cell.frame;
}
#pragma mark -- FlowSheetManagerDelegate
- (void)flowSheetReloadView:(NSArray<Item *> *)data{
    [self.collectionView reloadData];
    [self drawLayer];
}

- (void)setCollection{
    //    注册cell
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(70, 40);
    [self.collectionView setCollectionViewLayout:layout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HYShenHeRenCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HYShenHeRenCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collettionSectionHeader];

}
#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return [self.manager maxCol:self.dataArray];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.manager maxRow:self.dataArray];
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 40);
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(section == 0 ? 0 : 60, 40);
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYShenHeRenCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"HYShenHeRenCell" forIndexPath:indexPath];
    cell.name.text = @"";
    //    按顺序遍历数组
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item * i  = obj;
        if ( i.row - 1 == indexPath.row && i.column - 1 == indexPath.section) {
            [cell.name setText:[NSString stringWithFormat:@"%@",i.approverName]];
           
        }
        if (cell.name.text.length == 0) {
                cell.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor blackColor];
       }else{
                cell.userInteractionEnabled = YES;
                cell.backgroundColor = [UIColor whiteColor];
        }
    }];
    
    
    return cell;
}
//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collettionSectionHeader forIndexPath:indexPath];
        HYCollectionHeaderView *header = [[HYCollectionHeaderView alloc] initWithFrame:view.bounds];
        
        [view addSubview:header];
        return view;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"" forIndexPath:indexPath];
        return view;
    }else{
        return nil;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item * i = obj;
        if (i.row - 1 == indexPath.row &&  i.column - 1 == indexPath.section) {
            self.currentItem = i;
            NSLog(@"当前点击 -- %@",self.currentItem.approverName);
        }
    }];
}





@end
