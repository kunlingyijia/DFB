//
//  HomePageVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageHeader.h"
#import "HomeOneCell.h"
#import "HomeTwoCell.h"
#import "HomeThreeCell.h"
#import "HomeFourCell.h"
#import "SelectHomeCell.h"
#import "HotHomeCell.h"
#import "SDCycleScrollView.h"
#import "PublicViewController.h"
#import "NavigationView.h"
#import "AdModel.h"
#import "MessageViewController.h"
#import "LoginController.h"
#import "EWMViewController.h"
#import "MyShopModel.h"
#import "O2OViewController.h"
#import "MyPropertyViewController.h"
#import "MyShopViewController.h"
#import "VerisonModel.h"
#import "VersionUpViewController.h"
#import "LunBoImageViewController.h"
#import "DFBWebViewVC.h"
#import "O2OMainViewController.h"
#import "AuditViewController.h"
#import "UPNembersViewController.h"
#import "FailureViewController.h"
#import "AppDelegate.h"
#import "HomeModel.h"
#import "AdModel.h"
#import "HVModel.h"
#import "IndianaHomeVC.h"
//商城
#import "StorePageVC.h"
#import "GoodsMain1ViewController.h"
#import "GoodsModel.h"
#import "SearchHistoryViewController.h"
#import "MyServiceVC.h"
#import "OpenShopVC.h"
#import "GoodsListViewController.h"
#import "MyLoanOrCardVC.h"
#import "UIView+Toast.h"

typedef void(^PushOhter)();
@interface HomePageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NavigationViewdelegate,SDCycleScrollViewDelegate,AMapLocationManagerDelegate>{
    NavigationView *NGView;
}
//网络判断view
@property(nonatomic,strong)UIView * interView;
@property(nonatomic,strong)AMapLocationManager *locationManager;
@property(nonatomic,strong)UIView *daohangView;
@property(nonatomic,strong)    SDCycleScrollView *cycleScrollView;
//轮播图图片网址
@property (nonatomic,strong)NSMutableArray * LunBoImgArr;
//轮播跳转网址
@property (nonatomic,strong)NSMutableArray * LunBoUrlArr;
///分页参数
@property(nonatomic,assign) int pageIndex;
///广告数组
@property (nonatomic,strong)NSMutableArray * AdArr;
@property (nonatomic,strong)NSMutableArray *dataArray;
///热门活动
@property (nonatomic,strong)NSMutableArray * HotArray;
///精选商品
@property (nonatomic,strong)NSMutableArray * merchandiseArray;
///精选店铺
@property (nonatomic,strong)NSMutableArray * recommendArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomePageVC
//视图即将出现时调用
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    NSLog(@"NSHomeDirectory()--%@",NSHomeDirectory());
    

    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}

