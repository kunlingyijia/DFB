//
//  GoodsListViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "GoodsListViewController.h"
#import "collectionOneCell.h"
#import "collectionTwoCell.h"
#import "SearchHistoryView.h"
#import "SearchHistoryViewController.h"
#import "GoodsMain1ViewController.h"
#import "MeNuTableView.h"
#import "GoodsModel.h"

@interface GoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MeNuTableViewDelegate>
@property(nonatomic,strong)SearchHistoryView *SHView11;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///菜单底图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//按销量排序（可选）1-升序 2-降序
@property(nonatomic,strong)NSString * order_sales_num;
//按价格排序（可选）1-升序 2-降序
@property(nonatomic,strong)NSString *order_price;

///分页参数
@property(nonatomic,assign) int pageIndex;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation GoodsListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SET_UI];
    
    [self SET_Notification];
    [self  SET_DATA];
    NSLog(@"关键字---%@",self.category_id);
   
}

-(void)SET_UI{
     //self.collectionView.backgroundColor =[UIColor colorWithHexString:kViewBackgroundColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionOneCell" bundle:nil] forCellWithReuseIdentifier:@"collectionOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionTwoCell" bundle:nil] forCellWithReuseIdentifier:@"collectionTwoCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.SHView11 = [NIBHelper instanceFromNib:@"SearchHistoryView"];
    [_SHView11.CancelBtn setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
    UIButton * searchBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    searchBtn.frame = CGRectMake(40, 0, Width-85, 64);
    //searchBtn.backgroundColor = [UIColor redColor];
    [searchBtn addTarget:self action:@selector(searchBtnAction1:) forControlEvents:(UIControlEventTouchUpInside)];
    [_SHView11 addSubview:searchBtn];
    
    UIButton * ChangeLaoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(40, 0, Width-85, 64);
    ChangeLaoutBtn.frame  = CGRectMake(CGRectGetMaxX(searchBtn.frame), _SHView11.bottomView.frame.origin.y, 40, 40) ;
   // ChangeLaoutBtn.backgroundColor = [UIColor yellowColor];
    [ChangeLaoutBtn setImage:[UIImage imageNamed:@"分类"] forState:(UIControlStateNormal)];
    [ChangeLaoutBtn addTarget:self action:@selector(ChangeLaout1:) forControlEvents:(UIControlEventTouchUpInside)];
    [_SHView11 addSubview:ChangeLaoutBtn];
    __weak typeof(self) weakSelf = self;
    [_SHView11 CancelAction:^(NSString *SearchStr) {
        
    }];
    [_SHView11 searchAction:^(NSString *SearchStr) {
        
    }];
    [_SHView11 backAction:^() {
    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
    [_SHView11 SearchTFReturn:^(NSString *SearchStr) {
        NSLog(@"%@",SearchStr);
        
    }];
    
    _SHView11.frame= CGRectMake(0, 0, self.view.frame.size.width, 0);
    [self.view addSubview:_SHView11];
    
   
    MeNuTableView * meNuTableView = [[MeNuTableView alloc]initWithFrame:CGRectMake(0, 0, Width, Width*0.125)dataArray:[@[]mutableCopy]];
    meNuTableView.Menudelegate = self;    
    [self.bottomView addSubview:meNuTableView];
    
    
}
- (void)ChangeLaout1:(UIButton *)sender {
    if (self.collocationCellLayout ==oneCellLayoutList) {
        self.collocationCellLayout =twoCellLayoutList;
        [self.collectionView reloadData];
    }else{
        
        self.collocationCellLayout =oneCellLayoutList;
        [self.collectionView reloadData];
    }

}

-(void)searchBtnAction1:(UIButton*)sender{
    //Push 跳转
    SearchHistoryViewController * VC = [[SearchHistoryViewController alloc]initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:NO];

    
    
}
-(void)SET_Notification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Goods_BackTo_List:) name:@"Goods_BackTo_List" object:nil];
    
    
}
-(void)Goods_BackTo_List:(NSNotification*)sender{
     [self.navigationController setNavigationBarHidden:YES animated:sender.userInfo[@"Goods_BackTo_List"]];
    
}
-(void)SET_DATA{
    self.collocationCellLayout =oneCellLayoutList;
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    //上拉刷新下拉加载
    [self Refresh];
    //网络请求
    [self requestAction];
    
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.collectionView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - MeNuTableView-菜单代理方法


///从左到右
-(void)oneBtnAction{
    self.pageIndex = 1;
    self.order_price = @"";
    self.order_sales_num= @"";
    
    [self requestAction];
    
}
-(void)twoBtnAction{
    self.pageIndex = 1;
    self.order_sales_num= @"2";
    self.order_price = @"";
    [self requestAction];
    
    
}
///点击BtnTwo 箭头向下箭头遵从代理
-(void)threeBtnActionDown{
    self.pageIndex = 1;
    self.order_sales_num= @"";
    self.order_price = @"2";
    [self requestAction];
    
    
    
}
///点击BtnTwo 箭头向上箭头遵从代理
-(void)threeBtnActionUp{
    self.pageIndex = 1;
    self.order_sales_num= @"";
    self.order_price = @"1";
    [self requestAction];
    
    
    
}
#pragma mark - 网络请求
-(void)requestAction{
    GoodsModel *model = [[GoodsModel alloc]init];
    model.keywords =self.keywords;
    model.category_id= self.category_id;
    ///按金币(可选) 1 -推荐 0 -否
    model.gold_fit= self.gold_fit;
    model.merchant_id = self.merchant_id;
    model.order_sales_num = self.order_sales_num;
    model.order_price = self.order_price;
    model.pageIndex =[NSString stringWithFormat:@"%d",self.pageIndex];
    model.pageCount = @"10";
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    NSString * token= [AuthenticationModel getLoginToken];
    baseReq.token = token;
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestGoodsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"商品类别----%@",response);
        if (baseRes.resultCode == 1) {
            NSMutableArray *arr =response[@"data"];
            if (_pageIndex ==1) {
                [self.dataArray removeAllObjects];

            }
            for (NSDictionary *dic in arr ) {
                GoodsModel *model = [GoodsModel  yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            
        }
        [weakself.collectionView reloadData];
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];

    
}
#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView collectionViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //配置item
    switch (self.collocationCellLayout) {
        case oneCellLayoutList:{
            
            collectionOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionOneCell" forIndexPath:indexPath];
            [cell cellGetData:(GoodsModel*)self.dataArray[indexPath.row]];
            return cell;
        }
            break;
        case twoCellLayoutList:{
            collectionTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionTwoCell" forIndexPath:indexPath];
             [cell cellGetData:(GoodsModel*)self.dataArray[indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
    VC.goods_id = ((GoodsModel*)self.dataArray[indexPath.row]).goods_id;
    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.collocationCellLayout) {
        case oneCellLayoutList:{
            return CGSizeMake(([UIScreen mainScreen].bounds.size.width-9)/2,([UIScreen mainScreen].bounds.size.width-9)/2+100);
        }
            break;
        case twoCellLayoutList:{
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
        }
            break;
        default:
            break;
    }
    
    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    switch (self.collocationCellLayout) {
        case oneCellLayoutList:{
            return UIEdgeInsetsMake(3, 3, 3, 3);
        }
            break;
        case twoCellLayoutList:{
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
        default:
            break;
    }
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    switch (self.collocationCellLayout) {
        case oneCellLayoutList:{
            return 3 ;
            
        }
            break;
        case twoCellLayoutList:{
            return 0 ;
            
        }
            break;
        default:
            break;
    }
    
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    switch (self.collocationCellLayout) {
        case oneCellLayoutList:{
            return 3;
        }
            break;
        case twoCellLayoutList:{
            return 0;
        }
            break;
        default:
            break;
    }
    
}
//灵活的设置每个分区的页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
}
//灵活的设置每个分区的页脚的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake( [UIScreen mainScreen].bounds.size.width ,0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
