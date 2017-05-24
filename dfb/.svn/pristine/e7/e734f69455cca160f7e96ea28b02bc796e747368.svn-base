//
//  ShopKindMessageController.m
//  DWduifubao
//
//  Created by kkk on 16/9/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopKindMessageController.h"
#import "IndianaKindListCell.h"
#import "IndianaGoodsListHeaderView.h"
#import "IndianaMessageController.h"
@interface ShopKindMessageController ()<UITableViewDelegate, UITableViewDataSource, IndianaKindListCelldelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IndianaGoodsListHeaderView *headerView;
@end

@implementation ShopKindMessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newShowBackBtn];
    [self createView];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[IndianaKindListCell class] forCellReuseIdentifier:@"IndianaKindListCell"];
    
    self.headerView = [[IndianaGoodsListHeaderView alloc] initWithFrame:CGRectMake(0, 0, Width, 45)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.tableView];
}

- (void)newShowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(newDoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)newDoBack:(id)sender{
    [self.headerView newHiddenView];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndianaKindListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndianaKindListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

#pragma mark - IndianaKindListCelldelegate
- (void)selectedJoin:(NSString *)goodsId {
    IndianaMessageController *indianaC = [[IndianaMessageController alloc] init];
    [self.navigationController pushViewController:indianaC animated:YES];
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
