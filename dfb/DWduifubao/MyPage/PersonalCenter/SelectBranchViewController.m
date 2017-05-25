//
//  SelectBranchViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/30.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SelectBranchViewController.h"

@interface SelectBranchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SelectBranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"搜索支行";
    self.dataList=[NSMutableArray arrayWithCapacity:1];
    self.searchList =[NSMutableArray arrayWithCapacity:1];
    for (NSInteger i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld-FlyElephant",(long)i]];
    }
    self. searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"search"];
    
}
#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 1;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    //cell 赋值
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    return cell;
    
    // cell 其他配置
    
    
    /*
     //cell选中时的颜色 无色
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //cell 背景颜色
     cell.backgroundColor = [UIColor yellowColor];
     //分割线
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
     */
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.active) {
        NSLog(@"%@",self.searchList[indexPath.row]);
    }
    else{
        NSLog(@"%@",self.dataList[indexPath.row]);
    }
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

@end