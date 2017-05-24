//
//  SelectHomeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "SelectHomeCell.h"
#import "SelectSubCell.h"
#import "GoodsModel.h"
@interface SelectHomeCell ()
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation SelectHomeCell
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
        
    }
    return self;
}
-(void)addSubViews{
    self.count = 0;
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //配置布局对象的属性
        //设置cell的大小 ------ item
        flowLayout.itemSize = CGSizeMake((Width-15)/4, Width*1.5/5);
        // CGFloat xx = ([UIScreen mainScreen].bounds.size.width-240)/5;
        //NSLog(@"%f",xx);
        //设置分区的边界
        flowLayout.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        //设置行间距
        flowLayout.minimumLineSpacing = 5;
        //设置两个item之间的距离
        flowLayout.minimumInteritemSpacing =5;
        //设置滚动的方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, Width*1.5/5) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //_collectionView.pagingEnabled = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        //注册
        
        [self.collectionView collectionViewregisterNibArray:@[@"SelectSubCell"]];
        [self.contentView addSubview: _collectionView];
    }
    
    
    
}

#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectSubCell" forIndexPath:indexPath];
    GoodsModel * model    = self.dataArray[indexPath.row];
    [DWHelper SD_WebImage:cell.goods_logo imageUrlStr:model.goods_logo placeholderImage:nil];
    cell.price.text = [NSString stringWithFormat:@"兑%@",model.price];
    //配置item
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.SelectHomeCellBlock(indexPath.row);
}



-(void)CellGetData:(NSMutableArray*)Arr{
    self.count = Arr.count;
    self.dataArray = Arr;
    [self.collectionView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
