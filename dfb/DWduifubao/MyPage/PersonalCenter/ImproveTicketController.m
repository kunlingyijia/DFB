//
//  ImproveTicketController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ImproveTicketController.h"
#import "ImproveTicketCell.h"

@interface ImproveTicketController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ImproveTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    self.title = @"增票资质";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //设置tableView的背景色
    self.tableView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    //设置TableView自定义Cell的样式
    [self.tableView registerNib:[UINib nibWithNibName:@"ImproveTicketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImproveTicketCell"];
    
    //设置TableViewCell的高度
    self.tableView.rowHeight = 141;
    
    //设置tableViewCell之间的那条线隐藏掉
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置TableView的脚视图
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 55)];
    footV.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.tableView.tableFooterView = footV;
}

#pragma mark - UITableViewDataSource
//设置分区的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImproveTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImproveTicketCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //设置点击tableViewCell不会变成灰色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
//每个cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