#pragma mark - 关于UI
-(void)SET_UI{
    //[self showBackBtn];
//    HVModel* VModel = [HVModel new];
//    VModel.HomeVC = self;
//    [VModel updateVerison] ;
//    [VModel AMap];
//    [VModel gestrueViewAndInterView];
    // 添加定位
    // [self AMap];
   // 版本更新
    //[self updateVerison];
    //关于手势
    [self gestrueViewAndInterView];
    [self.collectionView registerClass:[HomePageHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeader"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomePageFooter"];
   //注册cell
    [self.collectionView collectionViewregisterNibArray:@[@"HomeOneCell",@"HomeTwoCell",@"HomeThreeCell",@"HomeFourCell",@"SelectHomeCell",@"HotHomeCell"]];
    //创建
    [self addSubViews];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.LunBoImgArr = [NSMutableArray arrayWithCapacity:1];
    self.LunBoUrlArr = [NSMutableArray arrayWithCapacity:1];
    self.AdArr = [NSMutableArray arrayWithCapacity:1];
   self.HotArray = [NSMutableArray arrayWithCapacity:1];
    self.merchandiseArray = [NSMutableArray arrayWithCapacity:1];
    self.recommendArr = [NSMutableArray arrayWithCapacity:1];
    //上拉刷新下拉加载
    [self Refresh];
    //加载本地
    [self LocalData];
    //=网络请求
    [self requestHomePageAction];

  
}

-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        //加载本地
        [weakself LocalData];
        [weakself requestHomePageAction];
        //进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_header endRefreshing];
   }];
    
    //上拉加载
    self.collectionView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        //轮播图网络请求
        [weakself requestHomePageAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_footer endRefreshing];
    }];
    
}
-(void)LocalData{
        NSMutableDictionary * dataDic = [AuthenticationModel objectForKey:@"HomePageVCData"];
        if (dataDic.count!=0) {
            [self.dataArray removeAllObjects];
            [self.LunBoImgArr removeAllObjects];
            [self.LunBoUrlArr removeAllObjects];[self.AdArr removeAllObjects];
            NSMutableDictionary * ad=dataDic[@"ad"];
            NSMutableArray * ad_Arr = ad[@"ad_data"];
            [self.dataArray addObject:ad[@"name"]];
            for (NSDictionary *dici in ad_Arr) {
                [self.LunBoImgArr addObject:dici[@"image_url"]];
                [self.LunBoUrlArr addObject:dici[@"link_url"]];
            }
    
            NSMutableDictionary * activity=dataDic[@"act"];
            NSMutableArray * activity_Arr =activity[@"act_data"];
            [self.dataArray addObject:activity[@"name"]];
            [self.HotArray removeAllObjects];
            for (NSDictionary *dic in activity_Arr) {
                GoodsModel *model = [GoodsModel  yy_modelWithJSON:dic];
    
                [self.HotArray  addObject:model];
            }
            ///精选商品
            NSMutableDictionary * recommend=dataDic[@"recommend"];
            NSMutableArray * recommend_arr = recommend[@"recommend_data"];
            [self.dataArray addObject:recommend[@"name"]];
            [self.merchandiseArray removeAllObjects];
            for (NSDictionary *dicdata in recommend_arr) {
                GoodsModel *model = [GoodsModel  yy_modelWithJSON:dicdata];
                [self.merchandiseArray addObject:model];
    
            }
    
            ///精选店铺
            if (self.pageIndex == 1) {
                [self.recommendArr removeAllObjects];           }
    
            NSMutableDictionary * merchant=dataDic[@"merchant"];
            NSMutableArray * merchant_arr = merchant[@"merchant_data"];
            [self.dataArray addObject:merchant[@"name"]];
            for (NSDictionary *dic in merchant_arr) {
                MyShopModel *model = [MyShopModel  yy_modelWithJSON:dic];
                [self.recommendArr  addObject:model];
            }
            
            
        }
     [self.collectionView reloadData];
    

    
}
-(void)requestHomePageAction{
    
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    __weak typeof(self) weakself = self;
    
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data =dic;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Homepage sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        NSLog(@"首页---%@",response);
        if ([response[@"resultCode"] isEqualToString:@"1"]) {
            //存储数据
            if (weakself.pageIndex == 1) {
                [AuthenticationModel setValue:response forkey:@"HomePageVCData"];
            }
            [self.dataArray removeAllObjects];
            NSDictionary *dataDic = response[@"data"];
            [self.LunBoImgArr removeAllObjects];
            [self.LunBoUrlArr removeAllObjects];
            [self.AdArr removeAllObjects];
            NSMutableDictionary * ad=dataDic[@"ad"];
            NSMutableArray * ad_Arr = ad[@"ad_data"];
            [self.dataArray addObject:ad[@"name"]];
            for (NSDictionary *dici in ad_Arr) {
                [self.LunBoImgArr addObject:dici[@"image_url"]];
                [self.LunBoUrlArr addObject:dici[@"link_url"]];
            }

            NSMutableDictionary * activity=dataDic[@"act"];
            NSMutableArray * activity_Arr =activity[@"act_data"];
            [self.dataArray addObject:activity[@"name"]];
          [self.HotArray removeAllObjects];
            NSLog(@"self.HotArray---%@",self.HotArray);
            for (NSDictionary *dic in activity_Arr) {
                GoodsModel *model = [GoodsModel  yy_modelWithJSON:dic];
                
                [weakself.HotArray  addObject:model];
            }
            NSLog(@"self.HotArray---%@",self.HotArray);
           ///精选商品
            NSMutableDictionary * recommend=dataDic[@"recommend"];
            NSMutableArray * recommend_arr = recommend[@"recommend_data"];
            [self.dataArray addObject:recommend[@"name"]];
             [weakself.merchandiseArray removeAllObjects];
            for (NSDictionary *dicdata in recommend_arr) {
              GoodsModel *model = [GoodsModel  yy_modelWithJSON:dicdata];
                [weakself.merchandiseArray addObject:model];
                
            }

            ///精选店铺
            if (weakself.pageIndex == 1) {
             [self.recommendArr removeAllObjects];           }
            NSMutableDictionary * merchant=dataDic[@"merchant"];
            NSMutableArray * merchant_arr = merchant[@"merchant_data"];
            [self.dataArray addObject:merchant[@"name"]];
            for (NSDictionary *dic in merchant_arr) {
                MyShopModel *model = [MyShopModel  yy_modelWithJSON:dic];
                [weakself.recommendArr  addObject:model];
            }

            [weakself.collectionView reloadData];

        }else{
            [weakself showToast:response[@"msg"]];
        }
        
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
    //}
    

    
}


