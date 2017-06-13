//
//  IndianaHomeVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/29.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaHomeVC.h"
#import "IndianaHomeOneVC.h"
#import "IndianaHomeTwoVC.h"
#import "IndianaHomeNoDataCell.h"
#import "IndianaClassVC.h"
#import "IndianaMyVC.h"
#import "IndianaMenu.h"
#import "IndianaShopDetailsVC.h"
#import "IndianaSunVC.h"
#import "PhotoViewController.h"
#import "OpenShopVC.h"
#import "IndianaHomeModel.h"
#import "ClassModel.h"
#import "IndianaShopModel.h"
#import "LuckyNumberVC.h"
@interface IndianaHomeVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///轮播
@property (nonatomic,strong)NSMutableArray * bannerArr;
///喇叭
@property (nonatomic,strong)NSMutableArray * winArray;
@property(nonatomic ,strong)NSString * type;
@end

@implementation IndianaHomeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self   requestBannerBornList];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    ////刷新一元购首页
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestBannerBorn) name:@"RefreshIndianaHomeVC" object:nil];
        //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
////刷新一元购首页
-(void)requestBannerBorn{
    [self.collectionView.mj_header beginRefreshing];
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    [self showBackBtn];
    self.title = @"YY购";
    //注册cell
    [self.collectionView collectionViewregisterNibArray:@[@"IndianaHomeTwoVC",@"IndianaHomeOneVC",@"IndianaHomeNoDataCell"]];
   
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    self.pageIndex =1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerArr = [NSMutableArray arrayWithCapacity:0];
    self.winArray = [NSMutableArray arrayWithCapacity:0];
    //type 1-人气 2-最新 3-进度 4-总需递增 5-总需递减
    self.type = @"1";
    //上拉刷新下拉加载
    [self Refresh];
       NSLog(@"%@",[NSString getIPAddress:NO]);
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        //[weakself requestAction];
        [weakself   requestBannerBornList];
        // 进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.collectionView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.collectionView.mj_footer endRefreshing];
    }];
    [self LocalData];
    
}
#pragma mark - 本地存储
-(void)LocalData{
    
    NSMutableDictionary * DriverInfo = [AuthenticationModel objectForKey:@"IndianaHomeVCData"];
    NSLog(@"%@",DriverInfo);
    if (DriverInfo.count!=0) {
        //轮播图
        for (NSDictionary * dic in DriverInfo[@"banner"]) {
            IndianaHomeModel * model= [IndianaHomeModel yy_modelWithJSON:dic];
            [self.bannerArr addObject:model];
        }
        //喇叭
        for (NSDictionary * dic in DriverInfo[@"win"]) {
            IndianaHomeModel * model= [IndianaHomeModel yy_modelWithJSON:dic];
            [self.winArray addObject:model];
            
        }
        //[self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:0]]];
    }
    
    
    
    
}



#pragma mark - 首页轮播图片+喇叭中奖消息(最新10条)
-(void)requestBannerBornList{
    
    __weak typeof(self) weakSelf = self;
    ClassModel *model = [[ClassModel alloc]init];
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.data = model;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbBannerBornList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
                BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                if (baseRes.resultCode ==1) {
                    
                    if (weakSelf.pageIndex == 1) {
                [AuthenticationModel setValue:response forkey:@"IndianaHomeVCData"];
                    [weakSelf.bannerArr removeAllObjects];
                      [weakSelf.winArray removeAllObjects];
                        
                    }
                    //轮播图
                    for (NSDictionary * dic in baseRes.data[@"banner"]) {
                        IndianaHomeModel * model= [IndianaHomeModel yy_modelWithJSON:dic];
                        [weakSelf.bannerArr addObject:model];
                    }
                    //喇叭
                    for (NSDictionary * dic in baseRes.data[@"win"]) {
                        IndianaHomeModel * model= [IndianaHomeModel yy_modelWithJSON:dic];
                        [weakSelf.winArray addObject:model];
                        
                    }

                        // [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                    [weakSelf requestAction];
                }else{
                    [weakSelf showToast:baseRes.msg];
                }
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];    
}

#pragma mark - 网络请求
-(void)requestAction{
    
    //type	1	int		1-人气 2-最新 3-进度 4-总需递增 5-总需递减
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"type":self.type}mutableCopy];
    __weak typeof(self) weakself = self;
            BaseRequest *baseReq = [[BaseRequest alloc] init];
             baseReq.encryptionType = RequestMD5;
             baseReq.data =dic;
             [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbGoodsList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
                      BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
                 if (weakself.pageIndex == 1) {
                    [weakself.dataArray removeAllObjects];
                }
                if (baseRes.resultCode ==1) {
                    NSMutableArray *arr = baseRes.data[@"list"];
                    for (NSDictionary *dicData in arr) {
                        IndianaShopModel *model = [IndianaShopModel yy_modelWithJSON:dicData];
                        [weakself.dataArray addObject:model];
                    }
                    //刷新
                   // [weakself.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                    [weakself.collectionView reloadData];
                }else{
                    [weakself showToast:baseRes.msg];
                }
            } faild:^(id error) {
                NSLog(@"%@", error);
            }];
                
}

