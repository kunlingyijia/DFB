//
//  AccountInformationVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AccountInformationVC.h"
#import "MerchantCertificationModel.h"
#import "AccountInformationOneCell.h"
#import "ChangeMerchantsBank.h"
@interface AccountInformationVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)MerchantCertificationModel*MCModel;
@property(nonatomic,strong)MerchantCertificationModel*ChangeMCModel;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///分页参数
@property(nonatomic,assign) int pageIndex;

@end

@implementation AccountInformationVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO  animated:animated];
    
    
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
    self.title = @"账户信息";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterClassArray:@[@"UITableViewCell"]];
    [self.tableView tableViewregisterNibArray:@[@"AccountInformationOneCell"]];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.pageIndex =1;
    //银行卡信息-正在使用（商户）
    [self requestBankCardInfo];
    //账户流水（商户）
    [self requestFlowList];
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestFlowList];
        
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestFlowList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    //下拉刷新
    self.scrollView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestBankCardInfo];
        
        // 进入刷新状态后会自动调用这个block
        [weakself.scrollView.mj_header endRefreshing];
        
    }];
//    //上拉加载
//    self.scrollView. mj_footer=
//    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [weakself requestBankCardInfo];
//        // 进入刷新状态后会自动调用这个block
//        [weakself.scrollView.mj_footer endRefreshing];
//    }];

    
    
}

#pragma mark -银行卡信息-正在使用（商户）
-(void)requestBankCardInfo{
       NSString *Token =[AuthenticationModel getLoginToken];
    MerchantCertificationModel * model = [MerchantCertificationModel new];
    model.merchant_id =self.merchant_id;
    
    __weak typeof(self) weakSelf = self;
    
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestBankCardInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"银行卡信息-正在使用（商户）--%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
               
                weakSelf.MCModel =[MerchantCertificationModel yy_modelWithJSON:response[@"data"]];
                if ([weakSelf.MCModel.status isEqualToString:@"3"]) {
                    
                    weakSelf.ChangeMCModel =[MerchantCertificationModel yy_modelWithJSON:weakSelf.MCModel.other_bank];
                }
                
                [weakSelf  kongjianfuzhi];
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}

#pragma mark -账户流水（商户）
-(void)requestFlowList{
    NSString *Token =[AuthenticationModel getLoginToken];
     NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"merchant_id":self.merchant_id }mutableCopy];
    
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestFlowList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"账户流水（商户）--%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableArray * arr = response[@"data"];
                [weakSelf.dataArray removeAllObjects];
                for (NSDictionary *dic in arr) {
                    MerchantCertificationModel * model = [MerchantCertificationModel yy_modelWithJSON:dic];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
-(void)kongjianfuzhi{
    ///状态 2- 对私 1- 对公;
    self.bank_card_type.text = [self.MCModel.bank_card_type isEqualToString:@"1"] ?@"对公":@"对私";
    self.bank_name.text = self.MCModel.bank_name;
    NSString *bank_account_number = [NSString stringWithFormat:@"%@",[self.MCModel.bank_account_number substringFromIndex:self.MCModel.bank_account_number.length- 4 ]];
    self.bank_account_number.text = [NSString stringWithFormat:@"****  **** **** %@" ,bank_account_number];
    self.subbranch.text = self.MCModel.subbranch;
///1-待审核 2-通过 3--审核不通过(1、3状态表示其他卡情况)
    self.statusimage.hidden =[self.MCModel.status isEqualToString:@"3"]? NO :YES;
    self.content.text =[self.MCModel.status isEqualToString:@"3"]?self.MCModel.content:@"";
    
    [self.submitBtn setTitle:[self.MCModel.status isEqualToString:@"1"] ?@"审核中..":@"修改"forState:(UIControlStateNormal)];
    self.submitBtn.backgroundColor = [self.MCModel.status isEqualToString:@"1"] ?[UIColor grayColor]:[UIColor redColor];
     self.submitBtn.userInteractionEnabled = [self.MCModel.status isEqualToString:@"1"] ?NO:YES;
    
    
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
    
    AccountInformationOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccountInformationOneCell" forIndexPath:indexPath];
    MerchantCertificationModel * model =self.dataArray[indexPath.row] ;
    [cell CellGetData:model];
    
    //cell 赋值
    
    
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
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
- (IBAction)SegmentedControlAction:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.tableView.hidden = YES;
            self.BottomView.hidden = NO;
            
            break;
        }
            
        case 1:
        {
            self.tableView.hidden = NO;
            self.BottomView.hidden = YES;
            break;
        }
            
            
        default:{
            
            break;
            
        }
    }

}


- (IBAction)submitBtnAction:(UIButton *)sender {
    ///1-待审核 2-通过 3--审核不通过(1、3状态表示其他卡情况)
    if ([self.MCModel.status isEqualToString:@"1"]) {
        [self showToast:@"审核中"];
    }else if ([self.MCModel.status isEqualToString:@"2"]){
        //Push 跳转
        ChangeMerchantsBank * VC = [[ChangeMerchantsBank alloc]initWithNibName:@"ChangeMerchantsBank" bundle:nil];
        __weak typeof(self) weakSelf = self;
        VC.ChangeMerchantsBankVCBlock =^(){
            //银行卡信息-正在使用（商户）
            [weakSelf requestBankCardInfo];
        };
        VC.MCModel = self.MCModel;
        [self.navigationController  pushViewController:VC animated:YES];

        
    }else if ([self.MCModel.status isEqualToString:@"3"]){
        //Push 跳转
        ChangeMerchantsBank * VC = [[ChangeMerchantsBank alloc]initWithNibName:@"ChangeMerchantsBank" bundle:nil];
        __weak typeof(self) weakSelf = self;

        VC.ChangeMerchantsBankVCBlock =^(){
            //银行卡信息-正在使用（商户）
            [weakSelf requestBankCardInfo];
        };
        VC.MCModel = self.ChangeMCModel;
        [self.navigationController  pushViewController:VC animated:YES];
    }else{
        //Push 跳转
        ChangeMerchantsBank * VC = [[ChangeMerchantsBank alloc]initWithNibName:@"ChangeMerchantsBank" bundle:nil];
        __weak typeof(self) weakSelf = self;
        
        VC.ChangeMerchantsBankVCBlock =^(){
            //银行卡信息-正在使用（商户）
            [weakSelf requestBankCardInfo];
        };
        VC.MCModel = self.ChangeMCModel;
        [self.navigationController  pushViewController:VC animated:YES];
    }

   
    
}



@end