-(void)addSubViews{
    self.daohangView = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, Width, 64)];
    _daohangView.backgroundColor = [UIColor whiteColor];
    _daohangView.alpha = 1;
    [self.view addSubview:_daohangView];
    NGView =   [NIBHelper instanceFromNib:@"NavigationView"];
    NGView.delegate = self;
    NGView.backgroundColor = [UIColor clearColor];
    NGView.frame = CGRectMake(0, 0, Width, 64);
    [self.view addSubview:NGView];
    
}

#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self.collectionView collectionViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    
    return  self.dataArray.count;

}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return _HotArray.count==0 ? 0 :1;
   
        }
            break;
        case 2:
        {
            return _merchandiseArray.count==0 ? 0 :1;

 
        }
            break;
        case 3:
        {
            return self.recommendArr.count;
        }
            break;
        default:{
            return 10;
        }
            break;
    }
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
         HomeOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeOneCell" forIndexPath:indexPath];
            //配置item
            //设置点击cell不会变成灰色
            __weak typeof(self) weakSelf = self;

            cell.HomeOneCellBlock = ^(NSInteger tag){
                switch (tag) {
                    case 0:
                    {
                    
                        [weakSelf myPropertyBtn];
                        
                        break;
                    }
                        
                    case 1:
                    {
                        [weakSelf O2OCollectMoneyBtn];
                        break;
                    }
                        
                    case 2:
                    {
                        [weakSelf dfFinanceBtn];
                        break;
                    }
                        
                        
                    case 3:
                    {
                        [weakSelf dfSnatchGemBtn];
                        
                        break;
                    }
                    case 4:
                    {
                        [weakSelf MyHandleCard];
                        
                        break;
                    }
                    case 5:
                    {
                        [weakSelf Myloan];
                        
                        break;
                    }
                    case 6:
                    {
                        [weakSelf Myrecommended];
                        
                        break;
                    }
                    case 7:
                    {
                        [weakSelf MyWealth];
                        
                        break;
                    }
                    default:{
                        
                        break;
                        
                    }
                }

                
                
            };
