//
//  AgentViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AgentViewController.h"
#import "AddAgentViewController.h"
#import "AgentModel.h"
#import "AgentCell.h"
@interface AgentViewController ()<UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation AgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
     self.title = @"我的代理";
     self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //cell 高度
    self.tableView.rowHeight = 120;
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"AgentCell" bundle:nil] forCellReuseIdentifier:@"AgentCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //设置"兑换"的按钮样式
    UIButton *exchangeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [exchangeBtn setTitle:@"去代理" forState:UIControlStateNormal];
    exchangeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:kthirdTitleFont];
    [exchangeBtn setTitleColor:[UIColor colorWithHexString:kRedColor] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:exchangeBtn];
    //上拉刷新下拉加载
    [self Refresh];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    //NSLog(@"Token----- %@",Token);
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Agency/requestAreaAgencyList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    AgentModel *model = [AgentModel yy_modelWithJSON:dicdata];
                    model.ID = dicdata[@"id"];
                    [self.dataArray addObject:model];
                }
            }else {
                [self showToast:response[@"msg"]];
            }
            //刷新
            [weakself.tableView reloadData];
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    
}

#pragma mark - 去代理
//设置"去代理"的按钮事件
- (void)exchangeBtnAction:(UIButton *)button {
    NSLog(@"去代理");
    //Push 跳转
    AddAgentViewController * VC = [[AddAgentViewController alloc]initWithNibName:@"AddAgentViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];

    
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
    
    AgentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AgentCell" forIndexPath:indexPath];
    AgentModel *model = self.dataArray[indexPath.row];
        //cell 赋值
    [cell cellGetData:model];
    // cell 其他配置
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
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
