//
//  IndustryClassTwoVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndustryClassTwoVC.h"
#import "MerchantIntroduceVC.h"
#import "MyServiceCell.h"
#import "IndustryModel.h"
@interface IndustryClassTwoVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation IndustryClassTwoVC


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
    self.title = @"选择经营品类";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"MyServiceCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyServiceCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.label.text = dic[@"name"];
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ;
    
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"行业类型" object:nil userInfo:[NSDictionary dictionaryWithObject:self.dataArray[indexPath.row] forKey:@"行业类型" ]];
    for (BaseViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[ MerchantIntroduceVC class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Width*0.1;
    
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
