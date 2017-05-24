//
//  WithdrawalViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/7.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "SetPayPasswordController.h"
#import "BackgroundService.h"
#import "MoneyViewController.h"
@interface WithdrawalViewController ()<JHCoverViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@property (nonatomic, strong) JHCoverView *coverView;


@end
///提现
@implementation WithdrawalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    self.title = @"提现";
   
    //密码支付锁
    [self MimaZhiFu];
    __weak typeof(self) weakSelf = self;
    //请求配置信息网络请求
    [BackgroundService PeizhiPushVC:nil RequestAction:^{
        ///兑换比例描述
        weakSelf.draw_formulaLabel.text = [AuthenticationModel getdraw_formula] ;
        
    }];
    ////兑换积分添加方法
    [self.cashTextfield addTarget:self action:@selector(cashTextfield:) forControlEvents:(UIControlEventEditingChanged)];
    self.cashTextfield.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
     //请求个人信息
    [BackgroundService requestPushVC:self MyselfAction:^{
        //控件赋值
        [weakSelf KongJianFuZhi];
    }];
}
#pragma mark -  ////兑换积分添加方法
-(void)cashTextfield:(UILabel*)sender{
    if (sender.text.length==0) {
         self.automaticTextf.text  = @"";
    }else{
    NSString *str = [NSString  stringWithFormat:@"%@",sender.text ];
    CGFloat score = [str doubleValue];
    
    self.automaticTextf.text =[NSMutableString stringWithFormat:@"%.2f",   score*[[AuthenticationModel getdraw_param  ]doubleValue]] ;
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cashTextfield) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}


#pragma mark - 提现的时间
- (IBAction)TiXianAction:(UIButton *)sender {

    if ([self.virtual_glodAndcashLabel.text floatValue] < [self.cashTextfield.text floatValue]) {
        [self showToast:@"余额不足"];
        return ;
    }
    if ([self.cashTextfield.text floatValue]<0.009) {
        [self showToast:@"额度不能为0"];
        return ;
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


//密码支付锁
-(void)MimaZhiFu{
    [self.view layoutIfNeeded];
    
    JHCoverView *coverView = [[JHCoverView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-60)];
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
/**
 JHCoverViewDelegate的代理方法，密码输入正确
 */
- (void)inputCorrectCoverView:(JHCoverView *)control password:(NSString *)passWord
{
        NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakSelf = self;

    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"cash":self.cashTextfield.text,@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Finance/requestApplyDraw" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"%@",response[@"msg"]);
            //[self.navigationController popViewControllerAnimated:YES];
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MoneyViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }


                
            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakSelf showToast:@"支付密码错误"];
                [weakSelf alertWithTitle:@"支付密码错误" message: response[@"msg"]OKWithTitle:@"重新支付" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    weakSelf.coverView.hidden = NO;
                    [weakSelf.coverView.payTextField becomeFirstResponder];
                } withCancel:^(UIAlertAction *cancelaction) {
                    SetPayPasswordController  *VC = [[SetPayPasswordController alloc]initWithNibName:@"SetPayPasswordController" bundle:nil];
                    VC.title = @"设置支付密码";
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }];
            }else if ([response[@"resultCode"] isEqualToString:@"34"]) {
                [ weakSelf alertWithTitle:@"支付已被冻结"message:response[@"msg"] OKWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
                    
                }];
                
            }else if ([response[@"resultCode"] isEqualToString:@"2006"]) {
                [weakSelf showToast:@"已经是创业会员"];
            }else{
                [weakSelf showToast:response[@"msg"]];
  
            }
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }else {
        
    }
    
}
#pragma mark - 控件赋值
-(void)KongJianFuZhi{
    ///总余额
    self.virtual_glodAndcashLabel.text = [NSString stringWithFormat:@"%.2f", self.virtual_glodAndcash];
    ///银行卡
    NSString *bank_account_number = [NSString stringWithFormat:@"%@",[[AuthenticationModel getbank_account_number] substringFromIndex:[AuthenticationModel getbank_account_number].length- 4 ]];
    self.banklabel.text = bank_account_number;

    
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
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