//            [cell.O2OCollectMoneyBtn addTarget:self action:@selector(O2OCollectMoneyBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//            [cell.myPropertyBtn addTarget:self action:@selector(myPropertyBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//            [cell.dfSnatchGemBtn addTarget:self action:@selector(dfSnatchGemBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//            [cell.dfFinanceBtn addTarget:self action:@selector(dfFinanceBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            
            //"首页广告"
            // 网络加载图片的轮播器
            if (!_cycleScrollView) {
                self. cycleScrollView = [SDCycleScrollView   cycleScrollViewWithFrame:CGRectMake(0, 0, Width, Width*2.1/5) delegate:self placeholderImage:[UIImage imageNamed:@"敬请期待long"]];
                _cycleScrollView.autoScrollTimeInterval =3.0;
                [cell.contentView addSubview:  _cycleScrollView];
            }
            if (_cycleScrollView) {
                _cycleScrollView.imageURLStringsGroup = _LunBoImgArr;
            }

            return cell;
        }
            break;
        case 1:
        {
//            HomeTwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTwoCell" forIndexPath:indexPath];
//            if (_HotArray.count==1) {
//               [cell.oneBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell cellGetData:self.HotArray];
//                
//
//            }else if (_HotArray.count==2){
//                [cell.oneBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.twoBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell cellGetData:self.HotArray];
//                }else if (_HotArray.count==3){
//                [cell.oneBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.twoBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.threeBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell cellGetData:self.HotArray];
//            }else if (_HotArray.count==4){
//                [cell.oneBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.twoBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.threeBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.fourBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell cellGetData:self.HotArray];
//                
//
//            }else if(_HotArray.count==5){
//                [cell.oneBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.twoBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.threeBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.fourBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell.FiveBtn addTarget:self action:@selector(HomeTwoCellBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//                [cell cellGetData:self.HotArray];
//                
//
//            }else{
//                
//            }
//            
//            //配置item
//            return cell;
//            
            
            HotHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotHomeCell" forIndexPath:indexPath];
            if (self.HotArray.count != 0) {
              [cell CellGetData:self.HotArray];  
            }
            __weak typeof(self) weakSelf = self;
            cell.HotHomeCellBlock =^(NSInteger tag){
                //Push 跳转 商品详情
                GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
                GoodsModel *model= self.HotArray[tag];
                VC.goods_id = model.goods_id;
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            };
            
            
            return cell;
        }
            break;
        case 2:
        {
//            HomeThreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeThreeCell" forIndexPath:indexPath];
//            //配置item
//            [cell cellGetData:(GoodsModel*)self.merchandiseArray[indexPath.row]];
//            return cell;
            
            SelectHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectHomeCell" forIndexPath:indexPath];
            if (self.merchandiseArray.count != 0) {
                [cell CellGetData:self.merchandiseArray];
            }
            __weak typeof(self) weakSelf = self;
            cell.SelectHomeCellBlock =^(NSInteger tag){
                //Push 跳转 商品详情
                GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
                GoodsModel *model= self.merchandiseArray[tag];
                VC.goods_id = model.goods_id;
                [weakSelf.navigationController  pushViewController:VC animated:YES];
            };
            
            
            return cell;
            
        }
            
            break;
        case 3:
        {
            HomeFourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFourCell" forIndexPath:indexPath];
            //配置item
            cell.JinDianBut.indexPath = indexPath;
            //MyShopModel *model = self.recommendArr[indexPath.row];
            
            //赋值
            [cell cellGetData:indexPath.row>= self.recommendArr.count ? nil :self.recommendArr[indexPath.row]];
            [cell.JinDianBut addTarget:self action:@selector(JinDianBut:) forControlEvents:(UIControlEventTouchUpInside)];
            
            return cell;
        }
            break;
        default:{
            return nil;
        }
            break;
    }

   
}
#pragma mark -设置页眉和页脚
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        HomePageHeader *headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeader" forIndexPath:indexPath];
        headerView.backgroundColor =[UIColor whiteColor];
        headerView.HeaderTitle.text  =[NSString stringWithFormat:@"%@", self.dataArray[indexPath.section]];

        reusableview = headerView;
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomePageFooter" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
        reusableview = footerview;
        
        
    }
    return reusableview;
    
}

