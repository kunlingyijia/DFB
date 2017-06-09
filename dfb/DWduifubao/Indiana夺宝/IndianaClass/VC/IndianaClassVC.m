//
//  IndianaClassVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaClassVC.h"
#import "IndianaShopListVC.h"
#import "IndianaClassOneCell.h"
#import "IndianaShopClassModel.h"
#define Controller  IndianaClassVC
@interface Controller ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation Controller
#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark -  载入完成
- (void)viewDidLoad {
    [super viewDidLoad];
    //关于UI
    [self SET_UI];
    //关于数据
    [self  SET_DATA];
    
    
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"商品分类";
    [self showBackBtn];
    [self setUpTableView];
    
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndianaClassOneCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    //上拉刷新下拉加载
    [self Refresh];
    [self requestAction];

}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
//    //上拉加载
//    self.tableView. mj_footer=
//    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakself.pageIndex ++ ;
//        NSLog(@"%ld",(long)weakself.pageIndex);
//        [weakself requestAction];
//        // 进入刷新状态后会自动调用这个block
//        [weakself.tableView.mj_footer endRefreshing];
//    }];
    
    [self LocalData];
    
}
#pragma mark - 本地存储
-(void)LocalData{
    
    NSMutableArray * DriverInfo = [AuthenticationModel objectForKey:@"IndianaClassVCData"];
    NSLog(@"%@",DriverInfo);
    if (DriverInfo.count!=0) {
        for (NSDictionary *dicData in DriverInfo) {
            IndianaShopClassModel *model = [IndianaShopClassModel yy_modelWithJSON:dicData];
            [self.dataArray addObject:model];
        }
        //刷新
        [self.tableView reloadData];
    }
    
    
    
    
}

#pragma mark - 网络请求
-(void)requestAction{
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    __weak typeof(self) weakself = self;
         BaseRequest *baseReq = [[BaseRequest alloc] init];
         baseReq.encryptionType = RequestMD5;
         baseReq.data =dic;
         [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbCategoryList sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode ==1) {
                if (weakself.pageIndex == 1) {
                    [AuthenticationModel setValue:response forkey:@"IndianaClassVCData"];
                    [weakself.dataArray removeAllObjects];
                    
                }
                
                NSMutableArray *arr = baseRes.data;
                for (NSDictionary *dicData in arr) {
                    IndianaShopClassModel *model = [IndianaShopClassModel yy_modelWithJSON:dicData];
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:baseRes.msg];
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
    
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //分割线
    //tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    }else{
        
        IndianaClassOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaClassOneCell" forIndexPath:indexPath];
        
        //cell 赋值
        cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
       
        return cell;
        
    }
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Push 跳转
    IndianaShopListVC * VC = [[IndianaShopListVC alloc]initWithNibName:@"IndianaShopListVC" bundle:nil];
    VC.ClassArr = self.dataArray;
    VC.ClassModel = self.dataArray[indexPath.row];
    [self.navigationController  pushViewController:VC animated:YES];
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return Width*0.12;
    
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