#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return self.dataArray.count ==0 ? 1:self.dataArray.count;
    }
    
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        IndianaHomeOneVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndianaHomeOneVC" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [cell cellGetDataWithWin:self.winArray];
        [cell cellGetDataWithBanner:self.bannerArr];
        ///轮播图
        cell.IndianaHomeOneCellScrollViewImageBlock =^(NSInteger tag){
            [weakSelf IndianaHomeOneCellScrollViewImageBlockTag:tag ];
        };
        
        ///分类-我的-晒单-帮助
        cell.IndianaHomeOneCellBlock =^(NSInteger tag){
            [weakSelf IndianaHomeOneCellBlockTag:tag ];
        };
        ///人气-最新-进度-
        cell.IndianaHomeOneCellMenuBlock =^(NSInteger tag,NSString * IsUp){
            [weakSelf IndianaHomeOneCellMenuBlockTag:tag IsUp:IsUp];
        };
        return cell;
    }else{
        if (self.dataArray.count>0) {
            IndianaHomeTwoVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndianaHomeTwoVC" forIndexPath:indexPath];
            cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
            //配置item
            return cell;

        }else{
            IndianaHomeNoDataCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndianaHomeNoDataCell" forIndexPath:indexPath];
           
            //配置item
            return cell;
        }
        
        
    }
    
    
   
}
#pragma mark - 轮播图点击事件
-(void)IndianaHomeOneCellScrollViewImageBlockTag:(NSInteger)tag{
   
    if (tag>self.bannerArr.count-1||self.bannerArr.count==0) {
        return;
    }
    IndianaHomeModel * model = self.bannerArr[tag];
       //Push 跳转
    IndianaShopDetailsVC * VC = [[IndianaShopDetailsVC alloc]initWithNibName:@"IndianaShopDetailsVC" bundle:nil];
     VC.goods_id = model.goods_id;
    [self.navigationController  pushViewController:VC animated:YES];

    
}
#pragma mark - 分类-我的-晒单-帮助点击事件
-(void)IndianaHomeOneCellBlockTag:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
            //Push 跳转
            IndianaClassVC * VC = [[IndianaClassVC alloc]initWithNibName:@"IndianaClassVC" bundle:nil];
            [self.navigationController  pushViewController:VC animated:YES];
            break;
        }
            
        case 1:
        {
            //Push 跳转
            IndianaMyVC * VC = [[IndianaMyVC alloc]initWithNibName:@"IndianaMyVC" bundle:nil];
            [self.navigationController  pushViewController:VC animated:YES];
            break;
        }
            
        case 2:
        {
            //Push 跳转
            IndianaSunVC * VC = [[IndianaSunVC alloc]initWithNibName:@"IndianaSunVC" bundle:nil];
            VC.title = @"晒单";
            [self.navigationController  pushViewController:VC animated:YES];
            break;
        }
        case 3:
        {
            //Push 跳转
            OpenShopVC * VC = [[OpenShopVC alloc]initWithNibName:@"OpenShopVC" bundle:nil];
            VC.type = @"8";
            VC.name = @"帮助";
            [self.navigationController  pushViewController:VC animated:YES];
           
            break;
        }
            
        default:{
            break;
            
        }
    }
}

#pragma mark - ///人气-最新-进度-点击事件
-(void)IndianaHomeOneCellMenuBlockTag:(NSInteger)tag IsUp:(NSString*)isUp{
    //type 1-人气 2-最新 3-进度 4-总需递增 5-总需递减
     self.pageIndex = 1;
     switch (tag) {
            
        case 1:
        {
             self.type = @"1";
           
            [self requestAction];
            break;
        }
            
        case 2:
        {
             self.type = @"2";
             [self requestAction];
            break;
        }
         case 3:
        {
             self.type = @"3";
             [self requestAction];
            break;
        }
        case 4:
        {
            //type 1-人气 2-最新 3-进度 4-总需递增 5-总需递减
            if ([isUp isEqualToString:@"0"]) {
                  self.type = @"5";
                  [self requestAction];
          
                //从低到高
            }else if ([isUp isEqualToString:@"1"]){
                  self.type = @"4";
                 [self requestAction];
                //从高到低
            }
            break;
        }
        default:{
            break;
            
        }
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0) {
        if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
            return;
        }
        //Push 跳转
        IndianaShopDetailsVC * VC = [[IndianaShopDetailsVC alloc]initWithNibName:@"IndianaShopDetailsVC" bundle:nil];
        VC.goods_id = ((IndianaShopModel*)self.dataArray[indexPath.row]).goods_id;
        [self.navigationController  pushViewController:VC animated:YES];
    }
}

#pragma 集合视图 --约束代理方法
//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return CGSizeMake(Width, Width*0.811+2);
    }else{
        
        if (self.dataArray.count>0) {
            return CGSizeMake((Width-1)/2, (Width-1)/2*1.5);
        }else{
            return CGSizeMake(Width,Height - Width*0.811+2-64);
  
        }
}
    
}
//设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
         return UIEdgeInsetsMake(0, 0, 1, 0);
    }
   
    
}
//设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 1 ;

    }
    
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }else{
        return 1 ;
        
    }

}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