#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
           return CGSizeMake(Width, Width*2.1/5+70+70);
        }
            break;
        case 1:
        {
             return CGSizeMake(Width, Width*2/5);
        }
            break;
        case 2:
        {
             //return CGSizeMake((Width)/2-2, Width*0.6-20);
            return CGSizeMake(Width, Width*1.5/5);
        }
            
            break;
        case 3:
        {
           return CGSizeMake(Width, Width/6);
        }
            break;
        default:{
             return CGSizeMake(80, 80);
        }
            break;
    }

   
    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 1, 1);
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1 ;
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
}
//灵活的设置每个分区的页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
            
            
            break;
        }
            
        case 1:
        {
            return  CGSizeMake([UIScreen mainScreen].bounds.size.width, self.HotArray.count==0 ?0 :40);
            break;
        }
            
        case 2:
        {
            return  CGSizeMake([UIScreen mainScreen].bounds.size.width, self.merchandiseArray.count==0 ?0 :40);
            break;
        }
            
            
        case 3:
        { return  CGSizeMake([UIScreen mainScreen].bounds.size.width, self.recommendArr.count==0 ?0 :40);
            
            break;
        }
            
        default:{
            return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
            break;
            
        }
    }

    
//    
//    if (section==0) {
//    
//    }else{
//        ///热门活动
//        @property (nonatomic,strong)NSMutableArray * HotArray;
//        ///精选商品
//        @property (nonatomic,strong)NSMutableArray * merchandiseArray;
//        ///精选店铺
//        @property (nonatomic,strong)NSMutableArray * recommendArr;
//        
//        if (self.HotArray.count==0) {
//            
//        }else if(merchandiseArray.count==0){
//            
//        }
//        
//        
//    return  CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
//    }
}
//灵活的设置每个分区的页脚的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==3) {
        return  CGSizeMake(Width, 0);
    }else{
        return  CGSizeMake(Width, 8);
    }
    
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        
        case 1:
        {
            break;
  
        }
                  case 2:
        {
            self.view.userInteractionEnabled = NO;

            //Push 跳转 商品详情
            GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
            GoodsModel *model= self.merchandiseArray[indexPath.row];
            VC.goods_id = model.goods_id;
            [self.navigationController  pushViewController:VC animated:YES];
            break;

        }
            
                   case 3:
        {
            
            self.view.userInteractionEnabled = NO;
            
            //Push 跳转
            MyShopModel *model = self.recommendArr[indexPath.row];
            StorePageVC * VC = [[StorePageVC alloc]initWithNibName:@"StorePageVC" bundle:nil];
            NSLog(@"merchant_id---%d",model.merchant_id);
            VC.merchant_id =[NSString stringWithFormat:@"%d",model.merchant_id];
            [self.navigationController  pushViewController:VC animated:YES];

            
            
            break;
        }
           
        default:{
             break;
        }
           
    }

}

