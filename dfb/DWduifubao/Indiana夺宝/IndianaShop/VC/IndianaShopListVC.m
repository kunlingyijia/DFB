//
//  IndianaShopListVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//
#import "IndianaShopListVC.h"
#import "IndianaShopListOneCell.h"
#import "IndianaMenu.h"
#import "IndianaShopDetailsVC.h"
#import "IndianaShopClassModel.h"
#import "IndianaShopModel.h"
#define Controller  IndianaShopListVC
@interface Controller ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)IndianaMenu *indianaMenu;
@property (nonatomic,strong)NSString * category_id;
@property(nonatomic ,strong)NSString * type;
@end
@implementation Controller

#pragma mark -  视图将出现在屏幕之前
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - 视图已在屏幕上渲染完成
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self requestAction];
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
    self.title = self.ClassModel.category_name;
    [self showBackBtn];
    [self setUpTableView];
}
#pragma mark - 关于tableView
-(void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Width*0.11+30, Width, Height-64-Width*0.1-30) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [_tableView tableViewregisterNibArray:@[@"IndianaShopListOneCell"]];
    if (!_indianaMenu) {
        self.indianaMenu = [[IndianaMenu alloc]initWithFrame:CGRectMake(0, 30, Width, Width*0.11) IsClass:YES ClassArr:self.ClassArr ClassOneBtntitle:self.title];
            [self.view addSubview:_indianaMenu];
        __weak typeof(self) weakSelf = self;
        _indianaMenu.IndianaMenuBlock=^(NSInteger tag,NSString * IsUp){
            //type 1-人气 2-最新 3-进度 4-总需递增 5-总需递减
            weakSelf
            .pageIndex = 1;
            switch (tag) {
                case 1:
                {
                    weakSelf.type = @"1";
                    [weakSelf requestAction];
                    break;
                }
                case 2:
                {
                    weakSelf.type = @"2";
                    [weakSelf requestAction];
                    break;
                }
                case 3:
                {
                    weakSelf.type = @"3";
                    [weakSelf requestAction];
                    break;
                }
                case 4:
                {
                    if ([IsUp isEqualToString:@"0"]) {
                        weakSelf.type = @"5";
                        [weakSelf requestAction];
                      
                         //从低到高
                    }else if ([IsUp isEqualToString:@"1"]){
                        weakSelf.type = @"4";
                        [weakSelf requestAction];
                          //从高到低
                    }
                    break;
                }
                default:{
                    break;
                }
            }
        };
        _indianaMenu.IndianaClassMenuBlock=^(NSInteger tag){
            weakSelf.title = ((IndianaShopClassModel*)weakSelf.ClassArr[tag]).category_name;
            weakSelf.category_id =((IndianaShopClassModel*)weakSelf.ClassArr[tag]).category_id;
             weakSelf.type = @"1";
            weakSelf
            .pageIndex = 1;
            [weakSelf requestAction];
        };
    }
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex =1;
    self.category_id = self.ClassModel.category_id;
    self.type = @"1";
   
    //上拉刷新下拉加载
    [self Refresh];
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
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 网络请求
-(void)requestAction{
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"category_id":self.category_id,@"type":self.type}mutableCopy];
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
                 weakself.AllGoogs.text = [NSString stringWithFormat:@"共%@件商品",baseRes.data[@"count"]];
                NSMutableArray *arr = baseRes.data[@"list"];
                for (NSDictionary *dicData in arr) {
                    IndianaShopModel *model = [IndianaShopModel yy_modelWithJSON:dicData];
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
       
    IndianaShopListOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaShopListOneCell" forIndexPath:indexPath];
                //cell 赋值
                cell.model = indexPath.row >= self.dataArray.count ? nil :self.dataArray[indexPath.row];
                // cell 其他配置
                return cell;
    }
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>self.dataArray.count-1||self.dataArray.count==0) {
        return;
    }
    //Push 跳转
    IndianaShopDetailsVC * VC = [[IndianaShopDetailsVC alloc]initWithNibName:@"IndianaShopDetailsVC" bundle:nil];
    VC.goods_id = ((IndianaShopModel*)self.dataArray[indexPath.row]).goods_id;
    [self.navigationController  pushViewController:VC animated:YES];

    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       return Width* 0.3;
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
