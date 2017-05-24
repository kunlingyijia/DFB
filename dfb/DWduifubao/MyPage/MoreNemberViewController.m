//
//  MoreNemberViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/10.
//  Copyright © 2016年 bianming. All rights reserved.
//
#import "MoreNemberViewController.h"
#import "MoreNembersCell.h"
#import "HuiYuanModel.h"
@interface MoreNemberViewController ()
///分页参数
@property(nonatomic,assign) int pageIndex;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation MoreNemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title= @"推荐会员";
    // 1. 配值数据源对象
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.tableView  registerNib:[UINib nibWithNibName:@"MoreNembersCell" bundle:nil] forCellReuseIdentifier:@"MoreNembersCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];

    
    //上拉刷新下拉加载
    [self Refresh];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
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
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"is_today":@(0)}mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestMyInviterList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response);
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                NSArray * arr = response[@"data"][@"progeny_list"];
                for (NSDictionary *dic in arr) {
                    HuiYuanModel *model =[HuiYuanModel yy_modelWithJSON:dic];
                    [weakself.dataArray addObject:model];
                }


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
    
    MoreNembersCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MoreNembersCell" forIndexPath:indexPath];
    HuiYuanModel *model = self.dataArray[indexPath.row];
     cell.timelabel.text = [NSString stringWithFormat:@"%@",model.create_time];
     cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
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