#pragma mark - 第一分区btn的点击事件
-(void)HomeTwoCellBtn:(PublicBtn*)sender{
    self.view.userInteractionEnabled = NO;
    //Push 跳转 商品详情
    GoodsMain1ViewController * VC = [[GoodsMain1ViewController alloc]initWithNibName:@"GoodsMain1ViewController" bundle:nil];
    GoodsModel *model= self.HotArray[sender.tag-100];
    VC.goods_id = model.goods_id;
    [self.navigationController  pushViewController:VC animated:YES];
    
    
}
#pragma mark - 进店逛逛
-(void)JinDianBut:(PublicBtn*)sender{
    self.view.userInteractionEnabled = NO;

    //Push 跳转
    MyShopModel *model = self.recommendArr[sender.indexPath.row];
    StorePageVC * VC = [[StorePageVC alloc]initWithNibName:@"StorePageVC" bundle:nil];
    NSLog(@"merchant_id---%d",model.merchant_id);
    VC.merchant_id =[NSString stringWithFormat:@"%d",model.merchant_id];
    [self.navigationController  pushViewController:VC animated:YES];

    
}
//只要拖拽就会触发(scrollView 的偏移量发生改变)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>-21&&scrollView.contentOffset.y<40) {
        // NGView.alpha =1-(-20-scrollView.contentOffset.y)/50;
        [NGView.SaoYiSaoBtn setImage:[UIImage imageNamed:@"首页-扫一扫图标"] forState:(UIControlStateNormal)];
        [NGView.sousuoBtn setImage:[UIImage imageNamed:@"首页-搜索框-搜索按钮"] forState:(UIControlStateNormal)];
        [NGView.XiaoXiBtn setImage:[UIImage imageNamed:@"首页-信息图标"] forState:(UIControlStateNormal)];
        
    }else if(scrollView.contentOffset.y>40){
        // NGView.alpha =1;
        [NGView.SaoYiSaoBtn setImage:[UIImage imageNamed:@"首页-扫一扫图标-灰色"] forState:(UIControlStateNormal)];
        [NGView.sousuoBtn setImage:[UIImage imageNamed:@"首页-搜索框-搜索按钮-灰色"] forState:(UIControlStateNormal)];
        [NGView.XiaoXiBtn setImage:[UIImage imageNamed:@"首页-信息图标-灰色"] forState:(UIControlStateNormal)];
        
    }
    if (scrollView.contentOffset.y<100) {
        _daohangView.alpha =scrollView.contentOffset.y/60;
    }
    
}
#pragma mark -/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    self.view.userInteractionEnabled = NO;

    //Push 跳转
    LunBoImageViewController * VC = [[LunBoImageViewController alloc]init];
    VC.urlStr = self.LunBoUrlArr[index];
    [self.navigationController  pushViewController:VC animated:YES];
}

