//
//  DWBankViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWBankViewController.h"
#import "Bank_Region_Bank_Branch.h"
#import "DWProvinceViewController.h"
#import "DWBanKMainCell.h"
@interface DWBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation DWBankViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"请选择开户行";
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView tableViewregisterNibArray:@[@"DWBanKMainCell"]];
    __weak typeof(self) weakSelf = self;
    [[Bank_Region_Bank_Branch shareBank_Region_Bank_Branch ] selectDataFromBack:^(NSMutableArray *arr) {
        weakSelf.dataArray = arr;
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
    
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DWBanKMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DWBanKMainCell" forIndexPath:indexPath];
    NSString * bank_name = ((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_name;
    cell.Bank_nameLabel.text = bank_name;
    cell.BankImageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@",bank_name]] ;
        return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    DWProvinceViewController * VC = [[DWProvinceViewController alloc]initWithNibName:@"DWProvinceViewController" bundle:nil];
    
    VC.BackDic= [@{@"bank_name":((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_name,@"bank_no":((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_no}mutableCopy];

    [self.navigationController  pushViewController:VC animated:YES];

}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
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
