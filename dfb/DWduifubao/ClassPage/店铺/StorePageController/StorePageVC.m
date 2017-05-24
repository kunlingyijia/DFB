//
//  StorePageVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "StorePageVC.h"
#import "IQKeyboardManager.h"
#import "SearchHistoryView.h"
#import "collectionOneCell.h"
#import "collectionTwoCell.h"
#import "GoodsMain1ViewController.h"
#import "MyShopViewController.h"
#import "MeNuTableView.h"
#import "GoodsModel.h"
#import "StorePageHeaderView.h"
#import "MyShopModel.h"
#import "LoginController.h"
@interface StorePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MeNuTableViewDelegate>
@property(nonatomic,strong)SearchHistoryView *SHView11;
@property(nonatomic,strong) StorePageHeaderView *header;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)MyShopModel *myShopModel;
//按销量排序（可选）1-升序 2-降序
@property(nonatomic,strong)NSString * order_sales_num;
//按价格排序（可选）1-升序 2-降序
@property(nonatomic,strong)NSString *order_price;

///分页参数
@property(nonatomic,assign) int pageIndex;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation StorePageVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh_StorePageVC:) name:@"refresh_StorePageVC" object:nil];
    [self SET_UI];
    
    [self  SET_DATA];
    
}
-(void)SET_UI{
    [self showBackBtn];
    self.collectionView.backgroundColor =[UIColor colorWithHexString:kViewBackgroundColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionOneCell" bundle:nil] forCellWithReuseIdentifier:@"collectionOneCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"collectionTwoCell" bundle:nil] forCellWithReuseIdentifier:@"collectionTwoCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StorePageHeaderView"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"StorePageFooterView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.SHView11 = [NIBHelper instanceFromNib:@"SearchHistoryView"];
    [_SHView11.CancelBtn setTitleColor:[UIColor clearColor] forState:(UIControlStateNormal)];
    UIButton * ChangeLaoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    ChangeLaoutBtn.frame  = _SHView11.CancelBtn.bounds;
    ChangeLaoutBtn.backgroundColor = [UIColor whiteColor];
    [ChangeLaoutBtn setImage:[UIImage imageNamed:@"分类"] forState:(UIControlStateNormal)];
    [ChangeLaoutBtn addTarget:self action:@selector(ChangeLaout1:) forControlEvents:(UIControlEventTouchUpInside)];
    [_SHView11.CancelBtn addSubview:ChangeLaoutBtn];
    __weak typeof(self) weakSelf = self;
    [_SHView11 CancelAction:^(NSString *SearchStr) {
        
        
    }];
    [_SHView11 searchAction:^(NSString *SearchStr) {
        
    }];
    [_SHView11 backAction:^() {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [_SHView11 SearchTFReturn:^(NSString *SearchStr) {
        NSLog(@"%@",SearchStr);
        weakSelf.pageIndex = 1;
        weakSelf.order_price = @"";
        weakSelf.order_sales_num= @"";
        weakSelf.keywords = SearchStr;
       [weakSelf requestAction];
        
        
    }];
    
    _SHView11.frame= CGRectMake(0, 0, self.view.frame.size.width, 0);
    [self.view addSubview:_SHView11];
    
   
    
}
- (void)ChangeLaout1:(UIButton *)sender {
    if (self.collocationCellLayout ==oneCellLayout) {
        self.collocationCellLayout =twoCellLayout;
        [self.collectionView reloadData];
    }else{
        
        self.collocationCellLayout =oneCellLayout;
        [self.collectionView reloadData];
    }
    
}
-(void)SET_DATA{
    self.collocationCellLayout =oneCellLayout;
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.myShopModel = [[MyShopModel alloc]init];
    //上拉刷新下拉加载
    [self Refresh];
    //网络请求
    [self requestAction];
    //请求店铺信息
    [self requestSorePageAction];
    
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

-(void)refresh_StorePageVC:(NSNotification*)sender{
    //网络请求
    [self requestAction];
    //请求店铺信息
    [self requestSorePageAction];

    
    
}
#pragma mark - 网络请求
-(void)requestAction{
    GoodsModel *model = [[GoodsModel alloc]init];
    model.keywords =self.keywords;
    model.merchant_id= self.merchant_id;
    model.order_price = self.order_price;
    model.order_sales_num = self.order_sales_num;
    NSLog(@"%@",model.category_id);
    model.pageIndex =[NSString stringWithFormat:@"%d",self.pageIndex];
    model.pageCount = @"10";
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestGoodsList" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
         NSLog(@"商品类别----%@",response);
        if (baseRes.resultCode == 1) {
            if (_pageIndex==1) {
                [self.dataArray removeAllObjects];
            }
            NSMutableArray *arr =response[@"data"];
            for (NSDictionary *dic in arr ) {
                GoodsModel *model = [GoodsModel  yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
        [weakself.collectionView reloadData];
        }

    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark - 请求店铺信息
-(void)requestSorePageAction{
    GoodsModel *model = [[GoodsModel alloc]init];
    model.merchant_id= self.merchant_id;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    NSString * token = [AuthenticationModel getLoginToken];
    baseReq.token =token;
    baseReq.data = model;
     __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestMerchantInfo" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC: self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"获取店铺信息----%@",response);
        if (baseRes.resultCode == 1) {
            self.myShopModel = [MyShopModel yy_modelWithJSON: response[@"data"]];
//            //控件赋值
//            [self KongJianFuZhi];
           NSLog(@"self.myShopModel.%@",self.myShopModel.is_collect
                 );
            [weakself.collectionView reloadData];
        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    
}
#pragma mark - 控件赋值
-(void)KongJianFuZhi{
    
    
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
        case oneCellLayout:{
            
            collectionOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionOneCell" forIndexPath:indexPath];
            [cell cellGetData:(GoodsModel*)self.dataArray[indexPath.row]];
            return cell;
        }
            break;
        case twoCellLayout:{
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
    GoodsModel *goosModel =self.dataArray[indexPath.row];
    GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
    VC.goods_id = goosModel.goods_id;
    [self.navigationController  pushViewController:VC animated:YES];
    
    
    
    
}
#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.collocationCellLayout) {
        case oneCellLayout:{
            return CGSizeMake(([UIScreen mainScreen].bounds.size.width-9)/2, ([UIScreen mainScreen].bounds.size.width-9)/2+100);
        }
            break;
        case twoCellLayout:{
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
        case oneCellLayout:{
            return UIEdgeInsetsMake(3, 3, 3, 3);
        }
            break;
        case twoCellLayout:{
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
        case oneCellLayout:{
            return 3 ;
            
        }
            break;
        case twoCellLayout:{
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
        case oneCellLayout:{
            return 3;
        }
            break;
        case twoCellLayout:{
            return 0;
        }
            break;
        default:
            break;
    }
    
}
//灵活的设置每个分区的页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.525*Width);
}
//灵活的设置每个分区的页脚的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake( [UIScreen mainScreen].bounds.size.width ,0.01);
}
//#pragma mark - 跳转到商户详情
//- (IBAction)PushMyShopVCAction:(UIButton *)sender {
//    //Push 跳转
//    MyShopViewController * VC = [[MyShopViewController alloc]initWithNibName:@"MyShopViewController" bundle:nil];
//    
//    [self.navigationController  pushViewController:VC animated:YES];
//    
//    
//}

#pragma mark -设置页眉和页脚

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StorePageHeaderView" forIndexPath:indexPath];
        
        
        if (!_header) {
            self.header    = [NIBHelper instanceFromNib:@"StorePageHeaderView"];
            [headerView addSubview:_header];
            MeNuTableView * meNuTableView = [[MeNuTableView alloc]initWithFrame:CGRectMake(0, 0.4*Width, Width, 0.125*Width) dataArray:[@[]mutableCopy]];
            meNuTableView.Menudelegate = self;
            //meNuTableView.dataArray = arr;
            meNuTableView.backgroundColor = [UIColor redColor];
            [headerView addSubview:meNuTableView];
            
        }else{
       [_header cellGetData:self.myShopModel];
       [_header.GuanZhuBtn addTarget:self action:@selector(GuanZhuBtn:) forControlEvents:(UIControlEventTouchUpInside)];
       [_header.merchantBtn addTarget:self action:@selector(merchantBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

        }
        ;
        
        reusableview = headerView;
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"StorePageFooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
        
    }
    
    return reusableview;
    
    
}
#pragma mark - 关注店铺点击事件
-(void)GuanZhuBtn:(UIButton*)sender{
    NSString *Token =[AuthenticationModel getLoginToken];
    MyShopModel *model = [[MyShopModel alloc]init];
    model.merchant_id = self.myShopModel.merchant_id;
    if ([self.myShopModel.is_collect isEqualToString:@"1"]) {
        model.is_collect = @"0";
        
    }else if ([self.myShopModel.is_collect isEqualToString:@"0"]) {
         model.is_collect = @"1";
        
    }else{
      
        
    }
    NSLog(@"--%d",model.merchant_id);
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestCollectMerchant" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"关注%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                if ([weakSelf.myShopModel.is_collect isEqualToString:@"1"]) {
                     [weakSelf showToast:@"取消关注"];
                    
                }else if ([weakSelf.myShopModel.is_collect isEqualToString:@"0"]) {
                    [weakSelf showToast:@"关注成功"];
                    
                }
                [weakSelf requestSorePageAction];
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
         [self pushLoginController];
    }
    

    
    
}
#pragma mark - 跳转到店铺详情
-(void)merchantBtnAction:(PublicBtn*)sender{
    
    //Push 跳转
    MyShopViewController * VC = [[MyShopViewController alloc]initWithNibName:@"MyShopViewController" bundle:nil];
    VC.merchant_id = [self.merchant_id intValue];
    [self.navigationController  pushViewController:VC animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    
    [VC LoginRefreshAction:^{
        
        //网络请求
        [weakSelf requestAction];
        //请求店铺信息
        [weakSelf requestSorePageAction];
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
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