#pragma mark  - NavigationViewdelegate
-(void)NavErWeiMaPush{
    EWMViewController * VC = [[EWMViewController alloc]initWithNibName:@"EWMViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)NavSouSuoPush{
    
  
    SearchHistoryViewController * VC = [[SearchHistoryViewController alloc]initWithNibName:@"SearchHistoryViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}
-(void)NavMassagePush{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        MessageViewController * VC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else{
        [self pushLoginController];
    }
    
    
}
#pragma mark - 我要收款
-(void)O2OCollectMoneyBtn{
    __weak typeof(self) weakSelf = self;
    [self Realname:^{
        //进行跳转
        O2OMainViewController *O2OVC = [[O2OMainViewController alloc]initWithNibName:@"O2OMainViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:O2OVC animated:YES];
    }];

    
    
}
-(void)O2OCollectMoneyBtn:(UIButton*)sender{
    
   }


#pragma mark - 我的资产

-(void)myPropertyBtn{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        MyPropertyViewController * VC = [[MyPropertyViewController alloc]initWithNibName:@"MyPropertyViewController" bundle:nil];
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        
        [self pushLoginController];
    }

    
    
}
-(void)myPropertyBtn:(UIButton*)sender{
    
}
#pragma mark - 我要开店
-(void)dfSnatchGemBtn{
    //[self GetPublicController];
    //Push 跳转
    OpenShopVC * VC = [[OpenShopVC alloc]initWithNibName:@"OpenShopVC" bundle:nil];
    VC.type = @"3";
    VC.name = @"我要开店";
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}
-(void)dfSnatchGemBtn:(UIButton*)sender{
   }
#pragma mark - 我的服务
-(void)dfFinanceBtn{
    //[self GetPublicController];
    //Push 跳转
    MyServiceVC * VC = [[MyServiceVC alloc]initWithNibName:@"MyServiceVC" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}
-(void)dfFinanceBtn:(UIButton*)sender{
    
}
#pragma mark - 我要办卡
-(void)MyHandleCard{
    __weak typeof(self) weakSelf = self;
    [self Realname:^{
        //Push 跳转
        MyLoanOrCardVC * VC = [[MyLoanOrCardVC alloc]initWithNibName:@"MyLoanOrCardVC" bundle:nil];
        //类型  1-我要办卡 2-我要贷款
        VC.type = 1;
        [weakSelf.navigationController  pushViewController:VC animated:YES];
    }];
    

    
    
}
#pragma mark - 我要贷款
-(void)Myloan{
    
    __weak typeof(self) weakSelf = self;
    [self Realname:^{
        //Push 跳转
        MyLoanOrCardVC * VC = [[MyLoanOrCardVC alloc]initWithNibName:@"MyLoanOrCardVC" bundle:nil];
        //类型  1-我要办卡 2-我要贷款
        VC.type = 2;
        [weakSelf.navigationController  pushViewController:VC animated:YES];
    }];

   
    
}
#pragma mark - 我的推荐
-(void)Myrecommended{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //Push 跳转
        GoodsListViewController * VC = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
        VC.gold_fit = @"1";
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        
        [self pushLoginController];
    }

}
#pragma mark - 一元购
-(void)MyWealth{
    
    //Push 跳转
//    IndianaHomeVC * VC = [[IndianaHomeVC alloc]initWithNibName:@"IndianaHomeVC" bundle:nil];
//    [self.navigationController  pushViewController:VC animated:YES];
    [self GetPublicController];
    
}


-(void)GetPublicController{
    PublicViewController *PBVC = [[PublicViewController alloc] initWithNibName:@"PublicViewController" bundle:nil];
    [self.navigationController pushViewController:PBVC animated:YES];
}
#pragma mark - 实名认证公用
-(void)Realname:(PushOhter)pushOhter{
    NSString *type =[NSString stringWithFormat:@"%@", [AuthenticationModel getidcard_status]];
    NSString *Token =[AuthenticationModel getLoginToken]
    ;
    if (Token.length!= 0) {
        //Push 跳转
        if ([type isEqualToString:@"2"]) {
            NSLog(@"认证成功");
            pushOhter();
            
        }  else if ([type  isEqualToString:@"1"]){
            NSLog(@"认证审核中");
            AuditViewController * adVC = [[AuditViewController alloc]initWithNibName:@"AuditViewController" bundle:nil];
            adVC.titleStr =@"实名认证";
            [self.navigationController pushViewController:adVC animated:YES];
        }else if( [type  isEqualToString:@"3"]){
            NSLog(@"认证失败");
            FailureViewController * adVC = [[FailureViewController alloc]initWithNibName:@"FailureViewController" bundle:nil];
            [self.navigationController pushViewController:adVC animated:YES];
            
        }else{
            NSLog(@"未认证");
            UPNembersViewController * VC = [[UPNembersViewController alloc]initWithNibName:@"UPNembersViewController" bundle:nil];
            VC.upBtnTitle =  @"实名认证";
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else{
        [self pushLoginController];
        
        
    }
 
}

#pragma mark - 版本更新
-(void)updateVerison{
    //获得build号：
    NSString *buildStr =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    int build= [buildStr intValue];
    NSLog(@"build=====%d",build);
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int oldOne=  [[oldVerison substringWithRange:NSMakeRange(0,1)]intValue];
    int oldTwo = [[oldVerison substringWithRange:NSMakeRange(2,1)]intValue];
    int oldThree = [[oldVerison  substringWithRange:NSMakeRange(4,1)]intValue];
    
    //NSLog(@"oldOne----%d\noldTwo----%d\noldThree----%d",oldOne ,oldTwo,oldThree);
    VerisonModel *model = [[VerisonModel alloc]init];
    model.os = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data  = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_VersionUpdate sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        // NSLog(@"检测----%@",response);
        if (baseRes.resultCode == 1) {
            NSDictionary * dic = response[@"data"];
            VerisonModel *model = [VerisonModel yy_modelWithJSON:dic];
            int newOne=  [[model.version substringWithRange:NSMakeRange(0,1)]intValue];
            int newTwo = [[model.version  substringWithRange:NSMakeRange(2,1)]intValue];
            int newThree = [[model.version  substringWithRange:NSMakeRange(4,1)]intValue];
            NSString *newbuildStr;
            if (model.version.length>6) {
                newbuildStr =[model.version substringFromIndex:6];
            }
            int newbuild = [newbuildStr intValue];
            NSLog(@"NewOne----%d\nNewTwo----%d\nNewThree----%d\nnewbuild----%d ",newOne ,newTwo,newThree,newbuild);
            if ([model.is_update isEqualToString:@"1"]) {
                if (oldOne<newOne) {
                    //强制跟新
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }
                else if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree&&build < newbuild){
                    [weakself addMandatoryAlertAction:model];
                    return;
                }
                else{
                    NSLog(@"休息休息");
                }
                
            }else{
                
                if (oldOne<newOne) {
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addAlertAction:model];
                    return ;
                }
                else
                    if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree && build < newbuild){
                        [weakself addAlertAction:model];
                        return;
                    }
                    else
                    {
                        NSLog(@"不用强制更新");
 
                    }
                
                           }
        }else{
            [weakself showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        
        NSLog(@"%@", error);
    }];
}


#pragma mark - 强制更新
-(void)addMandatoryAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
        [weakSelf presentViewController:VC animated:YES completion:nil];
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/l874"]];
        
    }];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark - 不强制更新
