//
//  DWBankBranchViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/6.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWBankBranchViewController.h"
#import "RealNameCertificationController.h"
#import "BankChangeViewController.h"
#import "PerfectDataController.h"
#import "MerchantDataThreeVC.h"
#import "Bank_Region_Bank_Branch.h"
#import "DWBankCell.h"
#import "BankChangeVC.h"
@interface DWBankBranchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray  *searchList;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)BOOL searchAlive;
@end
@implementation DWBankBranchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"请选择开户支行";
    self.searchAlive = NO;
    [self.tableView tableViewregisterClassArray:@[@"DWBankCell"]];
    self.tableView.tableFooterView = [[UIView alloc]init];
    __weak typeof(self) weakSelf = self;    [[Bank_Region_Bank_Branch shareBank_Region_Bank_Branch ] selectDataFromBack_branchWithBack_no:self.BackDic[@"bank_no"] city_id:self.BackDic[@"city_id"] ReturnArr:^(NSMutableArray *arr) {
        weakSelf.dataArray = arr;
    }];
    // 添加搜索框
    [self addSearchBar];
    
}
#pragma mark -  添加搜索框
-(void)addSearchBar{
    // 创建UISearchBar对象
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Width, 50.0)];
    // 设置没有输入时的提示占位符
    [searchBar setPlaceholder:@"请输入支行名称"];
    // 显示Cancel按钮
    searchBar.showsCancelButton = NO;
    // 设置代理
    searchBar.delegate = self;    
    //设置 searchBar 为 table 的头部视图
    _tableView.tableHeaderView = searchBar;
}
#pragma mark -  UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *searchString = searchText;
    self.searchAlive = !    self.searchAlive ;
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    
    [[Bank_Region_Bank_Branch shareBank_Region_Bank_Branch]selectDataFromBack_branchWithBack_no:self.BackDic[@"bank_no"] city_id:self.BackDic[@"city_id"] Str:searchString ReturnArr:^(NSMutableArray *arr) {
        //NSLog(@"%ld",arr.count);
        weakSelf.searchList = arr;
        //刷新表格
        [weakSelf.tableView reloadData];
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
    
    if (self.searchAlive ==YES
) {
        [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.searchList.count];
        return [self.searchList count];
        
    }else{
        [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
        return [self.dataArray count];
    }

}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DWBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DWBankCell" forIndexPath:indexPath];
    if (self.searchAlive ==YES) {
        [cell.textLabel setText:((Bank_Region_Bank_BranchModel*)self.searchList[indexPath.row]).bank_branch];
    }
    else{
        [cell.textLabel setText:((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_branch];
    }
    
    
    return cell;
}
- (void)dealloc {
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchAlive ==YES) {
        [self.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.searchList[indexPath.row]).bank_branch forKey:@"bank_branch"];
        [self.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.searchList[indexPath.row]).bank_branch_no forKey:@"bank_branch_no"];
    }
    else{
        [self.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_branch forKey:@"bank_branch"];
        [self.BackDic setObject:((Bank_Region_Bank_BranchModel*)self.dataArray[indexPath.row]).bank_branch_no forKey:@"bank_branch_no"];

    }
    //创建通知通知中心
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Bank_Region_Bank_Branch" object:self userInfo:[NSDictionary dictionaryWithObject:self.BackDic forKey:@"Bank_Region_Bank_Branch"]];
    
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        
        if ([tempVC isKindOfClass:[ RealNameCertificationController
 class ]]) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }
        if ([tempVC isKindOfClass:[ BankChangeViewController
                                   class ]]) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }
        if ([tempVC isKindOfClass:[ BankChangeVC
                                   class ]]) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }
        
        
        
        if ([tempVC isKindOfClass:[ PerfectDataController
                                   class ]]) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }
        
        if ([tempVC isKindOfClass:[ MerchantDataThreeVC
                                   class ]]) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        }


    }


}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}
-(NSMutableArray *)searchList{
    if (!_searchList) {
        self.searchList = [NSMutableArray arrayWithCapacity:1];
    }return _searchList;
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
