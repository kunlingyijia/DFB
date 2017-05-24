//
//  OrderDetailViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CarModel.h"
#import "HeaderModel.h"
#import "AddressModel.h"
#import "SubmitOrderHeaderView.h"
#import "SubmitOrderFooterView.h"
#import "AddressHeaderView.h"
#import "SubmitOrdersCell.h"
#import "OrderModel.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderDetailThreeCell.h"
#import "OrderDetailFiveCell.h"
#import "OrderDetailFourCell.h"
#import "LogisticsVC.h"
#import "PayGoodsVC.h"
#import "SetPayPasswordController.h"
#import "OrderCommentsListVC.h"
@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JHCoverViewDelegate,UITextFieldDelegate>{
    dispatch_source_t _timer;
   }
@property (nonatomic, strong) JHCoverView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

///数据
@property (nonatomic,strong)OrderModel * orderModel;
@property (nonatomic,strong)NSMutableArray * GoodsArray;
//1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成 6-全部
@property(nonatomic,strong)NSString *status;


@end

@implementation OrderDetailViewController

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
    [self ShowNodataView];
    self.title = @"订单详情";
    self.oneBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.oneBtn.layer.borderWidth = 0.5;
    self.oneBtn.layer.masksToBounds = YES;
    self.oneBtn.layer.cornerRadius = 5;
    self.twoBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.twoBtn.layer.borderWidth = 0.5;
    self.twoBtn.layer.masksToBounds = YES;
    self.twoBtn.layer.cornerRadius = 5;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self.tableView tableViewregisterNibArray:@[@"OrderDetailOneCell",@"OrderDetailTwoCell",@"OrderDetailThreeCell",@"OrderDetailFourCell",@"OrderDetailFiveCell"]];
    self.label.hidden = YES;
    self.time_remain.hidden = YES;
    //密码支付锁
    [self MimaZhiFu];
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    self.orderModel = [[OrderModel alloc]init];
    self.GoodsArray = [NSMutableArray arrayWithCapacity:0];
//   //请求接口
    //[self requestAction];
    __weak typeof(self) weakSelf = self;
    //GCD定时器
    NSTimeInterval period = 60.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        NSLog(@"每秒执行test");
        [weakSelf requestAction];
    });
    
    dispatch_resume(_timer);

}
 #pragma mark -  请求接口
-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    OrderModel*model = [[OrderModel  alloc]init];
    model.order_no =self.order_no;
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestOrderInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            
            NSLog(@"订单详情----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                [weakself.GoodsArray removeAllObjects];
                weakself.orderModel = [OrderModel yy_modelWithJSON:response[@"data"]];
                NSMutableArray * carArr = response[@"data"][@"goods"];
                if ([response[@"data"][@"status"] isEqualToString:@"1"] ) {
                    //待付款
                    weakself.label.hidden = NO;
                    weakself.time_remain.hidden = NO;
                    weakself.time_remain.text = [NSString stringWithFormat:@"%@",response[@"data"][@"time_remain"]];
                }else{
                    //停用计时器
                    dispatch_cancel(_timer);

                }
                
                for (NSDictionary *carDic in carArr) {
                    CarModel * model = [CarModel yy_modelWithJSON:carDic];
                    [weakself.GoodsArray addObject:model];
                }
                //控件赋值
                [weakself BtnGetData:weakself.orderModel];
                [weakself HiddenNodataView];
                [weakself.tableView reloadData];
                
                
            }else if([response[@"resultCode"] isEqualToString:@"2011"]){
               
                [ weakself .navigationController popViewControllerAnimated:YES];
                
            }else{
                 [weakself showToast:response[@"msg"]];
            }
            
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
    

    
    
}
#pragma mark - 取消订单网络请求
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
                
#warning 添加通知刷新我的订单---
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshMyOrderController" object:nil userInfo:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
                
                
                
            }else{
                [weakself showToast:response[@"msg"]];
                
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
    [tableView tableViewDisplayWitimage:nil ifNecessaryForRowCount:self.GoodsArray.count];
    return self.GoodsArray.count==0 ? 0: 5;
}
///tab个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section== 2) {
        return self.GoodsArray.count;
    }else{
        return  1;

    }
  }
