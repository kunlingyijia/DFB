//
//  PayGoodsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PayGoodsVC.h"

#import "SetPayPasswordController.h"
#import "PayViewController.h"
#import "SetPayPasswordController.h"
#import "PerfectinformationViewController.h"
#import "BackgroundService.h"
#import "MyOrderController.h"
#import "ScoreExchangeController.h"
@interface PayGoodsVC ()<JHCoverViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JHCoverView *coverView;



@end

@implementation PayGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showMyselfBackBtn];
    self.title = @"兑换平台";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //密码支付锁
    [self MimaZhiFu];
    //请求配置信息网络请求
  
    self.price.text =[NSString stringWithFormat:@"%@", self.allPrice];
    NSLog(@"价格---%@---%@",self.price.text,self.allPrice);
    
    
}
- (void)showMyselfBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左.png"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
    //屏幕边缘移动手势
    //创建屏幕边缘平移手势
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBack:)];
    
    //设置平移的屏幕边界
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //添加到视图
    [self.view addGestureRecognizer:screenEdgePanGesture];
    
}


- (void)doBack:(id)sender{
    //Push 跳转
    MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
    VC.titleStr = @"全部";
    [self.navigationController  pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    
    //获取个人信息
    [BackgroundService requestPushVC:self MyselfAction:^{
        ///兑富金币
        weakSelf.cashlabel.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getvirtual_glod ]floatValue]] ;
    }];
}
#pragma mark -   去兑换
- (IBAction)TopUp:(UIButton *)sender {
    ScoreExchangeController *scoreExchangeController = [[ScoreExchangeController alloc] initWithNibName:@"ScoreExchangeController" bundle:nil];
    scoreExchangeController.scoreAll = [[AuthenticationModel getscore]intValue];
    [self.navigationController pushViewController:scoreExchangeController animated:YES];
    
}
#pragma mark -确认支付
- (IBAction)paymentAction:(UIButton *)sender {
    if ([self.cashlabel.text floatValue ]<[self.allPrice floatValue] ) {
        [self showToast:@"兑富金币余额不足"];
        return;
    }
    NSString * isset_paypwd  = [NSString stringWithFormat:@"%@",[AuthenticationModel getisset_paypwd]];
    __weak typeof(self) weakSelf = self;

    if ( [isset_paypwd isEqualToString:@"0"]) {
        //说明没有支付密码
        [self alertWithTitle:@"设置支付密码" message:nil OKWithTitle:@"去设置" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
            VC.title = @"设置支付密码";
            [weakSelf.navigationController pushViewController:VC animated:YES];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }else{
        self.coverView.hidden = NO;
        [self.coverView.payTextField becomeFirstResponder];
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
    // NSLog(@"支付码的状态%@",[AuthenticationModel getisset_paypwd]);
    NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        //NSDictionary * dic = [self.orderStr yy_modelToJSONObject];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"order":self.orderData,@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Mall/requestPayGoodsOrder" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                for (BaseViewController *tempVC in weakself.navigationController.viewControllers) {
                    if ([tempVC isKindOfClass:[MyOrderController class]]) {
                        [weakself.navigationController popToViewController:tempVC animated:YES];
                        return ;
                    }
                }
                //Push 跳转
                MyOrderController * VC = [[MyOrderController alloc]initWithNibName:@"MyOrderController" bundle:nil];
                VC.titleStr = @"全部";
                [weakself.navigationController  pushViewController:VC animated:YES];
            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakself showToast:@"支付密码错误"];
                [weakself alertWithTitle:@"支付密码错误" message: response[@"msg"] OKWithTitle:@"重新支付" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    weakself.coverView.hidden = NO;
                    [weakself.coverView.payTextField becomeFirstResponder];
                } withCancel:^(UIAlertAction *cancelaction) {
                    SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                    VC.title = @"设置支付密码";
                    [weakself.navigationController pushViewController:VC animated:YES];
                }];
            }else if ([response[@"resultCode"] isEqualToString:@"34"]) {
//                [weakself showToast:@"支付已被冻结，请隔天再试"];
                
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
