//
//  ExchangeDFBaoController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "ExchangeDFBaoController.h"
#import "SetPayPasswordController.h"
#import "BackgroundService.h"
#import "ScoreRecordController.h"
#import "PayGoodsVC.h"
@interface ExchangeDFBaoController ()<JHCoverViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@property (nonatomic, strong) JHCoverView *coverView;


@end

@implementation ExchangeDFBaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.score.text = [NSString stringWithFormat:@"%ld", (long)self.scoreAll];
    self.title = @"兑换兑富金币+现金";
    
   // 兑换比例: 10000积分=4000兑富金币,兑换的数量必须是100的整数倍
    [self endEditingAction:self.view];
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    //密码支付锁
    [self MimaZhiFu];
    //请求配置信息网络请求
    __weak typeof(self) weakSelf = self;

    [BackgroundService PeizhiPushVC:nil RequestAction:^{
        weakSelf.XianshiLabel.text =[AuthenticationModel getexchange_formula];
    }];
    self.exchangeScore.delegate = self;
    ////兑换积分添加方法
    [self.exchangeScore addTarget:self action:@selector(exchangeScore:) forControlEvents:(UIControlEventEditingChanged)];
}
#pragma mark -  ////兑换积分添加方法
-(void)exchangeScore:(UILabel*)sender{
    if (sender.text.length==0) {
        self.to_dfglod.text = @"";
         self.to_dfbao.text = @"";
    }else{
    NSString *str = [NSString  stringWithFormat:@"%@",sender.text ];
    CGFloat score = [str doubleValue];
    self.to_dfglod.text =[NSMutableString stringWithFormat:@"%.2f",   score*[[AuthenticationModel getto_glod_param  ]doubleValue]] ;
    self.to_dfbao.text= [NSMutableString stringWithFormat:@"%.2f", score*[[AuthenticationModel getto_cash_param  ]doubleValue]];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.exchangeScore) {
        
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [BackgroundService requestPushVC:self MyselfAction:^{
        
    }];
}


#pragma mark -"兑换"的按钮事件
- (IBAction)exchangeBtnAction:(id)sender {
    //NSLog(@"----%@",self.score.text);
    if ([self.score.text intValue] < [self.exchangeScore.text intValue]||self.exchangeScore.text.length==0) {
        [self showToast:@"积分不足"];
        return ;
    }
    if ([self.exchangeScore.text intValue]%100 !=0||[self.exchangeScore.text intValue]==0) {
        [self showToast:@"请输入100的整数倍"];
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
        baseReq.data = [AESCrypt encrypt:[@{@"score":self.exchangeScore.text,@"pay_password":[passWord MD5Hash]} yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Score/requestScoreExchange" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self  success:^(id response) {
            NSLog(@"%@",response[@"msg"]);
            //[self.navigationController popViewControllerAnimated:YES];
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                self.score = response[@"data"][@"score"];
                for(UIViewController *temVC in self.navigationController.viewControllers)
                    
                {
                    
                    if ([temVC isKindOfClass:[ScoreRecordController class]])
                        
                    {
                        
                        [self.navigationController popToViewController:temVC animated:YES];
                        
                    }
                    if ([temVC isKindOfClass:[PayGoodsVC class]])
                        
                    {
                        
                        [self.navigationController popToViewController:temVC animated:YES];
                        
                    }
                    
                    
                }


            }else if ([response[@"resultCode"] isEqualToString:@"33"]) {
                [weakSelf showToast:@"支付密码错误"];
                [weakSelf alertWithTitle:@"支付密码错误" message: response[@"msg"]OKWithTitle:@"重新支付" CancelWithTitle:@"修改密码" withOKDefault:^(UIAlertAction *defaultaction) {
                    self.coverView.hidden = NO;
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

@end