//tab设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:
        {
            OrderDetailOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailOneCell" forIndexPath:indexPath];

            [cell cellGetData:self.orderModel];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 1:
        {
            OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTwoCell" forIndexPath:indexPath];
       [cell cellGetData:self.orderModel];            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            

        }
            break;
        case 2:
        {
            OrderDetailThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailThreeCell" forIndexPath:indexPath];
           CarModel *model = self.GoodsArray[indexPath.row];
            
            [cell cellGetData:model];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            
            break;
        case 3:
        {
            OrderDetailFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFourCell" forIndexPath:indexPath];
        [cell cellGetData:self.orderModel];
            //cell选中时的颜色 无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 4:
        {
            OrderDetailFiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailFiveCell" forIndexPath:indexPath];
             [cell cellGetData:self.orderModel];
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
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:{
            
        }
            break;
    }
    
    
}
#pragma mark - Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            return 0.3*Width +10;
            
        }
            break;
        case 1:
        {
            return 0.1*Width;

        }
            break;
        case 2:
        {
            return 0.25*Width;

        }
            
            break;
        case 3:
        {
                //用storyboard 进行自适应布局
            return 0.3*Width +30;
        }
            break;
        case 4:
        {
                //用storyboard 进行自适应布局
                self.tableView.estimatedRowHeight = Width;
                self.tableView.rowHeight = UITableViewAutomaticDimension;
                return self.tableView.rowHeight;
        }
            break;
        default:{
            return 10;
        }
            break;
    }

    

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 控件赋值
-(void)BtnGetData:(OrderModel*)model{
    
    // status	1	int	1-待付款 2-待发货  3-已发货  ,4-待评价，5-已完成
    if ([model.status isEqualToString:@"1"]) {
        self.oneBtn.hidden = NO;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"去付款" forState:(UIControlStateNormal)];
    }else if ([model.status isEqualToString:@"2"]) {
        
        self.oneBtn.hidden = YES;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"3"]) {
        self.oneBtn.hidden = NO;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"确认收货" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"4"]) {
        self.oneBtn.hidden = NO;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
        
    }else if ([model.status isEqualToString:@"5"]) {
        self.oneBtn.hidden = YES;
        self.twoBtn.hidden = NO;
        [self.oneBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [self.twoBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        
    }

    
}
- (IBAction)oneBtnAction:(UIButton *)sender {
  
    self.order_no = self.orderModel.order_no;
    if ([self.orderModel.status isEqualToString:@"1"]) {
        //@"待付款";
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
- (IBAction)twoBtnAction:(UIButton *)sender {
    
    self.order_no = self.orderModel.order_no;
    if ([self.orderModel.status isEqualToString:@"1"]) {
        // @"待付款";
        //Push 跳转
        PayGoodsVC * VC = [[PayGoodsVC alloc]initWithNibName:@"PayGoodsVC" bundle:nil];
        VC.allPrice = self.orderModel.amount;
        NSDictionary * orederDic = @{@"order_no":self.order_no,@"amount":self.orderModel.amount};
        // NSArray * arr = @[orederDic];
        NSDictionary *dic = @{@"1":orederDic};
        VC.orderData = dic;
        [self.navigationController  pushViewController:VC animated:YES];
    }else if ([self.orderModel.status isEqualToString:@"2"]) {
        // @"待发货";
#warning 提醒返货----
        //跳转 查看物流
        LogisticsVC * VC = [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        VC.order_no = self.order_no        ;
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else if ([self.orderModel.status isEqualToString:@"3"]) {
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
        
        
    }else if ([self.orderModel.status isEqualToString:@"4"]) {
        // @"待评价";
#warning 去评价----
        //Push 跳转
        OrderCommentsListVC * VC = [[OrderCommentsListVC alloc]initWithNibName:@"OrderCommentsListVC" bundle:nil];
        VC.order_no = self.order_no;
        VC.goodsArray = self.GoodsArray;
        [self.navigationController  pushViewController:VC animated:YES];
        
    }else if ([self.orderModel.status isEqualToString:@"5"]) {
        //@"已完成";
#warning 再次购买----
        //跳转 查看物流
        LogisticsVC * VC = [[LogisticsVC alloc]initWithNibName:@"LogisticsVC" bundle:nil];
        VC.order_no = self.order_no        ;
        [self.navigationController  pushViewController:VC animated:YES];
    }
    
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
    
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"order_no":self.order_no,@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestConfirmReceive" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"确认收货-----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
#warning 添加通知刷新我的订单---
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshMyOrderController" object:nil userInfo:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
                

                
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

@end
