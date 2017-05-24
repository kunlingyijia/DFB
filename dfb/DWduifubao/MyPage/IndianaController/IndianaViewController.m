//
//  IndianaViewController.m
//  DWduifubao
//
//  Created by kkk on 16/9/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "IndianaViewController.h"
#import "IndianaHeaderView.h"
#import "IndianaCell.h"
#import "ShopClassKindController.h"
@interface IndianaViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,IndianaHeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation IndianaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑富夺宝";
    [self showBackBtn];
    [self createView];
}

- (void)createView {
    //创建布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置cell的尺寸
    flowLayout.itemSize = CGSizeMake(Width/2-1, Width/2-1+40);
    //设置边缘
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 1;
    //设置区头尺寸
    flowLayout.headerReferenceSize = CGSizeMake(Width, 88 + (2*Width/5)+Width/4);
    //创建集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:kLineColor];
    [self.collectionView registerClass:[IndianaCell class] forCellWithReuseIdentifier:@"IndianaCell"];
    
    [self.collectionView registerClass:[IndianaHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - IndianaHeaderViewDelegate
- (void)selectedClassKindWithIndex:(NSInteger)index {
    if (index==0) {
        ShopClassKindController *shopClassKind = [[ShopClassKindController alloc] init];
        [self.navigationController pushViewController:shopClassKind animated:YES];
    }
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndianaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndianaCell" forIndexPath:indexPath];
    

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    IndianaHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
    view.delegate = self;
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
