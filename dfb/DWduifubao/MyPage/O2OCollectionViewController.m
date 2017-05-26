//
//  O2OCollectionViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "O2OCollectionViewController.h"
#import "CalculatorViewController.h"
#import "O2OModel.h"
#import "O2OCollectionCell.h"
#import "O2OFailureVC.h"
#import "ArticleVC.h"
@interface O2OCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong) O2OModel*calculatorModel;
@property(nonatomic,strong)UIView *keepOutView;
@end

@implementation O2OCollectionViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款列表";
    [self showBackBtn];
    __weak typeof(self) weakSelf = self;
    [self ShowRightBtnTitle:@"收款说明" Back:^{
        ArticleVC * VC = [[ArticleVC alloc]initWithNibName:@"ArticleVC" bundle:nil];
        //4-注册协议 5-权益说明 7-O2O收款说明
        VC.type = @"7";
        [weakSelf.navigationController  pushViewController:VC animated:YES];
    }];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //注册
    [self.tableView tableViewregisterNibArray:@[@"O2OCollectionCell"]];
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
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_PayConfigList sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
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
#pragma mark -///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitimage:nil
                 ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
#pragma mark - tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    O2OCollectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"O2OCollectionCell" forIndexPath:indexPath];
   
    //cell赋值
    [cell cellGetData:(O2OModel*)self.dataArray[indexPath.row]];
    //cell选中时的颜色无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // O2OModel* model = self.dataArray[indexPath.row];
    
    self.calculatorModel = self.dataArray[indexPath.row];
    
     [self PushCalculatorViewController];
    
//    /*------资道---------*/
//    if ([model.channel_type isEqualToString:@"2"]&&[model.channel_pay isEqualToString:@"1"]) {
//        self.calculatorModel = self.dataArray[indexPath.row];
//        //资道银行卡
//        //[self requestCkZidaoGathering];
//        //跳转到计算器
//        [self PushCalculatorViewController];
//    }
//    
//    
//    /*------华付通---------*/
//    if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"2"]) {
//        self.calculatorModel = self.dataArray[indexPath.row];
//        //华付通微信
//        [self PushCalculatorViewController];
//    }
//    if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"3"]) {
//        self.calculatorModel = self.dataArray[indexPath.row];
//        //华付通支付宝
//        [self PushCalculatorViewController];
//    }
//   
//    if ([model.channel_type isEqualToString:@"1"]&&[model.channel_pay isEqualToString:@"5"]) {
//        self.calculatorModel = self.dataArray[indexPath.row];
//        //QQ钱包
//        [self PushCalculatorViewController];
//    }
//

    
}
#pragma mark - Cell的高度
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
#pragma mark - 跳转到计数器界面
-(void)PushCalculatorViewController{
    //Push 跳转
    CalculatorViewController * VC = [[CalculatorViewController alloc]initWithNibName:@"CalculatorViewController" bundle:nil];
    VC.calculatorModel = self.calculatorModel;
    [self.navigationController  pushViewController:VC animated:YES];
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
        
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/O2O/requestCkZidaoGathering" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"资道实名认证---%@",response);
            //
            
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            
            if (baseRes.resultCode == 1) {
                //跳转到计算器
                [weakself PushCalculatorViewController];
                
            }else if (baseRes.resultCode == 1010){
                NSString *sh_status = response[@"data"][@"sh_status"];
                if ([sh_status isKindOfClass:[NSNull class]]) {
                    [self showToast:@"系统异常"];
                }else{
                    if ([sh_status isEqualToString:@"3"]||[sh_status isEqualToString:@"4"]) {
                        //审核拒绝或者失败跳转到重回新提交
                        //Push 跳转
                        O2OFailureVC * VC = [[O2OFailureVC alloc]initWithNibName:@"O2OFailureVC" bundle:nil];
                        VC.pushTypeOfO2O = @"收款列表";
                        VC.sh_msg = response[@"data"][@"sh_msg"];
                        // [self.navigationController  pushViewController:VC animated:YES];
                        
                        
                        
                    }else if ([sh_status isEqualToString:@"1"]){
                        //未审核
                        [weakself showToast:@"未审核"];
                    }else if ([sh_status isEqualToString:@"2"]) {
                        [weakself showToast:@"待审核"];
                    }else if ([sh_status isEqualToString:@"5"]) {
                        [weakself showToast:@"审核中"];
                    }
                    
                }
            }else{
                [weakself showToast:response[@"msg"]];
            }
        } faild:^(id error) {
            
            NSLog(@"%@", error);
        }];
        
    }
    
    
    
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
