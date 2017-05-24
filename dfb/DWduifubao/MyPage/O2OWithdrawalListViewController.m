//
//  O2OWithdrawalListViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OWithdrawalListViewController.h"
#import "O2OWithdrawalViewController.h"
#import "O2OCollectionCell.h"
#import "O2OModel.h"
#import "O2OFailureVC.h"
#import "ZIDAOViewController.h"
#import "ArticleVC.h"
@interface O2OWithdrawalListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)O2OModel *TiXianModel;
@end
@implementation O2OWithdrawalListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现列表";
    [self showBackBtn];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"O2OCollectionCell" bundle:nil] forCellReuseIdentifier:@"O2OCollectionCell"];
  }





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAction];
}
//AES 无参数
-(void)requestAction{
    [self.dataArray removeAllObjects];
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DrawConfigList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSLog(@"response----%@",response);
                NSMutableArray *arr =response[@"data"];
                for (NSDictionary*dic in arr) {
                    O2OModel*Model = [O2OModel yy_modelWithJSON:dic];
                    [weakSelf.dataArray addObject:Model];
                }
                [weakSelf.tableView reloadData];
            }else {
                [weakSelf showToast:response[@"msg"]];
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
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil
                 ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    O2OCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"O2OCollectionCell" forIndexPath:indexPath];
    O2OModel *model = self.dataArray[indexPath.row];
    //cell 赋值
    [DWHelper SD_WebImage:cell.pay_icon imageUrlStr:model.pay_icon placeholderImage:nil];
    cell.pay_name.text = model.pay_name;
    cell.draw_money.text = [NSString stringWithFormat:@"%.2f",model.draw_money];
    // cell 其他配置
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    O2OModel* model = self.dataArray[indexPath.row];
    /*------资道---------*/
    if ([model.channel_type isEqualToString:@"2"]&&[model.channel_pay isEqualToString:@"1"]) {
        self.view.userInteractionEnabled = NO;
        self.TiXianModel = self.dataArray[indexPath.row];
        //跳转到资道提现界面
        [self PushO2OWithdrawalViewController];
        //资道银行卡
        //[self requestCkZidaoGathering];

    }
    
    
}
#pragma mark - 资道实名认证
-(void)requestCkZidaoGathering{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakself = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestCkZidaoGathering" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"资道实名认证---%@",response);
            weakself.view.userInteractionEnabled = YES;
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                //跳转到资道提现界面
                [weakself PushO2OWithdrawalViewController];
            }else if (baseRes.resultCode == 1010){
                NSString *sh_status = response[@"data"][@"sh_status"];
                if ([sh_status isKindOfClass:[NSNull class]]) {
                    [self showToast:@"系统异常"];
                }else{
               
                if ([sh_status isEqualToString:@"3"]||[sh_status isEqualToString:@"4"]) {
                    //审核拒绝或者失败跳转到重回新提交
                    //Push 跳转
                    O2OFailureVC * VC = [[O2OFailureVC alloc]initWithNibName:@"O2OFailureVC" bundle:nil];
                    VC.pushTypeOfO2O = @"提现列表";
                    VC.sh_msg = response[@"data"][@"sh_msg"];
                    //[self.navigationController  pushViewController:VC animated:YES];
                }else if ([sh_status isEqualToString:@"1"]){
                    //未审核
                    [weakself showToast:@"未审核"];
                }else if ([sh_status isEqualToString:@"2"]) {
                    [weakself showToast:@"待审核"];
                }else if ([sh_status isEqualToString:@"5"]) {
                    [weakself showToast:@"审核中"];
                }else{
                    
                }
                
        }
                
            }else{
                [weakself showToast:response[@"msg"]];
                weakself.view.userInteractionEnabled = YES;
                
            }
        } faild:^(id error) {
        weakself.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }
    
    
    
}
#pragma mark - 提现资道界面
-(void)PushO2OWithdrawalViewController{
    //资道提现
    [self requestZiDaoTiXianAction];
}
#pragma mark -     //资道提现

-(void)requestZiDaoTiXianAction{
    
    NSString *Token =[AuthenticationModel getLoginToken];
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakself = self;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestZidaoDraw" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"资道提现链接--%@",response);
            if (baseRes.resultCode == 1) {
                //Push 跳转
                ZIDAOViewController * VC = [[ZIDAOViewController alloc]init];
                VC.url = response[@"data"][@"zidao_url"];
                if ([response[@"data"][@"zidao_url"] isKindOfClass:[NSNull class]]) {
                    weakself.view.userInteractionEnabled = YES;
                    return ;
                }

                [weakself.navigationController  pushViewController:VC animated:YES];

                
            }else {
                weakself.view.userInteractionEnabled = YES;
                [weakself showToast:response[@"msg"]];
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
             weakself.view.userInteractionEnabled = YES;
        }];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    O2OModel* model=  self.dataArray[indexPath.row];
    if (model.withdraw_time.length==0) {
        return Width*0.2;
    }else{
        //用storyboard 进行自适应布局
        self.tableView.estimatedRowHeight = 300;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        return self.tableView.rowHeight>=Width*0.2 ? Width*0.2 : self.tableView.rowHeight;
    }
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
