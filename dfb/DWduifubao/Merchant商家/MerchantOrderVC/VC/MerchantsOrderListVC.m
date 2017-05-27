//
//  MerchantsOrderListVC.m
//  自定义弹窗
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import "MerchantsOrderListVC.h"
#import "CTPopViewSingle.h"
#import "MerchantOrderListCell.h"
#import "XFDaterView.h"
#import "GoodsModel.h"
#import "OrderModel.h"
@interface MerchantsOrderListVC ()<XFDaterViewDelegate>{
    XFDaterView*dater;
    XFDaterView*timer;
}
///数据
@property (nonatomic,strong)NSArray * LeftArray;

@property(nonatomic,strong)NSString * dateString;
@property(nonatomic,strong)NSString * status;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///分页参数
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation MerchantsOrderListVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

//视图即将加入窗口时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO  animated:animated];
    
    
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
   self.title = @"订单管理";
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius =5.0;
    self.bottomView.layer.borderWidth = 0.5;
    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MerchantOrderListCell" bundle:nil] forCellReuseIdentifier:@"MerchantOrderListCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.LeftArray =@[@"全 部",@"已下单",@"待发货",@"待收货",@"待评价",@"已完成"];
   
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    self. dateString = [dateFormatter stringFromDate:currentDate];
    [self.MiddleBtn setTitle:[NSString stringWithFormat:@"%@",self.dateString ] forState:(UIControlStateNormal)];
    self.status = @"0";
    self.pageIndex =1 ;
    [self requestOrderList];
    [self Refresh];
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestOrderList];
        
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%ld",(long)weakself.pageIndex);
        [weakself requestOrderList];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark -店铺订单列表（商户））
-(void)requestOrderList{
   
    NSMutableDictionary *dic  =[ @{@"pageIndex":@(self.pageIndex),@"pageCount":@(10),@"merchant_id":self.merchant_id,@"create_time":self.dateString,@"status":self.status }mutableCopy];
     NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[dic yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Merchant/requestOrderList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"店铺订单列表（商户）--%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableArray * arr = response[@"data"];
                [weakSelf.dataArray removeAllObjects];
                for (NSDictionary *dic in arr) {
                    OrderModel * model = [OrderModel yy_modelWithJSON:dic];
                    [weakSelf.dataArray addObject:model];
                }
                [weakSelf.tableView reloadData];
                
                
            }else{
                [weakSelf showToast:response[@"msg"]];
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
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
    return 10;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MerchantOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MerchantOrderListCell" forIndexPath:indexPath];
    
    //cell 赋值
    OrderModel * model =  self.dataArray[indexPath.row];
    [cell cellGetData:model];
    
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
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.2*Width;
    
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
-(void)SET_SubViews{
  
    
    
    
}
- (IBAction)LeftBtnAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    [[CTPopViewSingle  shareManager]showPopMenuSelecteWithFrame:[UIScreen mainScreen].bounds.size.width X:50 Y:74+10+30 item:_LeftArray action:^(NSInteger index) {
        NSLog(@"%ld",index);
        weakSelf.status = [NSString stringWithFormat:@"%ld",(long)index];
        [weakSelf.LeftBtn setTitle:[NSString stringWithFormat:@"%@",weakSelf.LeftArray[index]] forState:(UIControlStateNormal)];

     
    }];

}
- (IBAction)middleBtnAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    if (!dater) {
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        dater.dateViewType=XFDateViewTypeDate;
    }else{
        [dater showInView:self.view animated:YES];
    }

}
#pragma mark -
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    if ([daterView isEqual:dater]) {
        
        [self.MiddleBtn setTitle:daterView.dateString forState:(UIControlStateNormal)];
        self.dateString = daterView.dateString;
        
    }
    
    
}
#pragma mark -  日历取消
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    
    
    
    
}
- (IBAction)RigjtAction:(UIButton *)sender {
    self.pageIndex =1 ;
    [self requestOrderList];

}




@end
