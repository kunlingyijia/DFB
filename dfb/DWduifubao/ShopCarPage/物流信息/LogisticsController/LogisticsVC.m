//
//  LogisticsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "LogisticsVC.h"
#import "LogisticsOneCell.h"
#import "LogisticsTwoCell.h"
#import "OrderModel.h"
#import "LogisticsModel.h"
@interface LogisticsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)OrderModel *orderModel;
@end

@implementation LogisticsVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }return _dataArray;
}
-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        self.imageArr = [NSMutableArray arrayWithCapacity:0];
        
    }return _imageArr;
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
    self.title = @"订单追踪";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView tableViewregisterNibArray:@[@"LogisticsOneCell",@"LogisticsTwoCell"]];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
//    for (int i =0; i<10; i++) {
//        [self.dataArray addObject:[NSString stringWithFormat:@"我是第%d行",i]];
//    }
//
    //上拉刷新下拉加载
   // [self Refresh];
    self.orderModel = [[OrderModel alloc]init];
    //网络请求
    [self requestAction];
    
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       // weakself.pageIndex ++ ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    [self.dataArray removeAllObjects];
    [self.imageArr removeAllObjects] ;
    NSString *Token =[AuthenticationModel getLoginToken];
    OrderModel*model = [[OrderModel  alloc]init];
    model.order_no =self.order_no;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestLogistics" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            NSLog(@"物流列表----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                NSMutableDictionary * dic = response[@"data"];
                self.orderModel = [OrderModel yy_modelWithJSON:dic];
               //查询的结果状态。0：运单暂无结果，1：查询成功
                NSString * status = [NSString stringWithFormat:@"%@" ,dic[@"status"]];
                //NSLog(@"------%@",status);
                
                
                if ([status isEqualToString:@"0"]) {
                    //暂无数据
                }else{
                    NSMutableArray * arr =dic [@"data"];
                    for (NSDictionary * LogisticsDic in arr) {
                        LogisticsModel *model = [LogisticsModel yy_modelWithJSON:LogisticsDic];
                        [weakself.dataArray addObject:model];
                    }
                }
                
                
                [weakself addimageToCell];
                //刷新
                [weakself.tableView reloadData];
                
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}
#pragma mark - 图片添加判断条件
-(void)addimageToCell{
    
    int a = (int)self.dataArray.count;
    
    if (a==0) {
        [self.imageArr removeAllObjects];
        [self.imageArr addObject:@"red_point"];
    }else if(a==1){
        [self.imageArr removeAllObjects];
        self.imageArr  = [@[@"red_line" ,@"line_up"]mutableCopy];
    }else if (a>1){
        [self.imageArr  addObject:@"red_line"];
        NSLog(@"%@",self.imageArr);
        for (int i=1; i<a-1; i++) {
            
            [self.imageArr  addObject:@"line_center"];
        }
        [self.imageArr  addObject:@"line_up"];
    }else{
    }
    
    
}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //分区个数
    return 2;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return _dataArray.count==0?0:1;
        }
            break;
        case 1:
        {   [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:_dataArray.count];
            return self.dataArray.count;
        }
            break;

        default:{
            return 0;

        }
            break;
    }
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   tableView.separatorStyle = UITableViewCellAccessoryNone;
    switch (indexPath. section) {
        case 0:
        {
            LogisticsOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsOneCell" forIndexPath:indexPath];
            //cell 赋值
            //cell选中时的颜色 无色
            [cell cellGetData:self.orderModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
            break;
        case 1:
        {
            LogisticsTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsTwoCell" forIndexPath:indexPath];
            //cell 赋值
            cell.LogisticsImageview.image = [UIImage imageNamed:[NSString stringWithFormat: @"%@",self.imageArr[indexPath.row]]];
            [cell cellGetData:(LogisticsModel *)self.dataArray[indexPath.row]];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
           
        }
            break;
            
        default:{
            return nil;
            
        }
            break;
    }

   
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return Width/6+10;
    }else{
    //用storyboard 进行自适应布局
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    }
    
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
