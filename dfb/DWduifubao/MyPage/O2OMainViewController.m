//
//  O2OMainViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OMainViewController.h"
#import "O2OMainTwoCell.h"
#import "O2OMainOneCell.h"
#import "O2OCollectionViewController.h"
#import "O2OWithdrawalListViewController.h"
#import "O2OErWeiMaViewController.h"
#import "O2OModel.h"
@interface O2OMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///第一个Cell数组
@property (nonatomic,strong)O2OModel * OneModel;
///数据
@property (nonatomic,strong)NSMutableArray * oneDataArr;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///分页参数
@property(nonatomic,assign) int pageIndex;

@end

@implementation O2OMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"O2O收款";
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.oneDataArr = [NSMutableArray arrayWithCapacity:1];
    self.pageIndex = 1;
       //注册
    [self.tableView tableViewregisterNibArray:@[@"O2OMainOneCell",@"O2OMainTwoCell"]];
    //上拉刷新下拉加载
    [self Refresh];

}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestOneAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestOneAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestOneAction];
}
#pragma mark - 第一个分区数据请求
//AES 无参数
-(void)requestOneAction{
    [self.oneDataArr removeAllObjects];
    NSString *Token =[AuthenticationModel getLoginToken];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestMoney" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                O2OModel* OneModel = [O2OModel yy_modelWithJSON:response[@"data"]];
                [weakSelf.oneDataArr addObject:OneModel];
                
                [weakSelf.tableView reloadData];
                [weakSelf requestAction];
                
            }else {
                [weakSelf showToast:response[@"msg"]];
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
#pragma mark - 第二分区数据请求
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
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_PayOrderList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
             NSLog(@"response----%@",response);
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
            }
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSArray *arr = response[@"data"];
                for (NSDictionary *dicdata in arr) {
                    O2OModel *model = [O2OModel yy_modelWithJSON:dicdata];
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

    if (section==0) {
        return self.oneDataArr.count;
    }else{
        return self.dataArray.count;
    }
    
}

//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
              O2OMainOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"O2OMainOneCell" forIndexPath:indexPath];
            if (self.oneDataArr.count==0) {
            }else{
            O2OModel*  OneModel = self.oneDataArr[indexPath.row];
                //cell 赋值
                [cell cellGetdata:OneModel];
            }
            cell.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //Cell but 添加事件
            [cell.ShouKuanBtn addTarget:self action:@selector(ShouKuanBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.TiXianBtn addTarget:self action:@selector(TiXianBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;

        }
            
            break;
        case 1:{
            O2OMainTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"O2OMainTwoCell" forIndexPath:indexPath];
            O2OModel *model = self.dataArray[indexPath.row];
            //cell 赋值;
            [cell cellGetData:model];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:{
            return nil;
        }
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 295;
    }else{
        return 95;
    }
}
#pragma mark - Cell 收款点击事件
-(void)ShouKuanBtn:(UIButton*)sender{
    //Push 跳转
    O2OCollectionViewController * VC = [[O2OCollectionViewController alloc]initWithNibName:@"O2OCollectionViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];
}
#pragma mark - Cell 提现点击事件
-(void)TiXianBtn:(UIButton*)sender{
    
    //Push 跳转
    O2OWithdrawalListViewController * VC = [[O2OWithdrawalListViewController alloc]initWithNibName:@"O2OWithdrawalListViewController" bundle:nil];
    [self.navigationController  pushViewController:VC animated:YES];    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
         O2OModel *model = self.dataArray[indexPath.row];
        
        if ([model.status isEqualToString:@"1"]) {
            //未支付
            //Push 跳转
            O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
            VC.qrcode_url = model.qrcode_url;
            VC.ErWeiMaLabelStr = model.pay_title;
            [self.navigationController  pushViewController:VC animated:YES];
        }

        
//        if ([model.status isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"2"]) {
//            //未支付
//            //Push 跳转
//            O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//            VC.qrcode_url = model.qrcode_url;
//            VC.ErWeiMaLabelStr = @"微信";
//            [self.navigationController  pushViewController:VC animated:YES];
//        }
//        if ([model.status isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"3"]) {
//            //未支付
//            //Push 跳转
//            O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//            VC.qrcode_url = model.qrcode_url;
//            VC.ErWeiMaLabelStr = @"支付宝";
//            [self.navigationController  pushViewController:VC animated:YES];
//        }
//        
//        if ([model.status isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"5"]) {
//            //未支付
//            //Push 跳转
//            O2OErWeiMaViewController * VC = [[O2OErWeiMaViewController alloc]initWithNibName:@"O2OErWeiMaViewController" bundle:nil];
//            VC.qrcode_url = model.qrcode_url;
//            VC.ErWeiMaLabelStr = @"QQ";
//            [self.navigationController  pushViewController:VC animated:YES];
//        }
//

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
