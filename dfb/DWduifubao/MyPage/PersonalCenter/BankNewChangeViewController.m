//
//  BankNewChangeViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BankNewChangeViewController.h"
#import "DWBankViewController.h"
#import "BankChangeViewController.h"
#import "MyBankCell.h"
#import "PersonRenZhengModel.h"
#import "BankChangeVC.h"
@interface BankNewChangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
///认证拒绝传的Model
@property (nonatomic, strong) PersonRenZhengModel *perModel ;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation BankNewChangeViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"我的银行卡";
    [self.tableView tableViewregisterNibArray:@[@"MyBankCell"]];
    self.tableView.tableFooterView = [[UITableView alloc]init];
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //网络请求
    [self requestAction];
}
#pragma mark - 网络请求
-(void)requestAction{
    [self.dataArray removeAllObjects];
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Finance/requestBankInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableArray * arr = response[@"data"];
                for (NSDictionary *dic in arr) {
                    PersonRenZhengModel* Model= [PersonRenZhengModel yy_modelWithJSON:dic];
                    [weakSelf.dataArray addObject:Model];
                }
                [weakSelf.tableView reloadData];
                //检测修改提交btn
                [weakSelf ChangBtn];

            }else{
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
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyBankCell" forIndexPath:indexPath];
    PersonRenZhengModel *model = self.dataArray[indexPath.row];
    //cell 赋值
    [cell cellGetData:model];
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //分割线
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
}

#pragma mark - 修改银行卡
- (IBAction)changeBankAction:(UIButton *)sender {
    //Push 跳转
    BankChangeViewController   * VC = [[BankChangeViewController alloc]initWithNibName:@"BankChangeViewController" bundle:nil];
    if (self.dataArray.count==1) {
         VC.perModel = self.dataArray[0];
        [self.navigationController  pushViewController:VC animated:YES];
    }
    if (self.dataArray.count==2) {
        PersonRenZhengModel *model = self.dataArray[1];
        if ([model.status isEqualToString:@"4"]) {
            VC.perModel = model;
            [self.navigationController  pushViewController:VC animated:YES];
        }
        
    }


}


#pragma mark - 判断修改银行卡的状态 改变btn的属性
-(void)ChangBtn{
    if (self.dataArray.count==1) {
        
        self.ChangBankBtn.backgroundColor = [UIColor redColor];
        self.ChangBankBtn.userInteractionEnabled = YES;
        [self.ChangBankBtn setTitle:@"修改银行卡" forState:(UIControlStateNormal)];
    }
    else if (self.dataArray.count==2) {
        PersonRenZhengModel *model = self.dataArray[1];
        if ([model.status isEqualToString:@"2"]||[model.status isEqualToString:@"3"]) {
            self.ChangBankBtn.backgroundColor = [UIColor grayColor];
            self.ChangBankBtn.userInteractionEnabled = NO;
            [self.ChangBankBtn setTitle:@"银行卡审核中..." forState:(UIControlStateNormal)];
            
        }else if ([model.status isEqualToString:@"4"]){
            self.ChangBankBtn.backgroundColor = [UIColor redColor];
            self.ChangBankBtn.userInteractionEnabled = YES;
            [self.ChangBankBtn setTitle:@"修改银行卡" forState:(UIControlStateNormal)];
        }
        
    }

}

@end
