//
//  BuyNemberViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BuyNemberViewController.h"
#import "SetPayPasswordController.h"
#import "PayViewController.h"
#import "SetPayPasswordController.h"
#import "SuccessViewController.h"
#import "PerfectinformationViewController.h"
#import "BackgroundService.h"
@interface BuyNemberViewController ()<JHCoverViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) JHCoverView *coverView;



@end

@implementation BuyNemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self showBackBtn];
    self.title = @"充值";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    self.submitBtn.backgroundColor= [UIColor grayColor];
    self.submitBtn.userInteractionEnabled = NO;
    //密码支付锁
    [self MimaZhiFu];
    
    //请求配置信息网络请求
    __weak typeof(self) weakSelf = self;

    [BackgroundService PeizhiPushVC:nil RequestAction:^{
        //会员价格
        weakSelf.price.text = [AuthenticationModel getupgrade_money];
        weakSelf.upgrade_intro.text =[AuthenticationModel getupgrade_intro];
        
    }];
    
    
   

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;

    //获取个人信息
    [BackgroundService requestPushVC:self MyselfAction:^{
        ///现金
        weakSelf.cashlabel.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getcash ]floatValue]] ;
        weakSelf.glodLabel.text = [NSString stringWithFormat:@"%.2f",[[AuthenticationModel getvirtual_glod]floatValue]];    }];
    CGFloat a =([[AuthenticationModel getcash ]floatValue]+[[AuthenticationModel getvirtual_glod]floatValue]);
    CGFloat b = [[AuthenticationModel getupgrade_money] floatValue];
    
    if (a>b||a==b) {
       
        weakSelf.submitBtn.backgroundColor= [UIColor redColor];
        weakSelf.submitBtn.userInteractionEnabled = YES;
    }
    
}
#pragma mark - 现金 充值
- (IBAction)TopUp:(UIButton *)sender {
    
    PayViewController * payViewController = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    payViewController.title = @"现金充值";
    [self.navigationController pushViewController:payViewController animated:YES];
    
}
#pragma mark - 金币充值
- (IBAction)jinbiChongzhiAction:(UIButton *)sender {
    PayViewController * payViewController = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
   payViewController.title = @"兑富金币充值";
    [self.navigationController pushViewController:payViewController animated:YES];
    
}


#pragma mark -确认支付
- (IBAction)paymentAction:(UIButton *)sender {
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
        
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Entrepreneurship/requestUpgrade" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response);
            
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                
                //Push 跳转
                PerfectinformationViewController * VC = [[PerfectinformationViewController alloc]initWithNibName:@"PerfectinformationViewController" bundle:nil];
                 [weakself.navigationController  pushViewController:VC animated:YES];

                
                
                
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
