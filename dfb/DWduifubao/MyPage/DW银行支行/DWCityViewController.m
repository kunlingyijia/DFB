//
//  DWCityViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWCityViewController.h"
#import "DWBankBranchViewController.h"
#import "Bank_Region_Bank_Branch.h"
#import "DWBankCell.h"
@interface DWCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation DWCityViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"请选择开户行地区";
    self.tableView.tableFooterView = [[UIView alloc]init];

    [self.tableView tableViewregisterClassArray:@[@"DWBankCell"]];
    __weak typeof(self) weakSelf = self;
    [[Bank_Region_Bank_Branch shareBank_Region_Bank_Branch ] selectDataFromCityWithProvince_id:self.BackDic[@"province_id"] ReturnArr:^(NSMutableArray *arr) {
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
    
    DWBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DWBankCell" forIndexPath:indexPath];
    cell.textLabel.text = ((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).city_name;
        return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    DWBankBranchViewController * VC = [[DWBankBranchViewController alloc]initWithNibName:@"DWBankBranchViewController" bundle:nil];
     VC.BackDic = self.BackDic;
    [VC.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).city_id forKey:@"city_id"];
    [VC.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).city_name forKey:@"city_name"];
    [self.navigationController  pushViewController:VC animated:YES];
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
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
