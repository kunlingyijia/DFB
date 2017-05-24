//
//  StoreListViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreListCellCell.h"
#import "BackgroundService.h"
#import "MyShopModel.h"
#import "MyShopViewController.h"
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation StoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"关注店铺";
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreListCellCell" bundle:nil] forCellReuseIdentifier:@"StoreListCellCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
   

    //上拉刷新下拉加载
    [self Refresh];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAction];
    [BackgroundService requestPushVC:nil MyselfAction:^{
        
    }];
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
    
    StoreListCellCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StoreListCellCell" forIndexPath:indexPath];
    MyShopModel *model = self.dataArray[indexPath.row];
    //fuzhi
    [cell cellGetData:model];
    
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    /*
          //cell 背景颜色
     cell.backgroundColor = [UIColor yellowColor];
     //分割线
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
     */
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    MyShopViewController * VC = [[MyShopViewController alloc]initWithNibName:@"MyShopViewController" bundle:nil];
    VC.act = @"act=Api/Merchant/requestMerchantInfo";
    VC.titleStr = @"店铺详情";
    MyShopModel *model = self.dataArray[indexPath.row];
    VC.merchant_id = model.merchant_id;
    [self.navigationController  pushViewController:VC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
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
