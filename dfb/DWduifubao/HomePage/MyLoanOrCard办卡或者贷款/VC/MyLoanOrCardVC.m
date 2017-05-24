//
//  MyLoanOrCardVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "MyLoanOrCardVC.h"
#import "MyLoanOrCardOneCell.h"
#import "MyLoanOrCardTwoCell.h"
#import "MyLoanOrCardModel.h"
#import "LunBoImageViewController.h"
@interface MyLoanOrCardVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * top_image;
@end

@implementation MyLoanOrCardVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
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
    [self showBackBtn];
    self.title = self.type == 1 ? @"我要办卡":@"我要贷款";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"MyLoanOrCardOneCell",@"MyLoanOrCardTwoCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pageIndex = 1;
    
    [self requestAction];
    
    //上拉刷新下拉加载
    [self Refresh];
    
    
    
}

-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;

        [weakself requestAction];
        //进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];

    
}
-(void)requestAction{
//    MyLoanOrCardModel *model = [[MyLoanOrCardModel alloc]init];
//    model.type = [NSString stringWithFormat:@"%ld",self.type];
    
    NSMutableDictionary *dic  =[ @{@"type":@(self.type),@"pageIndex":@(self.pageIndex),@"pageCount":@(10)}mutableCopy];
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = AES;
    baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
//    baseReq.token = [AuthenticationModel getLoginToken];
//    baseReq.encryptionType = RequestMD5;
//    baseReq.data = dic;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_ApplyInfoList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:nil  success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        NSLog(@"我要办卡-我要贷款列表%@",response);
        if (baseRes.resultCode == 1) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            weakself. top_image=response[@"data"][@"top_image"];
            for (NSDictionary *dic in response[@"data"][@"list"]) {
                MyLoanOrCardModel *model = [MyLoanOrCardModel yy_modelWithJSON:dic];
                [weakself.dataArray addObject:model];
            }
            [weakself.tableView reloadData];
        }else{
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    }else{
    
    }
    
    
}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            
            return 1;
            
            break;
        }
            
        case 1:
        {
            [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray .count];
         return    self.dataArray .count;
            break;
        }
            
            
        default:{
            return 0;
            break;
            
        }
    }

    
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            
            MyLoanOrCardOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyLoanOrCardOneCell" forIndexPath:indexPath];
            [DWHelper SD_WebImage:cell.top_image imageUrlStr:self.top_image placeholderImage:@"敬请期待long"];
            return cell;
            
            break;
        }
            
        case 1:
        {
            MyLoanOrCardTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyLoanOrCardTwoCell" forIndexPath:indexPath];
            cell.type.text = self.type ==1 ? @"我要办卡":@"我要贷款";
            MyLoanOrCardModel * model= self.dataArray[indexPath.row];
            [cell CellGetData:model];
            
            
            return cell;
            break;
        }
            
        
            
        default:{
            MyLoanOrCardTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyLoanOrCardTwoCell" forIndexPath:indexPath];
            return cell;
            break;
            
        }
    }

    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        
        MyLoanOrCardModel * model =self.dataArray[indexPath.row];
        if (model.url.length==0) return;
        //Push 跳转
        LunBoImageViewController * VC = [[LunBoImageViewController alloc]init];
        VC.urlStr = model.url;
        [self.navigationController  pushViewController:VC animated:YES];
    }
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            
            return Width *0.2;

            
            break;
        }
            
        case 1:
        {
            return Width *0.15;
 
            break;
        }
            
        
            
        default:{
            return Width *0;

            break;
            
        }
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - dealloc
- (void)dealloc
{
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
