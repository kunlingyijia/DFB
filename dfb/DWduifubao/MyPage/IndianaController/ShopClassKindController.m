//
//  ShopClassKindController.m
//  DWduifubao
//
//  Created by kkk on 16/9/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ShopClassKindController.h"
#import "ShopKindMessageController.h"
@interface ShopClassKindController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *kindImageArr;
@property (nonatomic, strong) NSArray *kindNameArr;
@end

@implementation ShopClassKindController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"商品分类";
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"classKindCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopKindMessageController *shopKindM = [[ShopKindMessageController alloc] init];
    shopKindM.title = self.kindNameArr[indexPath.row];
    [self.navigationController pushViewController:shopKindM animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.kindImageArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classKindCell" forIndexPath:indexPath];
    cell.textLabel.text = self.kindNameArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.kindImageArr[indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.textColor = [UIColor colorWithHexString:kTitleColor];
    if (cell) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, Bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:kLineColor];
        line.tag = 1000;
        [cell addSubview:line];
    }
    return cell;
}


- (NSArray *)kindImageArr {
    if (!_kindImageArr) {
        self.kindImageArr = @[@"夺宝－商品分类－全部商品",@"夺宝－商品分类－优选商品",@"夺宝－商品分类－手机平板",@"夺宝－商品分类－电脑办公",@"夺宝－商品分类－数码影音",@"夺宝－商品分类－女性时尚",@"夺宝－商品分类－美食天地",@"夺宝－商品分类－潮流新品",@"夺宝－商品分类－其他商品"];
    }
    return _kindImageArr;
}

- (NSArray *)kindNameArr {
    if (!_kindNameArr) {
        self.kindNameArr = @[@"全部分类",@"优选商品",@"手机平板",@"电脑办公",@"数码影音",@"女性时尚",@"美食天地",@"潮流新品",@"其他商品"];
    }
    return _kindNameArr;
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
