//
//  MyOrderController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MyOrderController.h"
#import "SetPayPasswordController.h"
#import "PayViewController.h"
#import "SetPayPasswordController.h"
#import "PerfectinformationViewController.h"
#import "OrderMainCell.h"
#import "OrderHeaderView.h"
#import "OrderFooterView.h"
#import "PayGoodsVC.h"
#import "LogisticsVC.h"
#import "GoodsModel.h"
#import "OrderModel.h"
#import "OrderCommentsListVC.h"
#import "ShopCarController.h"
#import "OrderDetailViewController.h"
#import "HomePageVC.h"
#import "FocusMainVC.h"
#import "MyPageController.h"
#import "ClassMainViewController.h"
@interface MyOrderController ()<UITableViewDataSource,UITableViewDelegate,JHCoverViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JHCoverView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///分页参数
@property(nonatomic,assign) int pageIndex;
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
///商品数据
@property (nonatomic,strong)NSMutableArray * GoodsArray;

//1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成 6-全部
@property(nonatomic,strong)NSString *status;
//订单号
@property(nonatomic,strong)NSString *order_no;
@end
@implementation MyOrderController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RefreshMyOrderController:) name:@"RefreshMyOrderController" object:nil];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = self.titleStr;
    self.redView = [[UIView alloc]init ];
    _redView.frame =CGRectMake(0, Width/9-2, Width/5, 2);
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_redView];
    [self.tableView tableViewregisterNibArray:@[@"OrderMainCell"]];
    [self.tableView registerClass:[OrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"OrderHeaderView"];
    [self.tableView registerClass:[OrderFooterView class] forHeaderFooterViewReuseIdentifier:@"OrderFooterView"];
    //密码支付锁
    [self MimaZhiFu];
    __weak typeof(self) weakSelf = self;
    [self showBackBtn:^{
        for (BaseViewController *tempVc in weakSelf.navigationController.viewControllers) {
            if ([tempVc isKindOfClass:[ShopCarController class]]) {
                
                [weakSelf.navigationController popToViewController:tempVc animated:YES];
            }else if ([tempVc isKindOfClass:[HomePageVC class]]) {
                [weakSelf.navigationController popToViewController:tempVc animated:YES];
            }else if ([tempVc isKindOfClass:[MyPageController class]]) {
                [weakSelf.navigationController popToViewController:tempVc animated:YES];
            }
            else if ([tempVc isKindOfClass:[ClassMainViewController class]]) {
                
                [weakSelf.navigationController popToViewController:tempVc animated:YES];
            }else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }
        }
        

    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - 关于数据
-(void)SET_DATA{
    if ([self.titleStr isEqualToString:@"全部"]) {
        self.status = @"6";
        [self changeRedView:_allOrderBtn];
        _redView.frame =CGRectMake(0, Width/9-2, Width/5, 2);
    }else if ([self.titleStr isEqualToString:@"待付款"]){
        [self changeRedView:_WaitingPayBtn];
        self.status = @"1";
        _redView.frame =CGRectMake(Width/5, Width/9-2, Width/5, 2);
        
    }else if ([self.titleStr isEqualToString:@"待收货"]){
        [self changeRedView:_WaitingGoodsBtn];
        self.status = @"3";
        _redView.frame =CGRectMake(Width/5*2, Width/9-2, Width/5, 2);
    }else if ([self.titleStr isEqualToString:@"待评论"]){
        [self changeRedView:_WaitingCommentsBtn];
        self.status = @"4";
        _redView.frame =CGRectMake(Width/5*3, Width/9-2, Width/5, 2);
    }else if ([self.titleStr isEqualToString:@"已完成"]){
        [self changeRedView:_successBtn];
        self.status = @"5";
        _redView.frame =CGRectMake(Width/5*4, Width/9-2, Width/5, 2);
        
    }
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.GoodsArray = [NSMutableArray arrayWithCapacity:1];
    //上拉刷新下拉加载
    [self Refresh];
    //网络请求
    [self requestAction];
    
    
}
-(void)Refresh{
    //下拉刷新
    __weak typeof(self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex =1 ;
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_header endRefreshing];
        
    }];
    //上拉加载
    self.tableView. mj_footer=
    [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex ++ ;
        NSLog(@"%d",weakself.pageIndex);
        [weakself requestAction];
        // 进入刷新状态后会自动调用这个block
        [weakself.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 网络请求
-(void)requestAction{
    //    [self.dataArray removeAllObjects];
    //    [self.GoodsArray removeAllObjects];
    NSString *Token =[AuthenticationModel getLoginToken];
    //NSLog(@"Token----- %@",Token);
    GoodsModel*model = [[GoodsModel  alloc]init];
    model.status =self.status;
    model.pageIndex =[NSString stringWithFormat:@"%d",self.pageIndex];
    model.pageCount = @"10";
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestMyOrderList" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            if (weakself.pageIndex == 1) {
                [weakself.dataArray removeAllObjects];
                [weakself.GoodsArray removeAllObjects];
            }
            NSLog(@"订单列表----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                NSMutableArray *DataArray = response[@"data"];
                for (NSDictionary *OrderDic in DataArray) {
                    OrderModel *Ordermodel = [OrderModel yy_modelWithJSON:OrderDic];
                    [weakself.dataArray addObject:Ordermodel];
                    NSMutableArray * GoodsArr= OrderDic[@"goods"];
                    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary * goosdic in GoodsArr) {
                        GoodsModel *goodsModel = [GoodsModel yy_modelWithJSON:goosdic];
                        [arr addObject:goodsModel];
                    }
                    [self.GoodsArray addObject:arr];
                    
                }
                //刷新
                [weakself.tableView reloadData];
                
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
    
}

#pragma mark - 网络请求
-(void)requestCancelOrderAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    OrderModel*model = [[OrderModel  alloc]init];
    model.order_no =self.order_no;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestCancelOrder" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            NSLog(@"取消订单----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
#warning 请求接口---
                [weakself requestAction];
                
                
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}
#pragma mark - 通知刷新界面
-(void)RefreshMyOrderController:(NSNotification*)sender{
    // [self requestAction];
    
    
}
#pragma mark - 全部订单
- (IBAction)AllOrderBtnAc:(UIButton *)sender {
    [self changeRedView:self.allOrderBtn];
    self.pageIndex = 1;
    self.status = @"6";
    [self requestAction];
    
}
#pragma mark - 等待付款
- (IBAction)WaitingPayBtnAction:(UIButton *)sender {
    [self changeRedView:sender];
    self.pageIndex = 1;
    self.status = @"1";
    [self requestAction];
    
    
}
#pragma mark - 等待收货
- (IBAction)WaitingGoodsBtnAction:(UIButton *)sender {
    [self changeRedView:self.WaitingGoodsBtn];
    self.pageIndex = 1;
    self.status = @"3";
    [self requestAction];
}
#pragma mark - 等待评价
- (IBAction)WaitingCommentsAction:(UIButton *)sender {
    [self changeRedView:self.WaitingCommentsBtn];
    self.pageIndex = 1;
    self.status = @"4";
    [self requestAction];
    
}
#pragma mark - 完成订单
- (IBAction)SuccessBtnAction:(UIButton *)sender {
    [self changeRedView:self.successBtn];
    self.pageIndex = 1;
    self.status = @"5";
    [self requestAction];
}

#pragma mark - 修改buttion颜色和RedView的Frame
-(void)changeRedView:(UIButton*)sender{
    for (id tempView in _bottomView.subviews) {
        if ([tempView isKindOfClass:[UIButton class]]) {
            UIButton *btn = tempView;
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        _redView.frame = CGRectMake(sender.frame.origin.x, sender.frame.size.height, sender.frame.size.width, _redView.frame.size.height);
        
    }];
    [sender setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    
    
}

#pragma tableView 代理方法
//tab分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [tableView tableViewDisplayWitimage:@"暂无订单"ifNecessaryForRowCount:self.dataArray.count];
    //分区个数
    return self.dataArray.count;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.GoodsArray[section];
    
    return arr.count>3 ? 3 :arr.count;
}
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMainCell" forIndexPath:indexPath];
    NSArray *arr = self.GoodsArray[indexPath. section];
    
    [cell cellGetData:(GoodsModel*)arr[indexPath.row]];
    //cell选中时的颜色 无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    return cell;
}
#pragma mark - 分区页眉
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderHeaderView" ];
    [header cellGetData:(OrderModel*)self.dataArray[section]];
    return header;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    OrderFooterView * footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderFooterView" ];
    
    NSIndexPath * ind = [NSIndexPath indexPathWithIndex:section];
    footer.oneBtn.indexPath = ind;
    footer.twoBtn.indexPath = ind;
    [footer.oneBtn addTarget:self action:@selector(oneBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [footer.twoBtn addTarget:self action:@selector(twoBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    NSArray *arr = self.GoodsArray[section];
    NSMutableArray * numArray = [@[]mutableCopy];
    for (GoodsModel*model in arr) {
        [numArray addObject:model.num];
    }
    //总价格
    NSNumber *sum = [numArray valueForKeyPath:@"@sum.floatValue"];
    footer.number.text = [NSString stringWithFormat:@"共%@件商品",sum];
    [footer cellGetData:(OrderModel*)self.dataArray[section]];
    return footer;
    
    
}
#pragma mark - Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Push 跳转 订单详情
    OrderDetailViewController * VC = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
    VC.order_no = ((OrderModel*)self.dataArray[indexPath.section]).order_no;
    [self.navigationController  pushViewController:VC animated:YES];
    
    
}
#pragma mark - 查看物流
-(void)oneBtnAction:(PublicBtn*)sender{
    OrderModel *model =self.dataArray[sender.indexPath.section];
    self.order_no = model.order_no;
    if ([model.status isEqualToString:@"1"]) {
        //@"待付款";
        [self alertWithTitle:@"取消订单" message:nil OKWithTitle:@"确定" CancelWithTitle:@"再想想" withOKDefault:^(UIAlertAction *defaultaction) {
            //取消订单
            [self requestCancelOrderAction];

        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
        
    }else {
        
        //跳转 查看物流
        LogisticsVC * VC = [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        VC.order_no = self.order_no        ;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    
    
}

#pragma mark - 去支付
-(void)twoBtnAction:(PublicBtn*)sender{
    OrderModel *model =self.dataArray[sender.indexPath.section];
    self.order_no = model.order_no;
    if ([model.status isEqualToString:@"1"]) {
        
        // @"待付款";
        //Push 跳转
        PayGoodsVC * VC = [[PayGoodsVC alloc]initWithNibName:@"PayGoodsVC" bundle:nil];
        VC.allPrice = model.amount;;
        NSDictionary * orederDic = @{@"order_no":self.order_no,@"amount":model.amount};
        // NSArray * arr = @[orederDic];
        NSDictionary *dic = @{@"1":orederDic};
        VC.orderData = dic;
        [self.navigationController  pushViewController:VC animated:YES];
    }else if ([model.status isEqualToString:@"2"]) {
        // @"待发货";
#warning 提醒返货----
        //跳转 查看物流
        LogisticsVC * VC = [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        VC.order_no = self.order_no        ;
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else if ([model.status isEqualToString:@"3"]) {
        // @"已发货";
#warning 确认收货----
        NSString * isset_paypwd  = [NSString stringWithFormat:@"%@",[AuthenticationModel getisset_paypwd]];
        if ( [isset_paypwd isEqualToString:@"0"]) {
            //说明没有支付密码
            [self alertWithTitle:@"设置支付密码" message:nil OKWithTitle:@"去设置" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                VC.title = @"设置支付密码";
                [self.navigationController pushViewController:VC animated:YES];
            } withCancel:^(UIAlertAction *cancelaction) {
                
            }];
        }else{
            self.coverView.hidden = NO;
            [self.coverView.payTextField becomeFirstResponder];
        }
        
        
    }else if ([model.status isEqualToString:@"4"]) {
        // @"待评价";
#warning 去评价----
        //Push 跳转
        OrderCommentsListVC * VC = [[OrderCommentsListVC alloc]initWithNibName:@"OrderCommentsListVC" bundle:nil];
        VC.order_no = ((OrderModel*)self.dataArray[sender.indexPath.section]).order_no;
        VC.goodsArray = self.GoodsArray[sender.indexPath.section];
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else if ([model.status isEqualToString:@"5"]) {
        //@"已完成";
#warning 再次购买----
        //跳转 查看物流
        LogisticsVC * VC = [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        VC.order_no = self.order_no        ;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.25*Width+1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Width/10+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Width/5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 密码支付锁
//密码支付锁
-(void)MimaZhiFu{
    [self.view layoutIfNeeded];
    
    JHCoverView *coverView = [[JHCoverView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    coverView.delegate = self;
    self.coverView = coverView;
    coverView.hidden = YES;
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:coverView];
}

/**
 忘记密码
 */
- (void)forgetPassWordCoverView:(JHCoverView *)control
{
    SetPayPasswordController *setPay = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
    setPay.title = @"修改支付密码";
    setPay.act = @"act=Api/User/requestUpdatePayPassword";
    [self.navigationController pushViewController:setPay animated:YES];
    
    NSLog(@"忘记密码");
}
//密码正确
- (void)inputCorrectCoverView:(JHCoverView *)control password:(NSString *)passWord
{
    // NSLog(@"支付码的状态%@",[AuthenticationModel getisset_paypwd]);
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        //NSDictionary * dic = [self.orderStr yy_modelToJSONObject];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"order_no":self.order_no,@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestConfirmReceive" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"确认收货-----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
#warning 请求接口---
                [weakself requestAction];
                
            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakself showToast:@"支付密码错误"];
                [weakself alertWithTitle:@"支付密码错误" message: response[@"msg"]OKWithTitle:@"重新支付" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    weakself.coverView.hidden = NO;
                    [weakself.coverView.payTextField becomeFirstResponder];
                } withCancel:^(UIAlertAction *cancelaction) {
                    SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                    VC.title = @"设置支付密码";
                    [weakself.navigationController pushViewController:VC animated:YES];
                }];
            }else if ([response[@"resultCode"] isEqualToString:@"34"]) {
                [ weakself alertWithTitle:@"支付已被冻结"message:response[@"msg"] OKWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    
                }];
                
            }else if ([response[@"resultCode"] isEqualToString:@"2006"]) {
                [weakself showToast:@"已经是创业会员"];
            }else{
                [weakself showToast:response[@"msg"]];
                
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - dealloc
- (void)dealloc
{  [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@销毁了", [self class]);
}
@end
