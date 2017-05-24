//
//  FocusStoreVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "FocusStoreVC.h"
#import "FocusStoreCell.h"
#import "BackgroundService.h"
#import "MyShopModel.h"
#import "StorePageVC.h"
@interface FocusStoreVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FocusStoreVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //网络请求
    [self requestAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FocusMainVC_Store:) name:@"FocusMainVC_Store" object:nil];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 通知网络请求
-(void)FocusMainVC_Store:(NSNotification*)sender{
    
    
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height) style:(UITableViewStylePlain)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self.tableView tableViewregisterNibArray:@[@"FocusStoreCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    //上拉刷新下拉加载
    [self Refresh];
//    //网络请求
//    [self requestAction];
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
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}

-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestMerchantCollectList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            NSLog(@"积分----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    MyShopModel *model = [MyShopModel yy_modelWithJSON:dicdata];
                    [weakself.dataArray addObject:model];
                }
                //刷新
                [weakself.tableView reloadData];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
    
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
    
    FocusStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FocusStoreCell" forIndexPath:indexPath];
    
    MyShopModel *model = self.dataArray[indexPath.row];
    //fuzhi
    [cell cellGetData:model];
    
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    MyShopModel*model= self.dataArray [indexPath.row];
    StorePageVC * VC = [[StorePageVC alloc]initWithNibName:@"StorePageVC" bundle:nil];
    VC.merchant_id =[NSString stringWithFormat:@"%d",model.merchant_id];
    [self.navigationController  pushViewController:VC animated:YES];

    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = Height;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return 80;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
