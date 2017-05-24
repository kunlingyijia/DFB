//
//  OrderCommentsListVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderCommentsListVC.h"
#import "OrderCommentsListCell.h"
#import "GoodsModel.h"
#import "SubmitCommentsVC.h"
@interface OrderCommentsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderCommentsListVC

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
    self.title = @"评价列表";
    [self.tableView tableViewregisterNibArray:@[@"OrderCommentsListCell"]];
    NSLog(@"评价列表-------%@",[self.goodsArray yy_modelToJSONObject]);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    return self.goodsArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    OrderCommentsListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCommentsListCell" forIndexPath:indexPath];
    cell.commentsBtn.indexPath = indexPath;
    //cell 赋值
    [cell cellGetData:(GoodsModel *)self.goodsArray[indexPath.row]];
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.commentsBtn addTarget:self action:@selector(commentsBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
#pragma mark - 去评论
-(void)commentsBtn:(PublicBtn*)sender{
    //Push 跳转
      GoodsModel*model = self.goodsArray[sender.indexPath.row];
    if ([model.is_comment isEqualToString:@"1"]) {
        [self showToast:@"评论已完成"];
        return;
    }else{
    SubmitCommentsVC * VC = [[SubmitCommentsVC alloc]initWithNibName:@"SubmitCommentsVC" bundle:nil];
    VC.Gmodel = model;
    VC.order_no = self.order_no;
    [self.navigationController  pushViewController:VC animated:YES];
    }
    
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.25*Width;
    
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
