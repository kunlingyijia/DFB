//
//  spectrumVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/2/9.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "spectrumVC.h"
#import "MyServiceModel.h"
#import "OpenShopVC.h"
#import "MyServiceCell.h"
#import "SpectrumViewController.h"
@interface spectrumVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation spectrumVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

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
    self.title = @"会员谱";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"MyServiceCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    __weak typeof(self) weakSelf = self;
    [BackgroundService PeizhiPushVC:self RequestAction:^{
        [weakSelf.dataArray removeAllObjects];
        NSArray * arr = [AuthenticationModel getmember_menu];
        for (NSDictionary *dic in arr) {
            MyServiceModel *model =[MyServiceModel yy_modelWithJSON:dic];
            [weakSelf.dataArray addObject:model];
        }
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
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyServiceCell" forIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell 赋值
    MyServiceModel *model = self.dataArray[indexPath.row];
    cell.label.text = model.title;
    
    // cell 其他配置
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
     
     //cell 背景颜色
     cell.backgroundColor = [UIColor yellowColor];
     //分割线
     tableView.separatorStyle = UITableViewCellSelectionStyleNone;
     */
    return cell;
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转
    SpectrumViewController * VC = [[SpectrumViewController alloc]init];
    VC.url = ((MyServiceModel*)self.dataArray[indexPath.row]).url;
    NSLog(@"%@",VC.url);

   [self.navigationController  pushViewController:VC animated:YES];
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
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