-(void)addAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(self) weakSelf = self;
    UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
        [weakSelf presentViewController:VC animated:YES completion:nil];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/l874"]];
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:OK];
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - 关于手势和网络判断
-(void)gestrueViewAndInterView{
    NSString *Token =[AuthenticationModel getLoginToken];
    AppDelegate *del = (AppDelegate*)  [[UIApplication sharedApplication]delegate];
    if (Token.length!= 0) {
        //手势
        [del.window bringSubviewToFront:(UIView*)del.gestureView];
    }
    self.interView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, 40)];
    self.interView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, Width-20, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"网络请求失败,请检查您的网络设置";
    label.font = [UIFont systemFontOfSize:12];
    [_interView addSubview:label];
    _interView.alpha = 0;

    [del.window addSubview:_interView];
    [DWHelper NetWorksSateYESInter:^{
        [del.window sendSubviewToBack:_interView];
        _interView.alpha = 0;
    } NOInter:^{
        [del.window bringSubviewToFront:_interView];
        _interView.alpha = 1;
    }];
    
    
    
}
#pragma mark - 高德地图定位配置
-(void)AMap{
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {       UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的定位功能是禁用的请在设置中打开" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }else {
        
    }
    self.locationManager = [AMapLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        if (error)
        {
            //NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        if (location) {
            
            [defaults setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"Headerlat" ] ;
            [defaults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"Headerlng" ] ;
            NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
            
            //业务处理
        }
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.formattedAddress);
            [defaults setObject:regeocode.formattedAddress forKey:@"HeaderformattedAddress"];
            [defaults setObject:regeocode.province forKey:@"Headerprovince"];
            [defaults setObject:regeocode.city forKey:@"Headercity"];
            [defaults setObject:regeocode.district forKey:@"Headerdistrict"];
            
        }else{
            [defaults setObject:@"福建省福州市晋安区" forKey:@"HeaderformattedAddress"];
            [defaults setObject:@"福建省"forKey:@"Headerprovince"];
            [defaults setObject:@"福州市" forKey:@"Headercity"];
            [defaults setObject:@"晋安区" forKey:@"Headerdistrict"];
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
